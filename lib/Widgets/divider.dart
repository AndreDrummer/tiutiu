import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget{
  
  CustomDivider({this.text = ''});
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(child: Divider(color: Colors.black87)),
          Text(" $text ",
              style: TextStyle(color: Colors.black87)),
          Expanded(child: Divider(color: Colors.black87)),
        ],
      ),
    );
  }
}