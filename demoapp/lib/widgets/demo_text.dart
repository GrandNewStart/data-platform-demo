import 'package:flutter/material.dart';

class DemoText extends StatelessWidget {
  String text;
  DemoTextType type;

  DemoText({required this.text, required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    FontWeight fontWeight;
    double fontSize;
    switch (type) {
      case DemoTextType.bold:
        fontWeight = FontWeight.w900;
        fontSize = 24;
        break;
      case DemoTextType.normal:
        fontWeight = FontWeight.w600;
        fontSize = 18;
        break;
      case DemoTextType.light:
        fontWeight = FontWeight.w300;
        fontSize = 16;
        break;
    }

    return Text(text,
        style: TextStyle(
            color: Colors.black, fontWeight: fontWeight, fontSize: fontSize));
  }
}

enum DemoTextType { bold, normal, light }
