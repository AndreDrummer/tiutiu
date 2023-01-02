import 'package:tiutiu/features/posts/widgets/text_area.dart';
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

  final void Function(String)? onMotiveDescribed;
  final Function(int?) onMotiveUpdate;
  final List<String> dennounceMotives;
  final EdgeInsetsGeometry? padding;
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
    return Visibility(
      visible: show,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.zero,
        height: Get.height,
        padding: padding ?? _defaultPadding(),
        width: Get.width,
        color: AppColors.black.withOpacity(.5),
        child: Card(
          elevation: 16.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.h),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0.h),
              color: AppColors.white,
            ),
            height: motiveIsOther ? Get.width * 1.15 : Get.width / 1.17,
            margin: EdgeInsets.zero,
            child: ListView(
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

  Column _content() {
    return Column(
      children: [
        SizedBox(
          height: contentHeight,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: dennounceMotives.length,
            itemBuilder: (context, index) {
              final motive = dennounceMotives[index];

              return RadioListTile(
                title: AutoSizeTexts.autoSizeText14(motive),
                value: dennounceMotives.indexOf(motive),
                activeColor: AppColors.secondary,
                onChanged: onMotiveUpdate,
                groupValue: groupValue,
              );
            },
          ),
        ),
        Visibility(
          visible: motiveIsOther,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0.w),
            child: TextArea(
              initialValue: denounceDescription,
              labelText: 'Especifique o motivo',
              onChanged: onMotiveDescribed,
              isInErrorState: hasError,
            ),
          ),
        ),
      ],
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

  double _topPadding(bool hasError) {
    return Dimensions.getDimensBasedOnDeviceHeight(
      smaller: hasError ? Get.width * .65 : Get.width * .525,
      bigger: hasError ? Get.width * .65 : Get.width * .725,
      medium: hasError ? Get.width * .65 : Get.width * .625,
    );
  }

  EdgeInsetsGeometry _defaultPadding() {
    return EdgeInsets.only(
      bottom: Dimensions.getDimensBasedOnDeviceHeight(
        smaller: motiveIsOther ? Get.width / 3.3 : Get.width / 3,
        bigger: motiveIsOther ? Get.width / 3.2 : Get.width / 2,
        medium: motiveIsOther ? Get.width / 3.2 : Get.width / 2.1,
      ),
      top: Dimensions.getDimensBasedOnDeviceHeight(
        smaller: motiveIsOther ? _topPadding(hasError) : Get.width / 1.225,
        bigger: motiveIsOther ? _topPadding(hasError) : Get.width / 1.225,
        medium: motiveIsOther ? _topPadding(hasError) : Get.width / 1.3,
      ),
      right: Dimensions.getDimensBasedOnDeviceHeight(
        smaller: 56.0.w,
        bigger: 56.0.w,
        medium: 56.0.w,
      ),
      left: Dimensions.getDimensBasedOnDeviceHeight(
        smaller: 56.0.w,
        bigger: 56.0.w,
        medium: 56.0.w,
      ),
    );
  }
}
