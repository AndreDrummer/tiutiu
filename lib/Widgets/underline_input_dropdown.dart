import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class UnderlineInputDropdown extends StatelessWidget {
  const UnderlineInputDropdown({
    required this.initialValue,
    required this.onChanged,
    required this.labelText,
    required this.items,
    this.fontSize,
    super.key,
  });

  final void Function(String?)? onChanged;
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
          SizedBox(height: 16.0),
          DropdownButton<String>(
            isDense: true,
            underline: Container(
              height: 0.5,
              color: AppColors.black,
            ),
            onChanged: onChanged,
            icon: const Icon(Icons.keyboard_arrow_down),
            isExpanded: true,
            value: initialValue,
            style: TextStyles.fontSize16(color: AppColors.black),
            iconEnabledColor: AppColors.black,
            selectedItemBuilder: (_) => items
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(
                    child: Text(
                      e,
                      style: TextStyles.fontSize16(color: AppColors.black),
                    ),
                    value: e,
                  ),
                )
                .toList(),
            items: items
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(
                    child: Text(e),
                    value: e,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
