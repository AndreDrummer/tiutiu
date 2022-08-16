import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiutiu/core/Custom/icons.dart';

// ignore: must_be_immutable
class InputText extends StatefulWidget {
  InputText({
    this.textCapitalization = TextCapitalization.sentences,
    this.keyBoardTypeNumber = false,
    this.inputFormatters = const [],
    this.seePassword = false,
    this.isPassword = false,
    this.multiline = false,
    this.readOnly = false,
    this.isLogin = false,
    this.maxlines = 1,
    this.placeholder,
    this.controller,
    this.size = 75,
    this.onChanged,
    this.validator,
    this.hintText,
  });

  InputText.login({
    this.size = 75,
    this.textCapitalization = TextCapitalization.sentences,
    this.keyBoardTypeNumber = false,
    this.inputFormatters = const [],
    this.seePassword = false,
    this.isPassword = false,
    this.multiline = false,
    this.readOnly = false,
    this.isLogin = true,
    this.maxlines = 1,
    this.placeholder,
    this.controller,
    this.onChanged,
    this.validator,
    this.hintText,
  });

  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? validator;
  final bool? keyBoardTypeNumber;
  final String? placeholder;
  final bool? isPassword;
  final String? hintText;
  final bool? multiline;
  final bool? readOnly;
  final bool? isLogin;
  final int? maxlines;
  final double? size;
  bool? seePassword;

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
        color: widget.isLogin! ? Colors.white70 : Colors.white,
        border: Border.all(
          style: BorderStyle.solid,
          color: Colors.lightGreenAccent[200]!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                textCapitalization: widget.textCapitalization!,
                cursorColor: Theme.of(context).primaryColor,
                inputFormatters: widget.inputFormatters,
                validator: widget.validator != null
                    ? (value) {
                        return widget.validator!(value!);
                      }
                    : (value) {
                        if (value!.isEmpty) {
                          return 'Preencha corretamente esse campo';
                        }
                        return null;
                      },
                readOnly: widget.readOnly!,
                controller: widget.controller,
                textInputAction: TextInputAction.done,
                obscureText: widget.isPassword! && !widget.seePassword!,
                maxLines: widget.maxlines,
                onChanged: (String text) => widget.onChanged!(text),
                keyboardType: widget.multiline!
                    ? TextInputType.multiline
                    : widget.keyBoardTypeNumber!
                        ? TextInputType.number
                        : TextInputType.text,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  labelText: widget.placeholder,
                  labelStyle: TextStyle(
                    color: widget.isLogin! ? Colors.black38 : Colors.black26,
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
            widget.isPassword!
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(
                        widget.seePassword! ? Tiutiu.eye : Tiutiu.eye_slash,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.seePassword = !widget.seePassword!;
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
