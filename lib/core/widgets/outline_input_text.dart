import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class OutlinedInputText extends StatelessWidget {
  const OutlinedInputText({
    this.textCapitalization = TextCapitalization.none,
    this.onPasswordVisibilityChange,
    this.showCounterText = false,
    this.labelText = 'E-mail',
    this.showPassword = false,
    this.isPassword = false,
    this.inputFormatters,
    this.keyboardType,
    this.initialValue,
    this.controller,
    this.textColor,
    this.fontSize,
    this.onChanged,
    this.hintText,
    this.validator,
    this.maxLength,
    super.key,
  }) : assert(
          (showPassword == true && isPassword == true) || showPassword == false,
          controller != null || initialValue != null,
        );

  final List<TextInputFormatter>? inputFormatters;
  final Function()? onPasswordVisibilityChange;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? initialValue;
  final bool showCounterText;
  final bool showPassword;
  final Color? textColor;
  final double? fontSize;
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
        color: AppColors.white.withAlpha(30),
      ),
      child: TextFormField(
        obscureText: isPassword && !showPassword,
        textCapitalization: textCapitalization,
        maxLength: isPassword ? 16 : maxLength,
        textInputAction: TextInputAction.done,
        inputFormatters: inputFormatters,
        initialValue: initialValue,
        keyboardType: keyboardType,
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(
          color: textColor ?? AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: fontSize ?? 18.0,
        ),
        cursorColor: textColor ?? AppColors.white,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    onPasswordVisibilityChange?.call();
                  },
                  icon: Icon(
                    showPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                    color: AppColors.white.withAlpha(180),
                  ),
                )
              : null,
          hintText: hintText,
          counterText: showCounterText ? null : '',
          labelText: labelText,
          hintStyle: TextStyle(
            color: textColor != null ? textColor!.withOpacity(.7) : AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: fontSize ?? 18.0,
          ),
          errorStyle: TextStyle(
            color: AppColors.danger,
            fontWeight: FontWeight.w600,
            fontSize: 10.0,
          ),
          labelStyle: TextStyle(
            color: textColor ?? AppColors.white,
            fontSize: 18.0,
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
        color: isError ? AppColors.danger : textColor ?? AppColors.white,
        width: .6,
      ),
    );
  }
}
