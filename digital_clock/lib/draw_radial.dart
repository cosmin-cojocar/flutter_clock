import 'package:vector_math/vector_math_64.dart' as math;
import 'package:flutter/material.dart';

class DrawRadial extends CustomPainter {
  List<Color> colors;
  double angleRadians;
  double thickness;
  double position;

  DrawRadial({
    @required this.colors,
    @required this.angleRadians,
    @required this.thickness,
    @required this.position,
  })  : assert(colors != null),
        assert(angleRadians != null),
        assert(thickness != null),
        assert(position > 0.0 && position < 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);

    // Time Path Paint
    Paint paint = Paint()
      ..color = colors[0].withOpacity(0.3)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    canvas.drawCircle(center, size.shortestSide * 0.5 * position, paint);

    // Time Progress Paint
    Paint progressPaint = Paint()
      ..shader = LinearGradient(colors: [colors[1], colors[2]]).createShader(
          Rect.fromCircle(
              center: center, radius: size.shortestSide * 0.5 * position))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    canvas.drawArc(
      Rect.fromCircle(
          center: center, radius: size.shortestSide * 0.5 * position),
      math.radians(-90),
      angleRadians,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
