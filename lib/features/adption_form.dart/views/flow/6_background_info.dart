import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundInfo extends StatefulWidget {
  const BackgroundInfo({super.key});

  @override
  State<BackgroundInfo> createState() => _BackgroundInfoState();
}

class _BackgroundInfoState extends State<BackgroundInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 8.0.h),
            children: [
              SizedBox(height: 16.0.h),
              _availabletoAnswerAboutBackground(),
              SizedBox(height: 8.0.w),
              _allowEnterInContact(),
            ],
          );
        },
      ),
    );
  }

  Column _availabletoAnswerAboutBackground() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0.h),
          child: AutoSizeTexts.autoSizeText16(
            'Você está disposto a passar por uma verificação de antecedentes?',
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: AutoSizeTexts.autoSizeText12(AppStrings.yes),
                onChanged: (_) {
                  adoptionFormController.setAdoptionForm(
                    adoptionFormController.adoptionForm.copyWith(availableForBackgroundCheck: true),
                  );
                },
                value: adoptionFormController.adoptionForm.availableForBackgroundCheck,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: AutoSizeTexts.autoSizeText12(AppStrings.no),
                onChanged: (_) {
                  adoptionFormController.setAdoptionForm(
                    adoptionFormController.adoptionForm.copyWith(availableForBackgroundCheck: false),
                  );
                },
                value: !adoptionFormController.adoptionForm.availableForBackgroundCheck,
              ),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }

  Column _allowEnterInContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0.h),
          child: AutoSizeTexts.autoSizeText16(
            'Você autoriza que entre em contato com seus contatos de referências?',
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: AutoSizeTexts.autoSizeText12(AppStrings.yes),
                onChanged: (_) {
                  adoptionFormController.setAdoptionForm(
                    adoptionFormController.adoptionForm.copyWith(allowContactWithYourReferences: true),
                  );
                },
                value: adoptionFormController.adoptionForm.allowContactWithYourReferences,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: AutoSizeTexts.autoSizeText12(AppStrings.no),
                onChanged: (_) {
                  adoptionFormController.setAdoptionForm(
                    adoptionFormController.adoptionForm.copyWith(allowContactWithYourReferences: false),
                  );
                },
                value: !adoptionFormController.adoptionForm.allowContactWithYourReferences,
              ),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
