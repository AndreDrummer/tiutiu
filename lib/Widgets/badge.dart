import 'package:flutter/material.dart';

class Badge extends StatelessWidget {

  Badge({this.callback, this.icon});

  final Function() callback;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color:  Colors.black26,
          shape: BoxShape.circle
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}