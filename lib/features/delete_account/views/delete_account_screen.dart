import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:tiutiu/core/widgets/column_button_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/views/load_dark_screen.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccountScreen extends StatelessWidget with TiuTiuPopUp {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) async {
        deleteAccountController.reset();
      },
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              appBar: DefaultBasicAppBar(
                text: AppLocalizations.of(context)!.tellUsTheMotive,
                backgroundColor: AppColors.danger,
              ),
              body: Column(
                children: [
                  _deleteAccountOptions(),
                  _describedMotiveTextArea(context),
                  Spacer(),
                  _submitButton(context),
                ],
              ),
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
    return Container(
      height: Get.height / 2.05,
      child: GridView.count(
        padding: EdgeInsets.only(top: 8.0.h),
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 3.8,
        crossAxisSpacing: 2.0.h,
        mainAxisSpacing: 32.0.h,
        crossAxisCount: 2,
        children: motives.map((motive) {
          return SizedBox(
            height: 12.0.h,
            child: RadioListTile(
              value:
                  deleteAccountController.deleteAccountMotives.indexOf(motive),
              groupValue: deleteAccountController.deleteAccountGroupValue,
              title: AutoSizeTexts.autoSizeText14(motive),
              activeColor: AppColors.secondary,
              onChanged: (int? value) {
                deleteAccountController.deleteAccountMotive = motives[value!];
                deleteAccountController.deleteAccountGroupValue = value;
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Visibility _describedMotiveTextArea(BuildContext context) {
    final motiveIsBug = deleteAccountController.deleteAccountMotive ==
        AppLocalizations.of(context)!.bugs;

    return Visibility(
      visible: deleteAccountController.deleteAccountMotive ==
              AppLocalizations.of(context)!.other ||
          motiveIsBug,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextArea(
          maxLines: 2,
          labelText: motiveIsBug
              ? AppLocalizations.of(context)!.whichBugs
              : AppLocalizations.of(context)!.jotSomethingDown,
          initialValue: deleteAccountController.deleteAccountMotiveDescribed,
          isInErrorState: deleteAccountController.hasError,
          onSubmit: (value) {
            deleteAccountController.deleteAccountMotiveDescribed = value.trim();
            if (value.isNotEmpty)
              deleteAccountController.deleteAccountMotiveDescribed =
                  value.trim();
          },
          onChanged: (value) {
            if (value.isEmpty)
              deleteAccountController.deleteAccountMotiveDescribed =
                  value.trim();
          },
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      width: double.infinity,
      height: 120.0.h,
      child: ColumnButtonBar(
        onPrimaryPressed: () => _onDeleteAccountButtonPressed(context),
        isConnected: systemController.properties.internetConnected,
        textPrimary: AppLocalizations.of(context)!.deleteAccount,
        buttonPrimaryColor: AppColors.danger,
        onSecondaryPressed: () {
          deleteAccountController.reset();
          Get.back();
        },
      ),
    );
  }

  Future<void> _onDeleteAccountButtonPressed(BuildContext context) async {
    deleteAccountController.hasError =
        (deleteAccountController.deleteAccountMotive ==
                    AppLocalizations.of(context)!.other ||
                deleteAccountController.deleteAccountMotive ==
                    AppLocalizations.of(context)!.bugs) &&
            deleteAccountController.deleteAccountMotiveDescribed.isEmpty;

    if (!deleteAccountController.hasError) {
      deleteAccountController.canDeleteAccount().then((canDeleteAccount) async {
        if (canDeleteAccount) {
          await _deleteAccountForever();
        } else {
          deleteAccountController
              .showDeleteAccountLogoutWarningPopup()
              .then((_) => Get.back());
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
      message: AppLocalizations.of(Get.context!)!.deleteAccountWarning,
      backGroundColor: AppColors.danger,
      title: AppLocalizations.of(Get.context!)!.deleteAccount,
      confirmText: AppLocalizations.of(Get.context!)!.yes,
      barrierDismissible: false,
      denyText: AppLocalizations.of(Get.context!)!.no,
      mainAction: Get.back,
    );
  }
}
