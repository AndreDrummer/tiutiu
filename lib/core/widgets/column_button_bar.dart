import 'package:tiutiu/core/widgets/no_connection_text_info.dart';
import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:flutter/material.dart';

class ColumnButtonBar extends StatelessWidget {
  const ColumnButtonBar({
    this.showSimpleTextButton = true,
    required this.isConnected,
    this.buttonSecondaryColor,
    this.buttonPrimaryColor,
    this.onSecondaryPressed,
    this.onPrimaryPressed,
    this.textPrimary,
    this.textSecond,
    super.key,
  });

  final Function()? onPrimaryPressed;
  final Function()? onSecondaryPressed;
  final Color? buttonSecondaryColor;
  final Color? buttonPrimaryColor;
  final bool showSimpleTextButton;
  final String? textPrimary;
  final String? textSecond;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: Visibility(
            replacement: NoConnectionTextInfo(),
            visible: isConnected,
            child: ButtonWide(
              color: buttonPrimaryColor ?? AppColors.primary,
              onPressed: () => onPrimaryPressed?.call(),
              text: textPrimary ?? AppLocalizations.of(context)!.save,
              isToExpand: false,
            ),
          ),
        ),
        Visibility(
          visible: showSimpleTextButton,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: SimpleTextButton(
              textColor: buttonSecondaryColor ?? AppColors.secondary,
              onPressed: () => onSecondaryPressed?.call(),
              text: textSecond,
            ),
          ),
        ),
      ],
    );
  }
}
