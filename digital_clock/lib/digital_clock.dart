// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/src/painting/decoration_image.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:digital_clock/draw_clock.dart';

enum _Theme { background, text, shadow }

final _clockTheme = {
  _Theme.background: Colors.black,
  _Theme.text: Colors.white,
  _Theme.shadow: Colors.black,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  AnimationController controller;
  Animation secondsAnimation;
  Tween<double> secondsTween;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5),
    );
    secondsTween = Tween<double>();
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
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
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      secondsTween.begin =
          (_dateTime.second + _dateTime.millisecond / 1000) ?? 0.0;
      _dateTime = DateTime.now();
      secondsTween.end =
          (_dateTime.second + _dateTime.millisecond / 1000).toDouble();
      secondsAnimation = secondsTween.animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ));
      controller.forward();

      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = _clockTheme;
    final hour = DateFormat('HH').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[_Theme.text],
      fontFamily: 'Open Sans',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0.3,
          color: colors[_Theme.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    return Container(
      color: colors[_Theme.background],
      child: Stack(
        children: <Widget>[
          SvgPicture.asset('assets/background.svg'),
          DrawClock(
            now: _dateTime,
            model: widget.model,
            seconds: secondsAnimation.value,
          ),
        ],
      ),
    );
  }
}
