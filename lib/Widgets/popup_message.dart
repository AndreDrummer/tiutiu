import 'package:flutter/material.dart';

class PopUpMessage extends StatelessWidget {
  PopUpMessage({
    this.title,
    this.message,
    this.error = false,
    this.warning = false,
    this.action,
    this.showAllButtons = false,
  });
  final String title;
  final String message;
  final bool error;
  final bool warning;
  final bool showAllButtons;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      // backgroundColor: Color(0XFFFFF176),
      backgroundColor: error
          ? Color(0XFFDC3545)
          : warning ? Color(0XFFFFC107) : Theme.of(context).primaryColor,
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
      content: Text(message,
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (action != null) {
              action();
            } else {
              Navigator.pop(context);
            }
          },
          child: Text(
            '${action != null && showAllButtons ? 'Não' : 'OK'}',
            style: TextStyle(color: Colors.white),
          ),
        ),
        showAllButtons
            ? FlatButton(
                onPressed: action,
                child: Text(
                  'Sim',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container()
      ],
    );
  }
}
