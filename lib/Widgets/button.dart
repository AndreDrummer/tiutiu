import 'package:flutter/material.dart';

class ButtonWide extends StatelessWidget {
  ButtonWide({
    this.text,
    this.action,
    this.isToExpand = false,
    this.rounded = true,
    this.color = Colors.green,
  });

  final String text;
  final Function action;
  final bool isToExpand;
  final bool rounded;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action(),
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: isToExpand ? MediaQuery.of(context).size.width : 260,
        decoration: BoxDecoration(
          borderRadius: rounded == true ? BorderRadius.circular(25) : null,
          color: color,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline1.copyWith(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
