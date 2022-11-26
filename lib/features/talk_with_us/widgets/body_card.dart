import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class BodyCard extends StatelessWidget {
  const BodyCard({
    required this.bodyHeight,
    required this.child,
    super.key,
  });

  final double bodyHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      height: bodyHeight,
      margin: EdgeInsets.only(
        bottom: 16.0.h,
        right: 8.0.w,
        left: 8.0.w,
        top: 4.0.h,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.h),
        ),
        elevation: 16.0,
        child: child,
      ),
    );
  }
}
