import 'package:flutter/material.dart';

class InputText extends StatelessWidget {

  final double size;
  final String placeholder;
  final TextEditingController controller;


  InputText({
    this.size = 45,
    this.controller,
    this.placeholder
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        border: Border.all(
          style: BorderStyle.solid,
          color: Colors.white,
        ),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: placeholder,
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.headline5.color,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none),
          ),
        ),
      ),
    );
  }
}
