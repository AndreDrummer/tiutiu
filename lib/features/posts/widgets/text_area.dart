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
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            initialValue: initialValue,
            onChanged: onChanged,
            validator: validator,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: isInErrorState ? AppColors.danger : null,
              ),
              errorBorder: _outlineInputBorder(),
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

  OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0.h),
      ),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color:
            isInErrorState ? AppColors.danger : AppColors.black.withAlpha(80),
      ),
    );
  }
}
