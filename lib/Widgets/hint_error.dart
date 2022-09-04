import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HintError extends StatelessWidget {
  HintError({this.message = '* Campo obrigatório.'});

  final message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-0.93, 1),
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: AutoSizeText(
          message,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
