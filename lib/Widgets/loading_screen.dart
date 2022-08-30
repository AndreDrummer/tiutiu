import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingBumpingLine.circle(
            backgroundColor: Colors.black,
          ),
          SizedBox(height: 15),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black),
          )
        ],
      ),
    );
  }
}
