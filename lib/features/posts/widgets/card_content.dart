import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  const CardContent({
    required this.content,
    required this.title,
    this.onAction,
    super.key,
    this.icon,
  });

  final Function()? onAction;
  final IconData? icon;
  final String content;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0.h),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.0.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8.0,
        child: Padding(
          padding: EdgeInsets.all(8.0.h),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeTexts.autoSizeText14(
                        fontWeight: FontWeight.w600,
                        title,
                      ),
                      Visibility(
                        visible: icon != null,
                        child: Row(
                          children: [
                            LottieAnimation(animationPath: AnimationsAssets.petLocationPin, size: 22.0.h),
                            SizedBox(width: 2.0.w),
                            InkWell(
                              onTap: onAction,
                              child: Icon(
                                color: Colors.blue,
                                size: 16.0.h,
                                icon,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                AutoSizeTexts.autoSizeText12(
                  color: Colors.blueGrey,
                  content,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
