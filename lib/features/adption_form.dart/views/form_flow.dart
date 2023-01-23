import 'package:tiutiu/features/adption_form.dart/views/flow/2_references_contacts.dart';
import 'package:tiutiu/features/adption_form.dart/views/flow/6_background_info.dart';
import 'package:tiutiu/features/adption_form.dart/views/flow/5_financial_info.dart';
import 'package:tiutiu/features/adption_form.dart/views/flow/1_personal_info.dart';
import 'package:tiutiu/features/adption_form.dart/views/flow/4_house_info.dart';
import 'package:tiutiu/features/adption_form.dart/views/flow/3_pet_info.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/row_button_bar.dart';
import 'package:tiutiu/core/views/load_dark_screen.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdoptionFormFlow extends StatelessWidget with TiuTiuPopUp {
  const AdoptionFormFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      PersonalInfo(),
      ReferenceContacts(),
      PetInfo(),
      HouseInfo(),
      FinancialInfo(),
      BackgroundInfo(),
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
            body: Stack(
              children: [
                Scaffold(
                  appBar: DefaultBasicAppBar(text: title, automaticallyImplyLeading: true),
                  body: steps.elementAt(adoptionFormController.formStep),
                  bottomNavigationBar: _flowBottom(),
                ),
                Positioned(
                  right: Get.width / 2.25,
                  left: Get.width / 2.25,
                  top: 70.0.h,
                  child: OneLineText(
                    textAlign: TextAlign.center,
                    text: 'Passo ${adoptionFormController.formStep + 1}',
                    color: AppColors.white,
                    fontSize: 12.0,
                  ),
                ),
                Obx(() {
                  return LoadDarkScreen(
                    message: '${adoptionFormController.isEditing ? 'Atualizando' : 'Salvando'} formulário',
                    visible: adoptionFormController.isLoading,
                  );
                }),
              ],
            ),
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
              if (adoptionFormController.lastStep()) {
                adoptionFormController.saveForm().then((_) {
                  showSuccessPopup();
                });
              } else {
                adoptionFormController.nextStep();
              }
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

  void showSuccessPopup() {
    showPopUp(
      title: AppStrings.success,
      message: AdoptionFormStrings.formFilledSuccess,
      denyText: AdoptionFormStrings.justThis,
      confirmText: AppStrings.share,
      secondaryAction: () {
        Get.back();
        showSharePopup();
      },
      mainAction: () {
        Get.back();
        adoptionFormController.resetForm();
        Get.offNamedUntil(Routes.home, (route) => route.settings.name == Routes.home);
      },
    );
  }

  void showSharePopup() {
    showPopUp(
      title: AppStrings.share,
      message: AdoptionFormStrings.chooseFormFormat,
      denyText: AppStrings.txt,
      confirmText: AppStrings.pdf,
      secondaryAction: () {
        Get.back();
        adoptionFormController.shareFormPDF();
      },
      mainAction: () {
        Get.back();
        adoptionFormController.shareFormText();
      },
    );
  }
}
