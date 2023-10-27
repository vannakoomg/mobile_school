import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1

    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * -0.0013167, size.height * -0.0026333);
    path_0.lineTo(size.width * -0.0028750, size.height * 1.0124000);
    path_0.lineTo(size.width * 1.0031167, size.height * 1.0105333);
    path_0.lineTo(size.width * 0.9991667, size.height * 0.0050000);
    path_0.lineTo(size.width * 0.3321000, size.height * 0.2042500);
    path_0.lineTo(size.width * -0.0013167, size.height * -0.0026333);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);

    // Layer 1

    Paint paint_stroke_0 = Paint()
      ..color = Color.fromARGB(255, 240, 191, 142)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paint_stroke_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
