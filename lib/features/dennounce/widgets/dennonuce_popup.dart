import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:tiutiu/core/utils/keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DennouncePopup extends StatelessWidget {
  const DennouncePopup({
    required this.denounceDescription,
    required this.dennounceMotives,
    required this.onMotiveUpdate,
    required this.contentHeight,
    this.motiveIsOther = true,
    required this.groupValue,
    this.isLoading = false,
    required this.hasError,
    this.onMotiveDescribed,
    required this.onSubmit,
    required this.cancel,
    this.show = false,
    this.padding,
    super.key,
  });

  final EdgeInsetsGeometry? Function(bool)? padding;
  final void Function(String)? onMotiveDescribed;
  final Function(int?) onMotiveUpdate;
  final List<String> dennounceMotives;
  final String denounceDescription;
  final double contentHeight;
  final Function() onSubmit;
  final bool motiveIsOther;
  final Function() cancel;
  final bool isLoading;
  final int groupValue;
  final bool hasError;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cancel,
      child: Visibility(
        visible: show,
        child: KeyboardVisibilityBuilder(
          builder: (context, _, isKeyboardVisible) {
            return AnimatedContainer(
              padding: padding?.call(isKeyboardVisible) ?? _defaultPadding(isKeyboardVisible),
              color: AppColors.black.withOpacity(.6),
              duration: Duration(milliseconds: 500),
              margin: EdgeInsets.zero,
              height: Get.height,
              width: Get.width,
              child: Card(
                elevation: 16.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0.h),
                ),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0.h), color: AppColors.white),
                  height: motiveIsOther ? Get.width * 1.15 : Get.width / 1.17,
                  margin: EdgeInsets.zero,
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      _title(),
                      _content(),
                      _bottom(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Column _title() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OneLineText(text: 'Qual motivo da sua denúncia?', fontSize: 18),
        ),
        Divider(),
      ],
    );
  }

  Widget _content() {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.zero,
      height: contentHeight,
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          ...dennounceMotives
              .map(
                (motive) => RadioListTile(
                  title: AutoSizeTexts.autoSizeText14(motive),
                  value: dennounceMotives.indexOf(motive),
                  activeColor: AppColors.secondary,
                  onChanged: onMotiveUpdate,
                  groupValue: groupValue,
                ),
              )
              .toList(),
          Visibility(
            visible: motiveIsOther,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: TextArea(
                initialValue: denounceDescription,
                labelText: 'Especifique o motivo',
                onChanged: onMotiveDescribed,
                isInErrorState: hasError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _bottom() {
    return Column(
      children: [
        Divider(),
        Padding(
          padding: EdgeInsets.only(right: 8.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(child: AutoSizeTexts.autoSizeText14(AppStrings.cancel), onPressed: cancel),
              Visibility(
                replacement: _circularProgressIndicator(),
                child: TextButton(
                  child: AutoSizeTexts.autoSizeText14(DennounceStrings.dennounce),
                  onPressed: onSubmit,
                ),
                visible: !isLoading,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circularProgressIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: CircularProgressIndicator(strokeWidth: 2),
      height: 16.0.h,
      width: 16.0.h,
    );
  }

  EdgeInsetsGeometry _defaultPadding(bool keyboardIsVisible) {
    return EdgeInsets.only(
      bottom: Dimensions.getDimensBasedOnDeviceHeight(
        xSmaller: keyboardIsVisible
            ? Get.width / 2.25
            : motiveIsOther
                ? hasError
                    ? Get.width / 4.0
                    : Get.width / 3.6
                : Get.width / 2.0,
        smaller: keyboardIsVisible
            ? 0.h
            : motiveIsOther
                ? hasError
                    ? Get.width / 8.0
                    : Get.width / 5.0
                : Get.width / 2.0,
        medium: keyboardIsVisible
            ? 8.0.h
            : motiveIsOther
                ? hasError
                    ? Get.width / 2.5
                    : Get.width / 2.2
                : Get.width / 2.1,
        bigger: keyboardIsVisible
            ? Get.width * .825
            : motiveIsOther
                ? Get.width / 3.2
                : Get.width / 2,
      ),
      top: Dimensions.getDimensBasedOnDeviceHeight(
        xSmaller: keyboardIsVisible
            ? 0
            : motiveIsOther
                ? _topPadding(hasError, keyboardIsVisible)
                : Get.width / 3.0,
        bigger: motiveIsOther
            ? _topPadding(hasError, keyboardIsVisible)
            : keyboardIsVisible
                ? Get.width / 1.225
                : Get.width / 1.3,
        smaller: motiveIsOther
            ? _topPadding(hasError, keyboardIsVisible)
            : keyboardIsVisible
                ? Get.width / 2.5
                : Get.width / 3.0,
        medium: motiveIsOther
            ? _topPadding(hasError, keyboardIsVisible)
            : keyboardIsVisible
                ? Get.width / 1.5
                : Get.width / 1.3,
      ),
      right: Dimensions.getDimensBasedOnDeviceHeight(
        smaller: 32.0.w,
        bigger: 56.0.w,
        medium: 56.0.w,
      ),
      left: Dimensions.getDimensBasedOnDeviceHeight(
        smaller: 32.0.w,
        bigger: 56.0.w,
        medium: 56.0.w,
      ),
    );
  }

  double _topPadding(bool hasError, bool keyboardIsVisible) {
    return Dimensions.getDimensBasedOnDeviceHeight(
      xSmaller: keyboardIsVisible ? 12.0.h : Get.width * .225,
      smaller: keyboardIsVisible ? 32.0.h : Get.width / 3,
      bigger: keyboardIsVisible
          ? Get.width * .225
          : hasError
              ? Get.width * .65
              : Get.width * .7,
      medium: keyboardIsVisible ? 32.0.h : Get.width * .475,
    );
  }
}
