import 'package:flutter/material.dart';

class CircleAddImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 40,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          // border: Border.all(
          //   style: BorderStyle.solid,
          //   color: Colors.black,
          // ),
        ),
        margin: const EdgeInsets.all(8.0),
        child: Center(
          child: ClipOval(
            child: Image.asset(
              'assets/addImage.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
