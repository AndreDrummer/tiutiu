import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/hint_error.dart';
import 'package:flutter/material.dart';

class UnderlineInputDropdown extends StatelessWidget {
  const UnderlineInputDropdown({
    this.isInErrorState = false,
    required this.initialValue,
    required this.onChanged,
    required this.labelText,
    this.labelBold = false,
    required this.items,
    this.fontSize,
    this.color,
    super.key,
  });

  final void Function(String?)? onChanged;
  final bool isInErrorState;
  final String initialValue;
  final List<String> items;
  final double? fontSize;
  final String labelText;
  final bool labelBold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeTexts.autoSizeText26(
            fontWeight: labelBold ? FontWeight.w600 : null,
            fontSize: fontSize ?? 24.0,
            color: color ?? AppColors.black,
            labelText,
          ),
          DropdownButton<String>(
            underline: Container(
              color: isInErrorState ? AppColors.danger : color ?? AppColors.black,
              height: 0.5,
            ),
            onChanged: onChanged,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isInErrorState ? AppColors.danger : color ?? AppColors.black,
            ),
            isExpanded: true,
            value: initialValue,
            iconEnabledColor: color ?? AppColors.black,
            selectedItemBuilder: (_) => items
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(
                    child: AutoSizeTexts.autoSizeText18(
                      e,
                      color: color ?? AppColors.black,
                    ),
                    value: e,
                  ),
                )
                .toList(),
            items: items
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(
                    child: AutoSizeTexts.autoSizeText18(e, color: color ?? AppColors.black),
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
