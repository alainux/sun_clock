import 'dart:math' as math;

const num precisionNumdigits = 3;
final anglePrecision = math.pow(10, precisionNumdigits);

class SolarTime {
  double angle;
  double hour;

  static Map lookupHours = {};
  static Map lookupAngles = {};
  static Map lookupTimes = {};

  SolarTime({DateTime date, double longitude}) {
    // get timezone object
    Duration tz = date.timeZoneOffset;

    // local standard time meridian
    double lstm = 15 * (tz.inMinutes / 60);

    // number of days since start of year
    num d = date.difference(DateTime(date.year, 1, 1, 0, 0)).inDays +
        (date.hour / 24);

    // B is in degrees
    double b = ((360 / 365) * (d - 81)) * (math.pi % 180);

    // equation of time (minutes)
    double eot =
        9.87 * math.sin(2 * b) - 7.53 * math.cos(b) - 1.5 * math.sin(b);

    // time correction factor (minutes)
    double tc = 4 * (longitude - lstm) + eot;

    // local time (hours)
    double lt = date.hour + (date.minute / 60) + (date.second / (60 * 60));

    // local solar time (hours) in 0-24 range
    double lst = (lt + (tc / 60)) % 24;

    // hour angle in a 0-24 range
    double hra = (15 * (lst - 12));

    // set local properties
    hour = lst;
    angle = hra;
  }

  static getFutureValue({dynamic hour, dynamic angle}) {
    String angleString;
    String hourString;

    if (hour != null) {
      if (hour is num) {
        hour = hour.toStringAsFixed(precisionNumdigits);
      }

      angleString = lookupHours[hour];
    }

    if (angle != null) {
      if (angle is num) {
        angle = angle.toStringAsFixed(precisionNumdigits);
      }

      hourString = lookupAngles[angle];
    }

    return {
      'angle': angleString,
      'hour': hourString,
    };
  }

  static generateLookupTables({double longitude, double altitude}) {
    final now = DateTime.now();
    // start of minute
    final thisMinute =
        DateTime(now.year, now.month, now.day, now.hour, now.minute, 0);
    final tomorrow =
        DateTime(now.year, now.month, now.day + 1, now.hour, now.minute, 0);

    final differenceMs = (tomorrow.difference(thisMinute)).inMilliseconds;
    final msInterval = 1000; // 1 second

    for (int ms = 0; ms <= differenceMs; ms += msInterval) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(
          thisMinute.millisecondsSinceEpoch + ms);

      SolarTime solar = SolarTime(date: time, longitude: longitude);

      String angle = solar.angle.toStringAsFixed(precisionNumdigits);
      String hour = solar.hour.toStringAsFixed(precisionNumdigits);

      lookupHours[hour] = angle;
      lookupAngles[angle] = hour;
      lookupTimes[hour] = time;
    }

    return lookupHours;
  }
}
