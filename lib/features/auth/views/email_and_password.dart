import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:tiutiu/features/auth/models/email_password_auth.dart';
import 'package:tiutiu/features/auth/widgets/dark_over.dart';
import 'package:tiutiu/features/auth/widgets/headline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/outline_input_text.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/validators.dart';
import 'package:tiutiu/Widgets/cancel_button.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:tiutiu/Widgets/tiutiu_logo.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailAndPassword extends StatelessWidget {
  EmailAndPassword({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primary.withAlpha(100),
      body: Stack(
        children: [
          ImageCarouselBackground(),
          DarkOver(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 32.0.h),
                    TiutiuLogo(),
                    Spacer(),
                    _createAccountHeadline(),
                    _doLoginHeadline(),
                    SizedBox(height: 16.0.h),
                    _emailInput(),
                    _passwordInput(),
                    _repeatPasswordInput(),
                    _createAccountTip(),
                    Spacer(),
                    _submitButton(),
                    _cancelButton(),
                    SizedBox(height: 8.0.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedOpacity _createAccountHeadline() {
    return AnimatedOpacity(
      opacity: authController.isCreatingNewAccount ? 1 : 0,
      duration: Duration(seconds: 2),
      child: Visibility(
        visible: authController.isCreatingNewAccount,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Headline(
            text: AuthStrings.createNewAccount,
            textColor: AppColors.white,
          ),
        ),
      ),
    );
  }

  AnimatedOpacity _doLoginHeadline() {
    return AnimatedOpacity(
      opacity: !authController.isCreatingNewAccount ? 1 : 0,
      duration: Duration(seconds: 2),
      child: Visibility(
        visible: !authController.isCreatingNewAccount,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Headline(
            text: AuthStrings.enterAccount,
            textColor: AppColors.white,
          ),
        ),
      ),
    );
  }

  OutlinedInputText _emailInput() {
    return OutlinedInputText(
      initialValue: authController.emailAndPasswordAuth.email,
      keyboardType: TextInputType.emailAddress,
      onChanged: (email) {
        authController.updateEmailAndPasswordAuth(
          EmailAndPasswordAuthEnum.email,
          email,
        );
      },
      validator: Validators.verifyEmail,
    );
  }

  OutlinedInputText _passwordInput() {
    return OutlinedInputText(
      initialValue: authController.emailAndPasswordAuth.password,
      validator: Validators.verifyEmpty,
      onPasswordVisibilityChange: () {
        authController.isShowingPassword = !authController.isShowingPassword;
      },
      onChanged: (password) {
        authController.updateEmailAndPasswordAuth(
          EmailAndPasswordAuthEnum.password,
          password,
        );
      },
      showPassword: authController.isShowingPassword,
      labelText: AppStrings.password,
      isPassword: true,
    );
  }

  AnimatedOpacity _repeatPasswordInput() {
    return AnimatedOpacity(
      opacity: authController.isCreatingNewAccount ? 1 : 0,
      duration: Duration(seconds: 2),
      child: Visibility(
        visible: authController.isCreatingNewAccount,
        child: OutlinedInputText(
          initialValue: authController.emailAndPasswordAuth.repeatPassword,
          onChanged: (password) {
            authController.updateEmailAndPasswordAuth(
              EmailAndPasswordAuthEnum.repeatPassword,
              password,
            );
          },
          validator: (repeatedPassword) => Validators.verifyEquity(
            password: authController.emailAndPasswordAuth.password,
            repeatPassword: repeatedPassword,
          ),
          onPasswordVisibilityChange: () {
            authController.isShowingPassword =
                !authController.isShowingPassword;
          },
          showPassword: authController.isShowingPassword,
          labelText: AppStrings.repeatPassword,
          isPassword: true,
        ),
      ),
    );
  }

  Padding _createAccountTip() {
    return Padding(
      padding: EdgeInsets.only(right: 8.0.w),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          authController.isCreatingNewAccount =
              !authController.isCreatingNewAccount;
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OneLineText(
              text: authController.isCreatingNewAccount
                  ? AuthStrings.haveAnAccount
                  : AuthStrings.doNotHaveAnAccount,
              alignment: Alignment.centerRight,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
            SizedBox(width: 4.0.w),
            OneLineText(
              alignment: Alignment.centerRight,
              text: authController.isCreatingNewAccount
                  ? AuthStrings.enterAccount
                  : AuthStrings.createYours,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  ButtonWide _submitButton() {
    return ButtonWide(
      text: authController.isCreatingNewAccount
          ? AuthStrings.createAccount
          : AuthStrings.enter,
      isToExpand: true,
      action: () {
        if (_formKey.currentState!.validate()) {
          debugPrint('>> tudo ok');
          authController.createUserWithEmailAndPassword();
        }
      },
    );
  }

  Widget _cancelButton() {
    return Center(
      child: CancelButton(
        onCancel: () {
          authController.clearEmailAndPassword();
          Get.back();
        },
      ),
    );
  }
}
