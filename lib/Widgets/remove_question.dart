import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class RemoveQuestion extends StatelessWidget {
  const RemoveQuestion({
    this.spaceBetweenIcons,
    this.spaceBetweenLines,
    this.fontSize,
    this.onRemove,
    this.onClose,
    super.key,
  });

  final double? spaceBetweenIcons;
  final double? spaceBetweenLines;
  final void Function()? onRemove;
  final void Function()? onClose;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Remover ?',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
        SizedBox(height: spaceBetweenLines),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: Icon(
                Icons.done,
                size: fontSize,
                color: AppColors.white,
              ),
              onTap: onRemove,
            ),
            GestureDetector(
              child: Icon(
                Icons.close,
                size: fontSize,
                color: AppColors.white,
              ),
              onTap: onClose,
            )
          ],
        )
      ],
    );
  }
}
