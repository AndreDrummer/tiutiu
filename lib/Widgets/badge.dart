import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  
  Badge({
    this.text,
    this.color = Colors.blue
  });

  final text;
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
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
