import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:tiutiu/core/widgets/outline_input_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HouseInfo extends StatefulWidget {
  const HouseInfo({super.key});

  @override
  State<HouseInfo> createState() => _HouseInfoState();
}

class _HouseInfoState extends State<HouseInfo> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 8.0.h),
          children: [
            SizedBox(height: 16.0.h),
            _houseType(),
            SizedBox(height: 8.0.w),
            _haveYard(),
            _haveChildren(),
            _haveOthersAnaimals(),
          ],
        );
      },
    );
  }

  Widget _houseType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeTexts.autoSizeText14(
          AdoptionFormQuestionsStrings.houseType,
          color: AppColors.black.withOpacity(.5),
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 8.0.h),
        OutlinedInputText(
          textColor: AppColors.black.withOpacity(.5),
          labelText: AdoptionFormQuestionsStrings.houseTypeOptions,
          initialValue: adoptionFormController.adoptionForm.houseType,
          onChanged: (value) {
            adoptionFormController.setAdoptionForm(
              adoptionFormController.adoptionForm.copyWith(houseType: value),
            );
          },
          fontSize: 14,
        ),
      ],
    );
  }

  Column _haveYard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0.h),
          child: AutoSizeTexts.autoSizeText16(
            color: AppColors.black.withOpacity(.5),
            AdoptionFormQuestionsStrings.haveYard,
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
                    adoptionFormController.adoptionForm.copyWith(haveYard: true),
                  );
                },
                value: adoptionFormController.adoptionForm.haveYard,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: AutoSizeTexts.autoSizeText12(AppStrings.no),
                onChanged: (_) {
                  adoptionFormController.setAdoptionForm(
                    adoptionFormController.adoptionForm.copyWith(haveYard: false),
                  );
                },
                value: !adoptionFormController.adoptionForm.haveYard,
              ),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _haveChildren() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeTexts.autoSizeText14(
          AdoptionFormQuestionsStrings.haveChildren,
          color: AppColors.black.withOpacity(.5),
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 8.0.h),
        TextArea(
          labelText: '',
          maxLines: 2,
          initialValue: adoptionFormController.adoptionForm.haveChildren,
          onChanged: (value) {
            adoptionFormController.setAdoptionForm(
              adoptionFormController.adoptionForm.copyWith(haveChildren: value),
            );
          },
        ),
      ],
    );
  }

  Widget _haveOthersAnaimals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeTexts.autoSizeText14(
          AdoptionFormQuestionsStrings.haveAnimals,
          color: AppColors.black.withOpacity(.5),
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 8.0.h),
        TextArea(
          maxLines: 2,
          labelText: '',
          initialValue: adoptionFormController.adoptionForm.thereIsOtherAnimalsInHouse,
          onChanged: (value) {
            adoptionFormController.setAdoptionForm(
              adoptionFormController.adoptionForm.copyWith(thereIsOtherAnimalsInHouse: value),
            );
          },
        ),
      ],
    );
  }
}
