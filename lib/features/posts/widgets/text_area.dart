import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/widgets/hint_error.dart';
import 'package:tiutiu/core/constants/app_colors.dart';

class TextArea extends StatelessWidget {
  const TextArea({
    this.isInErrorState = false,
    required this.labelText,
    this.inputFormatters,
    this.maxLines = 3,
    this.initialValue,
    this.prefix = '',
    this.validator,
    this.onChanged,
    this.onSubmit,
    this.hintText,
    super.key,
  });

  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;
  final String? initialValue;
  final bool isInErrorState;
  final String labelText;
  final String? hintText;
  final String prefix;
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
            inputFormatters: inputFormatters,
            onFieldSubmitted: onSubmit,
            initialValue: initialValue,
            onChanged: onChanged,
            validator: validator,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefix: Text(prefix),
              labelText: labelText,
              hintText: hintText,
              labelStyle: TextStyle(
                color: isInErrorState ? AppColors.danger : null,
              ),
              disabledBorder: _outlineInputBorder(),
              enabledBorder: _outlineInputBorder(),
              focusedBorder: _outlineInputBorder(),
              errorBorder: _outlineInputBorder(),
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
        Radius.circular(4.0.h),
      ),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: isInErrorState ? AppColors.danger : AppColors.black.withAlpha(80),
      ),
    );
  }
}
