import 'package:flutter/material.dart';

class ButtonWide extends StatelessWidget {
  ButtonWide({this.text, this.action, this.isToExpand = false, this.rounded = true});
  final String text;
  final Function action;
  final bool isToExpand;
  final bool rounded;


  @override
  Widget build(BuildContext context) {    
    return Container(
      alignment: Alignment.center,
      height: 50,
      width:  isToExpand ? MediaQuery.of(context).size.width : 260,
      decoration: BoxDecoration(
        borderRadius: rounded == true ? BorderRadius.circular(25) : null,
        color: Theme.of(context).primaryColor,
      ),
      child: RaisedButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0,
        color: Theme.of(context).primaryColor,
        onPressed: () => action(),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline1.copyWith(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
