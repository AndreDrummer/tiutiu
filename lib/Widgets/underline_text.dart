import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class UnderlineInputText extends StatelessWidget {
  const UnderlineInputText({
    this.keyboardType = TextInputType.multiline,
    this.fontSizeLabelText,
    this.inputFormatters,
    this.initialValue,
    this.capitalize,
    this.validator,
    this.onChanged,
    this.labelText,
    this.maxLines,
    this.hintText,
    this.prefix,
    this.suffix,
    super.key,
  });

  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextCapitalization? capitalize;
  final TextInputType? keyboardType;
  final double? fontSizeLabelText;
  final String? initialValue;
  final String? labelText;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;

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
            child: Text(
              '$labelText',
              style: TextStyles.fontSize(
                fontSize: fontSizeLabelText ?? 24.0.sp,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 16.0.h),
          TextFormField(
            initialValue: initialValue == 'null' || initialValue == null
                ? ''
                : initialValue,
            textCapitalization: capitalize ?? TextCapitalization.sentences,
            onChanged: onChanged,
            validator: validator,
            style: TextStyle(
              color: Colors.black,
              fontSize:
                  fontSizeLabelText != null ? fontSizeLabelText! * .9 : 18.0.sp,
            ),
            minLines: 1,
            maxLines: maxLines ?? 2,
            textInputAction: TextInputAction.done,
            cursorColor: Colors.black,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              disabledBorder: _underlineInputBorder(),
              enabledBorder: _underlineInputBorder(),
              focusedBorder: _underlineInputBorder(),
              border: _underlineInputBorder(),
              hintStyle: TextStyles.fontSize(
                fontSize: fontSizeLabelText != null
                    ? fontSizeLabelText! * .85
                    : 18.0.sp,
                color: Colors.grey,
              ),
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
