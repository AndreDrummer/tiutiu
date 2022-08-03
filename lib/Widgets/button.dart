import 'package:flutter/material.dart';

class ButtonWide extends StatelessWidget {
  ButtonWide({
    this.color = Colors.purple,
    this.isToExpand = false,
    this.rounded = true,
    this.action,
    this.text,
    this.icon,
  });

  final bool? isToExpand;
  final Function? action;
  final IconData? icon;
  final bool? rounded;
  final String? text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action?.call(),
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: isToExpand! ? MediaQuery.of(context).size.width : 260,
        decoration: BoxDecoration(
          borderRadius: rounded == true ? BorderRadius.circular(12) : null,
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null
                  ? Icon(icon, size: 20, color: Colors.white)
                  : Text(''),
              icon != null ? SizedBox(width: 15) : Text(''),
              Text(
                text!,
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
