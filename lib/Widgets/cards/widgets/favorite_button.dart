import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Padding(
        padding: EdgeInsets.only(top: 2.0.h),
        child: Icon(Icons.favorite, size: 32.0.h),
      ),
      backgroundColor: Colors.white,
      radius: 24.0.h,
    );
  }
}
