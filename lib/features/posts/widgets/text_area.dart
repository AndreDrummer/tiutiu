import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class TextArea extends StatelessWidget {
  const TextArea({
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
  final String labelText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0.h),
          ),
        ),
      ),
    );
  }
}
