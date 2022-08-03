import 'package:flutter/material.dart';

class EmptyListScreen extends StatelessWidget {
  EmptyListScreen({this.text, this.icon = Icons.sentiment_dissatisfied});

  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$text'),
          SizedBox(width: 10),
          Icon(icon),
        ],
      ),
    );
  }
}
