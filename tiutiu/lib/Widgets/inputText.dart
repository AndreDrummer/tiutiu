import 'package:flutter/material.dart';

class InputText extends StatelessWidget {

  final double size;
  final String placeholder;
  final TextEditingController controller;
  final bool multiline;
  final bool isLogin;
  final bool isPassword;
  final int maxlines;


  InputText({
    this.size = 55,
    this.controller,
    this.isLogin = false,
    this.isPassword = false,
    this.placeholder,
    this.maxlines = 1,
    this.multiline = false
  });

  InputText.login({
    this.size = 55,
    this.controller,
    this.placeholder,
    this.maxlines = 1,
    this.multiline = false,
    this.isPassword = false,
    this.isLogin = true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: isLogin ? Colors.white70 : Colors.white,
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
          obscureText: isPassword,
          maxLines: maxlines,
          keyboardType: multiline ? TextInputType.multiline : TextInputType.text,     
          decoration: InputDecoration(            
            labelText: placeholder,
            labelStyle: TextStyle(
              color: isLogin ? Colors.black38 : Theme.of(context).textTheme.headline5.color,
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
