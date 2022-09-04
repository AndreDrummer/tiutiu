import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/constants/images_assets.dart';

class PopUpMessage extends StatelessWidget {
  PopUpMessage({
    this.warning = false,
    this.confirmAction,
    this.error = false,
    this.confirmText,
    this.denyText = '',
    this.denyAction,
    this.message,
    this.title,
  });

  final Function? confirmAction;
  final Function? denyAction;
  final String? confirmText;
  final String? denyText;
  final String? message;
  final String? title;
  final bool? warning;
  final bool? error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: error!
          ? Color(0XFFDC3545)
          : warning!
              ? Color(0XFFFFC107)
              : Colors.green,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AutoSizeText(title!,
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Container(
            padding: const EdgeInsets.all(2.50),
            child: Image.asset(ImageAssets.newLogo,
                width: 20, height: 20, color: Colors.white),
          )
        ],
      ),
      content: AutoSizeText(
        message!,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: <Widget>[
        confirmAction != null
            ? TextButton(
                onPressed: () {
                  confirmAction!();
                },
                child: AutoSizeText(
                  confirmText!,
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(),
        denyAction != null
            ? TextButton(
                onPressed: () {
                  denyAction!();
                },
                child: AutoSizeText(
                  denyText!,
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container()
      ],
    );
  }
}
