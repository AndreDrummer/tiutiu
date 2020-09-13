import 'package:flutter/material.dart';

class CircleChild extends StatelessWidget {
  CircleChild({this.avatarRadius = 40, this.child});

  final double avatarRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: CircleAvatar(
          backgroundColor: Colors.black,
          radius: avatarRadius,
          child: ClipOval(child: child),
        ),
      ),
    );
  }
}
