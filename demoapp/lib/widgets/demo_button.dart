import 'package:flutter/material.dart';

import 'demo_text.dart';

class DemoButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final IconData? iconData;

  const DemoButton({
    this.text,
    this.iconData,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (iconData != null) {
      return MaterialButton(
          onPressed: onPressed,
          color: Colors.grey,
          elevation: 0,
          child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child: Icon(iconData, size: 32, color: Colors.black)));
    }
    return MaterialButton(
        onPressed: onPressed,
        color: Colors.grey,
        elevation: 0,
        child: Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            child: DemoText(text: text ?? "", type: DemoTextType.normal)));
  }
}
