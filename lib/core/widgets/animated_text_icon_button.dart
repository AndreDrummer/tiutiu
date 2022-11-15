import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AnimatedTextIconButton extends StatelessWidget {
  const AnimatedTextIconButton({
    required this.showCondition,
    required this.textLabel,
    this.elementsColor,
    this.onPressed,
    this.icon,
    super.key,
  });

  final void Function()? onPressed;
  final Color? elementsColor;
  final bool showCondition;
  final String textLabel;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: showCondition ? 1 : 0,
      child: Visibility(
        visible: showCondition,
        child: TextButton.icon(
          onPressed: onPressed,
          label: AutoSizeText(
            textLabel,
            maxFontSize: 13,
            style: TextStyle(color: elementsColor ?? AppColors.secondary),
          ),
          icon: Icon(
            color: elementsColor ?? AppColors.secondary,
            icon ?? Icons.add,
          ),
        ),
      ),
    );
  }
}
