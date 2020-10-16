import 'package:flutter/material.dart';

class PopUpMessage extends StatelessWidget {
  PopUpMessage({
    this.title,
    this.message,    
    this.confirmText,
    this.denyText,
    this.error = false,
    this.warning = false,
    this.confirmAction,
    this.denyAction
  });

  final String title;
  final String message;
  final String confirmText;
  final String denyText;
  final bool error;
  final bool warning;
  final Function confirmAction;
  final Function denyAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(    
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: error
          ? Color(0XFFDC3545)
          : warning ? Color(0XFFFFC107) : Colors.green,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          Container(
            padding: const EdgeInsets.all(2.50),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Image.asset('assets/pata.jpg', width: 20, height: 20, color: Colors.white),
          )
        ],
      ),
      content: Text(
        message,
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      actions: <Widget>[
        confirmAction != null
            ? FlatButton(
                onPressed: () {
                  confirmAction();
                },
                child: Text(
                  confirmText,
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(),
        denyAction != null
            ? FlatButton(
                onPressed: () {
                  denyAction();
                },
                child: Text(
                  denyText,
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container()
      ],
    );
  }
}
