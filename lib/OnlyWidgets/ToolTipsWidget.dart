import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

toolTipsWidget(
  String txt,
) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.lightbulb,
                  size: 14,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  txt,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // Maybe decrease the width a bit
      Positioned(
        top: 0,
        left: 10,
        child: CustomPaint(
          size: Size(20, 20),
          painter: DrawTriangleShape(),
        ),
      ),
    ],
  );

  Bubble(
    nip: BubbleNip.leftTop,
    color: Colors.blueGrey[100],
    child: Text(
      txt,
      style: GoogleFonts.openSans(
        fontSize: 16,
        color: Colors.black87,
      ),
    ),
  );
}

class DrawTriangleShape extends CustomPainter {
  Paint painter;

  DrawTriangleShape() {
    painter = Paint()
      ..color = Colors.grey[300]
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.height, size.width);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
