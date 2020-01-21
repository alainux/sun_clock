// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians, degrees2Radians;

import 'container_hand.dart';
import 'drawn_hand.dart';
import 'drawn_sun.dart';
import 'model/solartime.dart';
import 'utils/position.dart';
import 'dart:math' as math;

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _dur = Duration();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;

  Position _position;
  double _angle = 0;
  double _hour = 12;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    // get users position
    getPosition().then((Position pos) {
      setState(() {
        _position = pos;
        _temperature = widget.model.temperatureString;
        _temperatureRange =
            '(${widget.model.low} - ${widget.model.highString})';
        _condition = widget.model.weatherString;
        _location = widget.model.location;
      });

      SolarTime.generateLookupTables(longitude: pos.longitude);
    });
  }

  void _updateTime() async {
    // get users position
    Position _pos = await getPosition();

    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.

      if (mounted && _pos != null) {
        // get solar data for date and longitude
        SolarTime solar = SolarTime(date: _now, longitude: _pos.longitude);

        _hour = solar.hour;
        _angle = solar.angle;

        _dur = Duration(milliseconds: (_hour * 60 * 60 * 1000).round());
      }

      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  String _formatSolarTime() {
    return [_dur.inHours, _dur.inMinutes, _dur.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  String _formatTime() {
    return [_now.hour, _now.minute, _now.second]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  String _formatLong() {
    return _position != null ? _position.longitude.toStringAsFixed(2) : '';
  }

  String _formatAngle() {
    return _angle != null ? _angle.toStringAsFixed(2) : '';
  }

  String _formatHour() {
    return _hour != null ? _hour.toStringAsFixed(2) : '';
  }

  bool _isDay() {
    return _angle != null ? _angle.abs() <= 66.6 : false;
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final customTheme = _isDay() == true
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Colors.black,
            // Minute hand.
            highlightColor: Colors.grey,
            // Second hand.
            accentColor: Colors.white,
            backgroundColor: Color(0xFFD2E3FC),
          )
        : Theme.of(context).copyWith(
            primaryColor: Colors.white,
            highlightColor: Colors.grey,
            accentColor: Colors.black,
            backgroundColor: Color(0xFF3C4043),
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_isDay() ? 'Good day' : 'Good night'),
          Text('L: ${_formatLong()}'),
          Text('A: ${_formatAngle()}'),
          Text('H: ${_formatHour()}'),
          Text('ST: ${_formatSolarTime()}'),
          Text('LT: ${_formatTime()}'),
          Text(_temperature),
          Text(_temperatureRange),
          Text(_condition),
          Text(_location),
        ],
      ),
    );

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: Stack(
          children: [
            // Example of a hand drawn with [CustomPainter].
            if (_angle != null)
              DrawnSun(
                color: Colors.grey,
                thickness: 1,
                size: 1,
                angleRadians: -1 * _angle * degrees2Radians,
              ),

            DrawnHand(
              color: customTheme.accentColor,
              thickness: 4,
              size: 1,
              angleRadians: (_dur.inSeconds + 1) * radiansPerTick,
            ),
            DrawnHand(
              color: customTheme.highlightColor,
              thickness: 8,
              size: 0.9,
              angleRadians: (_dur.inMinutes + 1) * radiansPerTick,
            ),
            DrawnHand(
              color: customTheme.primaryColor,
              thickness: 4,
              size: 0.5,
              angleRadians: (_dur.inHours + 1) * radiansPerHour,
            ),

            Positioned(
              left: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: weatherInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
