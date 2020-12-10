import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  Background({this.dark = false, this.image});
  final bool dark;
  final image;

  @override
  Widget build(BuildContext context) {
    final urlImage = image == null
        ? dark
            ? 'assets/bones2.jpg'
            : 'assets/bones.jpg'
        : image;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Opacity(
        opacity: dark || image != null ? 0.3 : 0.03,
        child: Image.asset(
          urlImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
