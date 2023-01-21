import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class UnderlineInputText extends StatelessWidget {
  const UnderlineInputText({
    this.keyboardType = TextInputType.multiline,
    this.fontSizeLabelText,
    this.readOnly = false,
    this.inputFormatters,
    this.initialValue,
    this.capitalize,
    this.controller,
    this.validator,
    this.onChanged,
    this.maxLength,
    this.labelText,
    this.maxLines,
    this.hintText,
    this.prefix,
    this.suffix,
    super.key,
  });

  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextCapitalization? capitalize;
  final TextInputType? keyboardType;
  final double? fontSizeLabelText;
  final String? initialValue;
  final String? labelText;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLength;
  final int? maxLines;
  final bool readOnly;

  String? getInitialValue() {
    if (controller != null) return null;
    return initialValue == 'null' || initialValue == null ? '' : initialValue;
  }

  TextEditingController? getController() {
    if (initialValue != null) return null;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: prefix != null ? 0.0 : 8.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: labelText != null,
            child: AutoSizeTexts.autoSizeText26(
              fontSize: fontSizeLabelText ?? 24.0,
              color: Colors.black,
              '$labelText',
            ),
          ),
          // SizedBox(height: 14.0.h),
          TextFormField(
            textCapitalization: capitalize ?? TextCapitalization.sentences,
            initialValue: getInitialValue(),
            controller: getController(),
            onChanged: onChanged,
            validator: validator,
            maxLength: maxLength,
            readOnly: readOnly,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSizeLabelText != null ? fontSizeLabelText! * 1.5 : 18.0,
            ),
            minLines: 1,
            maxLines: maxLines ?? 2,
            textInputAction: TextInputAction.done,
            cursorColor: Colors.black,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 12.0.h),
              errorStyle: TextStyle(color: AppColors.danger),
              disabledBorder: _underlineInputBorder(),
              enabledBorder: _underlineInputBorder(),
              focusedBorder: _underlineInputBorder(),
              border: _underlineInputBorder(),
              hintStyle: TextStyle(
                fontSize: fontSizeLabelText != null ? fontSizeLabelText! * .85 : 18.0,
                color: Colors.grey,
              ),
              hintText: hintText,
              isCollapsed: true,
              prefix: prefix,
              suffix: suffix,
            ),
          ),
        ],
      ),
    );
  }

  UnderlineInputBorder _underlineInputBorder() {
    return UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: .5),
    );
  }
}
