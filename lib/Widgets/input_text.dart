import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiutiu/Custom/icons.dart';

// ignore: must_be_immutable
class InputText extends StatefulWidget {
  InputText({
    this.size = 55,
    this.controller,
    this.isLogin = false,
    this.isPassword = false,
    this.seePassword = false,
    this.readOnly = false,
    this.onChanged,
    this.keyBoardTypeNumber = false,
    this.placeholder,
    this.maxlines = 1,
    this.multiline = false,
    this.validator,
    this.hintText,
    this.inputFormatters = const [],
  });
  
  InputText.login({
    this.size = 55,
    this.controller,
    this.onChanged,
    this.placeholder,
    this.maxlines = 1,
    this.multiline = false,
    this.readOnly = false,
    this.keyBoardTypeNumber = false,
    this.isPassword = false,
    this.seePassword = false,
    this.isLogin = true,
    this.validator,
    this.hintText,
    this.inputFormatters = const [],
  });

  final double size;
  final String placeholder;
  final String hintText;
  final TextEditingController controller;
  final bool multiline;
  final bool isLogin;
  final bool isPassword;
  final bool readOnly;
  final bool keyBoardTypeNumber;
  bool seePassword;
  final int maxlines;
  final Function(String) onChanged;
  final Function(String) validator;
  final List<TextInputFormatter> inputFormatters;


  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.hintText != null ? 70 : widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: widget.isLogin ? Colors.white70 : Colors.white,
        border: Border.all(
          style: BorderStyle.solid,
          color: Colors.lightGreenAccent[200],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                cursorColor: Theme.of(context).primaryColor,
                inputFormatters: widget.inputFormatters,
                validator: widget.validator != null ? (value) {
                  return widget.validator(value);
                } : (value) {
                  if (value.isEmpty) {
                    return 'Preencha corretamente esse campo';
                  }
                  return null;
                },                                         
                readOnly: widget.readOnly,
                controller: widget.controller,
                textInputAction: TextInputAction.done,
                obscureText: widget.isPassword && !widget.seePassword,
                maxLines: widget.maxlines,
                onChanged: (String text) => widget.onChanged(text),
                keyboardType: widget.multiline
                    ? TextInputType.multiline
                    : widget.keyBoardTypeNumber
                        ? TextInputType.number
                        : TextInputType.text,                                                
                decoration: InputDecoration(                                                 
                  hintText: widget.hintText,                  
                  labelText: widget.placeholder,
                  labelStyle: TextStyle(
                    color: widget.isLogin
                        ? Colors.black38
                        : Colors.black26,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(style: BorderStyle.none),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(style: BorderStyle.none),
                  ),
                  errorBorder: OutlineInputBorder(
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
                        widget.seePassword
                            ? Tiutiu.eye
                            : Tiutiu.eye_slash,
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
