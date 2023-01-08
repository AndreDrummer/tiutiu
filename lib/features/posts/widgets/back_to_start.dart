import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class BackToStart extends StatelessWidget {
  const BackToStart({super.key, this.onPressed});

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeTexts.autoSizeText12(
            AppStrings.backToStart.toUpperCase(),
            fontWeight: FontWeight.w700,
            color: Colors.blue,
          ),
          Icon(
            Icons.arrow_drop_up_sharp,
            color: Colors.blue,
          )
        ],
      ),
      onPressed: onPressed,
    );
  }
}
