import 'package:flutter/material.dart';

class StyleCardMeun extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintFill0 = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.0012000, size.height * 1.0098000);
    path_0.lineTo(size.width * 1.0194000, 0);
    path_0.lineTo(size.width * 1.0049000, size.height * 1.0041000);
    path_0.lineTo(size.width * 0.0012000, size.height * 1.0098000);
    path_0.close();

    canvas.drawPath(path_0, paintFill0);

    // Layer 1

    // Paint paintStroke0 = Paint()
    //   ..color = const Color.fromARGB(255, 33, 150, 243)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = size.width * 0.01
    //   ..strokeCap = StrokeCap.butt
    //   ..strokeJoin = StrokeJoin.miter;

    // canvas.drawPath(path_0, paintStroke0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
