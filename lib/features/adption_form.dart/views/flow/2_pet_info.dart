import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/widgets/outline_input_text.dart';
import 'package:tiutiu/core/widgets/underline_input_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetInfo extends StatefulWidget {
  const PetInfo({super.key});

  @override
  State<PetInfo> createState() => _PetInfoState();
}

class _PetInfoState extends State<PetInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: 'Formulário de adoção'),
      body: Obx(
        () {
          return ListView(
            children: [
              SizedBox(height: 8.0.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OneLineText(
                  text: '2. Informações sobre o animal',
                  fontSize: 14,
                ),
              ),
              Divider(height: 8.0.h),
              UnderlineInputDropdown(
                initialValue: adoptionFormController.adoptionForm.age!,
                onChanged: (type) {
                  adoptionFormController.setAdoptionForm(
                    adoptionFormController.adoptionForm.copyWith(interestedType: type),
                  );
                },
                labelText: 'Qual tipo de animal está interessado?',
                fontSize: 14,
                items: List.generate(99, (index) => '$index'),
              ),
              SizedBox(height: 8.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                child: OutlinedInputText(
                  textColor: AppColors.black.withOpacity(.5),
                  labelText: 'Qual a raça',
                  hintText: 'Qual a raça',
                  initialValue: adoptionFormController.adoptionForm.interestedBreed,
                  onChanged: (value) {
                    adoptionFormController.setAdoptionForm(
                      adoptionFormController.adoptionForm.copyWith(interestedBreed: value),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.h),
                child: AutoSizeTexts.autoSizeText16(
                  'Você tem experiência com esse tipo de animal?',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 8.0.w),
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: AutoSizeTexts.autoSizeText12(AppStrings.yes),
                      onChanged: (_) {
                        adoptionFormController.setAdoptionForm(
                          adoptionFormController.adoptionForm.copyWith(alreadyHadAnimalsLikeThat: true),
                        );
                      },
                      value: adoptionFormController.adoptionForm.alreadyHadAnimalsLikeThat,
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: AutoSizeTexts.autoSizeText12(AppStrings.no),
                      onChanged: (_) {
                        adoptionFormController.setAdoptionForm(
                          adoptionFormController.adoptionForm.copyWith(alreadyHadAnimalsLikeThat: false),
                        );
                      },
                      value: !adoptionFormController.adoptionForm.alreadyHadAnimalsLikeThat,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                child: OutlinedInputText(
                  textColor: AppColors.black.withOpacity(.5),
                  labelText: 'Por que você quer adotar esse animal em particular?',
                  hintText: 'Por que você quer adotar esse animal em particular?',
                  initialValue: adoptionFormController.adoptionForm.reason,
                  onChanged: (value) {
                    adoptionFormController.setAdoptionForm(
                      adoptionFormController.adoptionForm.copyWith(reason: value),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
