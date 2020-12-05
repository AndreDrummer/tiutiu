import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  Badge({
    this.text,
    this.color = Colors.blue,
    this.textSize = 10,
  });

  final text;
  final double textSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          text.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: textSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
