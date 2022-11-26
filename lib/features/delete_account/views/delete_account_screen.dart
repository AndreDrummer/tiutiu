import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:tiutiu/core/widgets/column_button_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/load_dark_screen.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccountScreen extends StatelessWidget with TiuTiuPopUp {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        deleteAccountController.reset();
        return true;
      },
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              appBar: DefaultBasicAppBar(
                text: DeleteAccountStrings.tellUsTheMotive,
                backgroundColor: AppColors.danger,
              ),
              body: ListView(
                children: [
                  _deleteAccountOptions(),
                  _describedMotiveTextArea(),
                ],
              ),
              bottomNavigationBar: _submitButton(),
            ),
            LoadDarkScreen(
              message: deleteAccountController.loadingText,
              visible: deleteAccountController.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteAccountOptions() {
    final motives = deleteAccountController.deleteAccountMotives;
    return SizedBox(
      height: Get.height / 1.9,
      child: ListView.builder(
        itemCount: motives.length,
        itemBuilder: (context, index) {
          final motive = motives[index];

          return RadioListTile(
            value: deleteAccountController.deleteAccountMotives.indexOf(motive),
            groupValue: deleteAccountController.deleteAccountGroupValue,
            title: AutoSizeTexts.autoSizeText14(motive),
            activeColor: AppColors.secondary,
            onChanged: (int? value) {
              deleteAccountController.deleteAccountMotive = motives[value!];
              deleteAccountController.deleteAccountGroupValue = value;
            },
          );
        },
      ),
    );
  }

  Visibility _describedMotiveTextArea() {
    final motiveIsBug = deleteAccountController.deleteAccountMotive == DeleteAccountStrings.bugs;

    return Visibility(
      visible: deleteAccountController.deleteAccountMotive == DeleteAccountStrings.other || motiveIsBug,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextArea(
          labelText: motiveIsBug ? DeleteAccountStrings.whichBugs : AppStrings.jotSomethingDown,
          initialValue: deleteAccountController.deleteAccountMotiveDescribed,
          isInErrorState: deleteAccountController.hasError,
          onSubmit: (value) {
            deleteAccountController.deleteAccountMotiveDescribed = value;
            if (value.isNotEmpty) deleteAccountController.deleteAccountMotiveDescribed = value;
          },
          onChanged: (value) {
            if (value.isEmpty) deleteAccountController.deleteAccountMotiveDescribed = value;
          },
        ),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 112.0.h,
      child: ColumnButtonBar(
        onPrimaryPressed: _onDeleteAccountButtonPressed,
        textPrimary: DeleteAccountStrings.deleteAccount,
        buttonPrimaryColor: AppColors.danger,
        onSecondaryPressed: () {
          deleteAccountController.reset();
          Get.back();
        },
      ),
    );
  }

  Future<void> _onDeleteAccountButtonPressed() async {
    deleteAccountController.hasError = (deleteAccountController.deleteAccountMotive == DeleteAccountStrings.other ||
            deleteAccountController.deleteAccountMotive == DeleteAccountStrings.bugs) &&
        deleteAccountController.deleteAccountMotiveDescribed.isEmpty;

    if (!deleteAccountController.hasError) {
      deleteAccountController.canDeleteAccount().then((canDeleteAccount) async {
        if (canDeleteAccount) {
          await _deleteAccountForever();
        } else {
          deleteAccountController.showDeleteAccountLogoutWarningPopup().then((_) => Get.back());
        }
      });
    }
  }

  Future<void> _deleteAccountForever() async {
    await showPopUp(
      secondaryAction: () async {
        Get.back();
        await deleteAccountController.deleteAccountForever();
      },
      message: AuthStrings.deleteAccountWarning,
      title: AuthStrings.deleteAccount,
      confirmText: AppStrings.yes,
      barrierDismissible: false,
      denyText: AppStrings.no,
      mainAction: Get.back,
      warning: false,
      error: true,
    );
  }
}
