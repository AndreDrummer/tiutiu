import 'package:flutter/material.dart';

class HintError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-0.95, 1),
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child:
            Text('* Campo obrigatório.', style: TextStyle(color: Colors.red)),
      ),
    );
  }
}
