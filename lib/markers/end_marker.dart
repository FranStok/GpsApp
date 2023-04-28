import 'package:flutter/material.dart';

class EndMarkerPainter extends CustomPainter {
  final int kilometers;
  final String destination;

  EndMarkerPainter({required this.kilometers, required this.destination});
  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()..color = Colors.black;
    final whitePaint = Paint()..color = Colors.white;
    const double circleBlackRadious = 20;
    const double circleWhiteRadious = 7;

    canvas.drawCircle(
        Offset(size.width/2, size.height - circleBlackRadious),
        circleBlackRadious,
        blackPaint);
    canvas.drawCircle(
        Offset(size.width/2, size.height - circleBlackRadious),
        circleWhiteRadious,
        whitePaint);
    //Dibujar caja
    final path = Path();
    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);

    //Sombra
    canvas.drawShadow(path, Colors.black, 10, false);

    canvas.drawPath(path, whitePaint);

    //Caja negra
    const blackBox = Rect.fromLTWH(10, 20, 70, 80);
    canvas.drawRect(blackBox, blackPaint);

    //Textos
    //Minutos
    final textSpan = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
        text: "$kilometers");
    final minutesPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 70, maxWidth: 70);

    minutesPainter.paint(canvas, const Offset(10, 35));

    //Palabra minutos
    const minutesText = TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 23, fontWeight: FontWeight.w400),
        text: "Kms");
    final minutesMinPainter = TextPainter(
      text: minutesText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(minWidth: 70, maxWidth: 70);

    minutesMinPainter.paint(canvas, const Offset(10, 68));

    //Descripcion
    final locationText = TextSpan(
        style: const TextStyle(
            color: Colors.black, fontSize: 23, fontWeight: FontWeight.w400),
        text: destination);
    final locationPainter = TextPainter(
      maxLines: 2,
      ellipsis: "...",
      text: locationText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(minWidth: size.width - 135, maxWidth: size.width - 115);

    final double offsetY = (destination.length > 22) ? 35 : 48;

    locationPainter.paint(canvas, Offset(90, offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRebuildSemantics
    return false;
  }
}
