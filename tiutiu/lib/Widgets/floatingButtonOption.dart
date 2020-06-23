import 'package:flutter/material.dart';

class FloatingButtonOption extends StatelessWidget {

  final String image;
  FloatingButtonOption({
    @required this.image
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 12,
        child: ClipOval(
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Image.asset(image, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}