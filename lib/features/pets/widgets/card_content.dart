import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
      padding: EdgeInsets.all(2.0.h),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
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
                      AutoSizeText(
                        style: TextStyles.fontSize16(
                          fontWeight: FontWeight.w600,
                        ),
                        title,
                      ),
                      Visibility(
                        visible: icon != null,
                        child: InkWell(
                          onTap: onAction,
                          child: Icon(
                            color: Colors.blue,
                            size: 16.0.h,
                            icon,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                AutoSizeText(
                  style: TextStyles.fontSize12(color: Colors.blueGrey),
                  maxLines: 3,
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
