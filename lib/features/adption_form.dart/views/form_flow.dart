import 'package:tiutiu/features/adption_form.dart/views/flow/1_personal_info.dart';
import 'package:tiutiu/features/adption_form.dart/views/flow/2_pet_info.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/row_button_bar.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdoptionFormFlow extends StatelessWidget {
  const AdoptionFormFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      PetInfo(),
      PersonalInfo(),
    ];

    return WillPopScope(
      onWillPop: () async {
        adoptionFormController.previousStep();
        return false;
      },
      child: Obx(
        () {
          final title = adoptionFormController.formStepsTitle.elementAt(adoptionFormController.formStep);

          return Scaffold(
            appBar: DefaultBasicAppBar(text: title, automaticallyImplyLeading: true),
            body: steps.elementAt(adoptionFormController.formStep),
            bottomNavigationBar: _flowBottom(),
          );
        },
      ),
    );
  }

  Widget _flowBottom() {
    return Obx(
      () {
        return Container(
          margin: EdgeInsets.only(bottom: 8.0.h),
          child: RowButtonBar(
            isLoading: adoptionFormController.isLoading,
            buttonSecondaryColor: Colors.grey,
            onPrimaryPressed: () {
              adoptionFormController.nextStep();
            },
            onSecondaryPressed: () {
              adoptionFormController.previousStep();
            },
            textPrimary: adoptionFormController.lastStep()
                ? adoptionFormController.isEditing
                    ? AdoptionFormStrings.update
                    : AppStrings.save
                : AppStrings.contines,
            textSecond: AppStrings.back,
          ),
        );
      },
    );
  }
}
