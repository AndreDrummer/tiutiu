import 'package:flutter/material.dart';

class InputText extends StatelessWidget {

  final double size;
  final String placeholder;
  final TextEditingController controller;
  final bool multiline;
  final int maxlines;


  InputText({
    this.size = 45,
    this.controller,
    this.placeholder,
    this.maxlines = 1,
    this.multiline = false
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          validator: (value) {
            if(value.isEmpty) {
              return 'Preencha corretamente esse campo';
            }
            return null;
          },
          controller: controller,
          maxLines: maxlines,
          keyboardType: multiline ? TextInputType.multiline : TextInputType.text,     
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
      ),
    );
  }
}
