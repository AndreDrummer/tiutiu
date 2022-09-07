import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class InputCloseButton extends StatelessWidget {
  const InputCloseButton({super.key, this.onClose});

  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        margin: EdgeInsets.all(6.0.h),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 4),
          elevation: 2.0.h,
          color: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              1000,
            ),
          ),
          child: Icon(
            color: Colors.black54,
            size: 16.0.h,
            Icons.close,
          ),
        ),
      ),
    );
  }
}
