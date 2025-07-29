import 'package:flutter/material.dart';

class OctagonBorder extends ShapeBorder {
  final double sideLength;

  const OctagonBorder({this.sideLength = 10.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(sideLength);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double flatSize = 5.0;
    final Path path = Path()
      ..moveTo(rect.left + flatSize, rect.top) // Starting point
      ..lineTo(rect.right - flatSize, rect.top)
      ..lineTo(rect.right, rect.top + flatSize)
      ..lineTo(rect.right, rect.bottom - flatSize)
      ..lineTo(rect.right - flatSize, rect.bottom)
      ..lineTo(rect.left + flatSize, rect.bottom)
      ..lineTo(rect.left, rect.bottom - flatSize)
      ..lineTo(rect.left, rect.top + flatSize)
      ..close(); // Closes the path

    return path;
  }

  @override
  ShapeBorder scale(double t) => OctagonBorder(sideLength: sideLength * t);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}