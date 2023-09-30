import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DennouncePopupContent extends StatelessWidget {
  const DennouncePopupContent({
    required this.denounceDescription,
    required this.dennounceMotives,
    required this.onMotiveUpdate,
    this.motiveIsOther = true,
    required this.groupValue,
    this.isLoading = false,
    required this.hasError,
    this.onMotiveDescribed,
    required this.onSubmit,
    required this.cancel,
    super.key,
  });

  final void Function(String)? onMotiveDescribed;
  final Function(int?) onMotiveUpdate;
  final String denounceDescription;
  final List dennounceMotives;
  final Function() onSubmit;
  final bool motiveIsOther;
  final Function() cancel;
  final bool isLoading;
  final int groupValue;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        _title(context),
        _content(context),
        _bottom(context),
      ],
    );
  }

  Column _title(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: OneLineText(text: AppLocalizations.of(context)!.whichIsDennounceMotive, fontSize: 18),
        ),
        Divider(),
      ],
    );
  }

  Widget _content(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.zero,
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
                labelText: AppLocalizations.of(context)!.specifyDennounceMotive,
                initialValue: denounceDescription,
                onChanged: onMotiveDescribed,
                isInErrorState: hasError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _bottom(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Padding(
          padding: EdgeInsets.only(right: 8.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: AutoSizeTexts.autoSizeText14(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  Get.back();
                  cancel();
                },
              ),
              Visibility(
                replacement: _circularProgressIndicator(),
                child: TextButton(
                  child: AutoSizeTexts.autoSizeText14(AppLocalizations.of(context)!.dennounce),
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
}
