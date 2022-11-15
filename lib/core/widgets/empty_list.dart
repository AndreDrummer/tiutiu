import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class EmptyListScreen extends StatelessWidget {
  EmptyListScreen({
    this.isAPetScreenList = true,
    this.text,
  });

  final bool isAPetScreenList;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: isAPetScreenList,
            child: Container(
              child: Image.asset(ImageAssets.sadPanda),
              height: 64.0.h,
            ),
          ),
          AutoSizeTexts.autoSizeText16(text ?? AppStrings.noPostFound),
        ],
      ),
      alignment: Alignment.center,
    );
  }
}
