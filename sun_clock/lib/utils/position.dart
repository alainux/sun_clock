import 'package:geolocator/geolocator.dart';

Future<Position> getPosition() async {
  Position pos = await Geolocator().getLastKnownPosition();

  if (pos == null) {
    try {
      pos = await Geolocator().getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  return pos;
}
