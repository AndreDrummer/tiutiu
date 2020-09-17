import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  Background({
    this.dark = false,
  });
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Opacity(
        opacity: dark ? 0.3 : 0.03,
        child: Image.asset(
          dark ? 'assets/bones2.jpg' : 'assets/bones.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
