import 'package:flutter/material.dart';

class PrimaryText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight fontWeight;
  final double height;
  const PrimaryText(
      {this.text: 'a',
      this.color: Colors.black87,
      this.fontWeight: FontWeight.w400,
      this.height: 1.3,
      this.size: 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
          fontFamily: 'Poppins',
          height: height),
    );
  }
}
