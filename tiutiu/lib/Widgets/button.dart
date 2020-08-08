import 'package:flutter/material.dart';

class ButtonWide extends StatelessWidget {

  ButtonWide({this.text, this.action, this.isToExpand = false});
  final String text;
  final Function action;
  bool isToExpand;

  @override
  Widget build(BuildContext context) {    
    return InkWell(
      onTap: () => action(),
      child: Container(
        height: 50,
        width: isToExpand ? double.infinity : 260,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: Colors.green),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: 22
            )
          ),
        ),
      ),
    );
  }
}
