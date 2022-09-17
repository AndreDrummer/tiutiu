import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    this.pressed = false,
    super.key,
  });

  final bool pressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0.h),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Icon(
                !pressed ? Icons.favorite : Icons.favorite_border,
                size: 23.0.h,
              ),
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
