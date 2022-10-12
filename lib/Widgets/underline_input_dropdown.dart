import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class UnderlineInputDropdown extends StatelessWidget {
  const UnderlineInputDropdown({
    this.isInErrorState = false,
    required this.initialValue,
    required this.onChanged,
    required this.labelText,
    required this.items,
    this.fontSize,
    super.key,
  });

  final void Function(String?)? onChanged;
  final bool isInErrorState;
  final String initialValue;
  final List<String> items;
  final double? fontSize;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            style: TextStyles.fontSize(
              fontSize: fontSize ?? 24.0.sp,
              color: AppColors.black,
            ),
            maxFontSize: 26,
            labelText,
          ),
          SizedBox(height: 14.0),
          DropdownButton<String>(
            isDense: true,
            underline: Container(
              color: isInErrorState ? AppColors.danger : AppColors.black,
              height: 0.5,
            ),
            onChanged: onChanged,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isInErrorState ? AppColors.danger : AppColors.black,
            ),
            isExpanded: true,
            value: initialValue,
            style: TextStyles.fontSize14(color: AppColors.black),
            iconEnabledColor: AppColors.black,
            selectedItemBuilder: (_) => items
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(
                    child: AutoSizeText(
                      e,
                      maxFontSize: 14,
                      style: TextStyles.fontSize14(color: AppColors.black),
                    ),
                    value: e,
                  ),
                )
                .toList(),
            items: items
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(
                    child: AutoSizeText(
                      e,
                      maxFontSize: 14,
                      style: TextStyles.fontSize14(color: AppColors.black),
                    ),
                    value: e,
                  ),
                )
                .toList(),
          ),
          Visibility(
            visible: isInErrorState,
            child: HintError(),
          )
        ],
      ),
    );
  }
}
