import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  CustomDivider({
    this.text = '',
    this.fontSize = 14,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(child: Divider(color: Colors.black87)),
          Text(" $text ", style: TextStyle(color: Colors.black87, fontSize: fontSize)),
          Expanded(child: Divider(color: Colors.black87)),
        ],
      ),
    );
  }
}
