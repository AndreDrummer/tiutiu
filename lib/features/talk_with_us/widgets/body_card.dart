import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class BodyCard extends StatelessWidget {
  const BodyCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 8.0.h,
        right: 4.0.w,
        left: 4.0.w,
        top: 8.0.h,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0.h),
        ),
        elevation: 8.0,
        child: child,
      ),
    );
  }
}
