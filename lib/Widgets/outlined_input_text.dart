import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class OutlinedInputText extends StatelessWidget {
  const OutlinedInputText({
    this.textCapitalization = TextCapitalization.none,
    this.labelText = 'E-mail',
    this.isPassword = false,
    this.inputFormatters,
    this.keyboardType,
    this.initialValue,
    this.textColor,
    this.onChanged,
    this.hintText,
    this.validator,
    this.maxLength,
    super.key,
  });

  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? initialValue;
  final Color? textColor;
  final String? hintText;
  final String labelText;
  final bool isPassword;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0.h),
        color: Colors.white.withAlpha(50),
      ),
      child: TextFormField(
        textCapitalization: textCapitalization,
        maxLength: isPassword ? 6 : maxLength,
        inputFormatters: inputFormatters,
        initialValue: initialValue,
        keyboardType: keyboardType,
        obscureText: isPassword,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18.0.sp,
        ),
        cursorColor: textColor ?? Colors.white,
        decoration: InputDecoration(
          hintText: hintText,
          counterText: '',
          labelText: labelText,
          hintStyle: TextStyle(
            color:
                textColor != null ? textColor!.withOpacity(.7) : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.0.sp,
          ),
          errorStyle: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.w600,
            fontSize: 10.0.sp,
          ),
          labelStyle: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 21.0.sp,
          ),
          errorBorder: _outlineInputBorder(isError: true),
          disabledBorder: _outlineInputBorder(),
          enabledBorder: _outlineInputBorder(),
          focusedBorder: _outlineInputBorder(),
          border: _outlineInputBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder _outlineInputBorder({bool isError = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0.h),
      ),
      borderSide: BorderSide(
        color: isError ? Colors.amber : textColor ?? Colors.white,
      ),
    );
  }
}
