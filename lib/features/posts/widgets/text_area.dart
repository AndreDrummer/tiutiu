import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:tiutiu/core/constants/app_colors.dart';

class TextArea extends StatelessWidget {
  const TextArea({
    this.isInErrorState = false,
    required this.labelText,
    this.maxLines = 3,
    this.initialValue,
    this.validator,
    this.onChanged,
    super.key,
  });

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? initialValue;
  final bool isInErrorState;
  final String labelText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: Column(
        children: [
          TextFormField(
            initialValue: initialValue,
            onChanged: onChanged,
            validator: validator,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: labelText,
              errorBorder: _outlineInputBorder(isError: true),
              disabledBorder: _outlineInputBorder(),
              enabledBorder: _outlineInputBorder(),
              focusedBorder: _outlineInputBorder(),
              border: _outlineInputBorder(),
            ),
          ),
          Visibility(
            visible: isInErrorState,
            child: HintError(),
          )
        ],
      ),
    );
  }

  OutlineInputBorder _outlineInputBorder(
      {bool isError = false, bool showBorder = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0.h),
      ),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: isError ? AppColors.danger : AppColors.black.withAlpha(80),
      ),
    );
  }
}
