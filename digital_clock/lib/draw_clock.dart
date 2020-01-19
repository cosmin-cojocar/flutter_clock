import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:flutter_clock_helper/model.dart';
import 'package:digital_clock/draw_radial.dart';

final radiansPerTick = math.radians(360 / 60);
final radiansPerHour = math.radians(360 / 24);

class DrawClock extends StatelessWidget {
  const DrawClock({
    @required DateTime now,
    @required this.model,
    @required this.seconds,
  }) : _now = now;

  final DateTime _now;
  final double seconds;
  final ClockModel model;

  String timeFormatter(int t) => t < 10 ? '0$t' : t.toString();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: CustomPaint(
        // Minute
        painter: DrawRadial(
          position: 0.8,
          angleRadians: _now.minute * radiansPerTick,
          thickness: 3.0,
          colors: [Colors.white, Colors.cyan[200], Colors.cyan[300]],
        ),
        // Hour
        child: CustomPaint(
          painter: DrawRadial(
            position: 0.75,
            angleRadians: _now.hour * radiansPerHour +
                (_now.minute / 60) * radiansPerHour,
            thickness: 5.0,
            colors: [Colors.white, Colors.cyan[200], Colors.cyan[300]],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text(
                  '${timeFormatter(_now.hour)}:${timeFormatter(_now.minute)}',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width / 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
