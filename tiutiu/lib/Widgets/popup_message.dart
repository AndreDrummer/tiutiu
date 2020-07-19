import 'package:flutter/material.dart';

class PopUpMessage extends StatelessWidget {
  final String title;
  final String message;
  PopUpMessage({this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.black, fontSize: 18)),
          Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Image.asset('assets/pata.jpg', width: 20, height: 20),
          )
        ],
      ),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK"),
        )
      ],
    );
  }
}
