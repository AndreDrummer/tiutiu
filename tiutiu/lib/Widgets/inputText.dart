import 'package:flutter/material.dart';
import 'package:tiutiu/Custom/icons.dart';

class InputText extends StatefulWidget {
  final double size;
  final String placeholder;
  final TextEditingController controller;
  final bool multiline;
  final bool isLogin;
  final bool isPassword;
  final bool readOnly;
  bool seePassword;
  final int maxlines;

  InputText(
      {this.size = 55,
      this.controller,
      this.isLogin = false,
      this.isPassword = false,
      this.seePassword = false,
      this.readOnly = false,
      this.placeholder,
      this.maxlines = 1,
      this.multiline = false,});

  InputText.login(
      {this.size = 55,
      this.controller,
      this.placeholder,
      this.maxlines = 1,
      this.multiline = false,
      this.readOnly = false,
      this.isPassword = false,
      this.seePassword = false,
      this.isLogin = true,});

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: widget.isLogin ? Colors.white70 : Colors.white,
        border: Border.all(
          style: BorderStyle.solid,
          color: Colors.white,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Preencha corretamente esse campo';
                  }
                  return null;
                },
                readOnly: widget.readOnly,
                controller: widget.controller,
                obscureText: widget.isPassword && !widget.seePassword,
                maxLines: widget.maxlines,
                keyboardType:
                    widget.multiline ? TextInputType.multiline : TextInputType.text,
                decoration: InputDecoration(
                  labelText: widget.placeholder,
                  labelStyle: TextStyle(
                    color: widget.isLogin
                        ? Colors.black38
                        : Theme.of(context).textTheme.headline5.color,
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
            widget.isPassword
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(
                        widget.seePassword ? CustomIcon.eye : CustomIcon.eye_slash,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.seePassword = !widget.seePassword;
                        });
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
