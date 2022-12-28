import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:tiutiu/features/auth/models/email_password_auth.dart';
import 'package:tiutiu/core/widgets/outline_input_text.dart';
import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:tiutiu/features/auth/widgets/dark_over.dart';
import 'package:tiutiu/features/auth/widgets/headline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/load_dark_screen.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/tiutiu_logo.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailAndPassword extends StatelessWidget with TiuTiuPopUp {
  EmailAndPassword({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.black.withAlpha(100),
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
                    _resetPasswordHeadline(),
                    SizedBox(height: 16.0.h),
                    _emailInput(),
                    _passwordInput(),
                    _repeatPasswordInput(),
                    _resetPasswordWidget(),
                    Spacer(),
                    _createAccountTip(),
                    _submitButton(context),
                    _SimpleTextButton(),
                    SizedBox(height: 8.0.h),
                  ],
                ),
              ),
            ),
          ),
          _loadingWidget()
        ],
      ),
    );
  }

  AnimatedOpacity _createAccountHeadline() {
    return AnimatedOpacity(
      opacity: authController.isCreatingNewAccount && !authController.isResetingPassword ? 1 : 0,
      duration: Duration(milliseconds: 1500),
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
      opacity: !authController.isCreatingNewAccount && !authController.isResetingPassword ? 1 : 0,
      duration: Duration(milliseconds: 1500),
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

  AnimatedOpacity _resetPasswordHeadline() {
    return AnimatedOpacity(
      opacity: authController.isResetingPassword ? 1 : 0,
      duration: Duration(milliseconds: 1500),
      child: Visibility(
        visible: !authController.isCreatingNewAccount,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Headline(
            text: AuthStrings.resetPassword,
            textColor: AppColors.white,
          ),
        ),
      ),
    );
  }

  OutlinedInputText _emailInput() {
    return OutlinedInputText(
      labelText: authController.isResetingPassword ? AuthStrings.typeYourEmail : AuthStrings.email,
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

  Widget _passwordInput() {
    return AnimatedOpacity(
      opacity: !authController.isResetingPassword ? 1 : 0,
      duration: Duration(milliseconds: 1500),
      child: Visibility(
        visible: !authController.isResetingPassword,
        child: OutlinedInputText(
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
        ),
      ),
    );
  }

  AnimatedOpacity _repeatPasswordInput() {
    return AnimatedOpacity(
      opacity: authController.isCreatingNewAccount ? 1 : 0,
      duration: Duration(milliseconds: 1500),
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
            authController.isShowingPassword = !authController.isShowingPassword;
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
          authController.isCreatingNewAccount = !authController.isCreatingNewAccount;
          authController.isResetingPassword = false;
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OneLineText(
              text: authController.isCreatingNewAccount ? AuthStrings.haveAnAccount : AuthStrings.doNotHaveAnAccount,
              widgetAlignment: Alignment.centerRight,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
            SizedBox(width: 4.0.w),
            OneLineText(
              widgetAlignment: Alignment.centerRight,
              text: authController.isCreatingNewAccount ? AuthStrings.enterAccount : AuthStrings.createYours,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _resetPasswordWidget() {
    return Visibility(
      visible: !authController.isCreatingNewAccount,
      child: Padding(
        padding: EdgeInsets.only(right: 8.0.w),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            authController.isResetingPassword = true;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OneLineText(
                widgetAlignment: Alignment.centerRight,
                text: AuthStrings.forgotPassword,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
              SizedBox(width: 4.0.w),
              OneLineText(
                widgetAlignment: Alignment.centerRight,
                text: AuthStrings.clickHere,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonWide _submitButton(BuildContext context) {
    return ButtonWide(
      text: authController.isCreatingNewAccount
          ? AuthStrings.createAccount
          : authController.isResetingPassword
              ? AuthStrings.receiveEmail
              : AuthStrings.enter,
      isToExpand: true,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _submit(context);
        }
      },
    );
  }

  void _submit(BuildContext context) {
    if (authController.isCreatingNewAccount) {
      _createUserWithEmailAndPassword();
    } else if (authController.isResetingPassword) {
      _resetPassword(context);
    } else {
      _loginWithEmailAndPassword();
    }
  }

  Widget _SimpleTextButton() {
    return Center(
      child: SimpleTextButton(
        onPressed: () {
          authController.clearEmailAndPassword();
          Get.back();
        },
      ),
    );
  }

  Widget _loadingWidget() {
    return Obx(
      () => LoadDarkScreen(
        message: authController.feedbackText,
        visible: authController.isLoading,
      ),
    );
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      await authController.createUserWithEmailAndPassword().then(
        (success) {
          if (success) {
            homeController.setDonateIndex();
            Get.offNamed(Routes.home);
            authController.clearEmailAndPassword();
          }
        },
      );
    } catch (exception) {
      authController.isLoading = false;
      showPopUp(
        title: AuthStrings.authFailure,
        message: exception.toString(),
        error: true,
      );
    }
  }

  Future<void> _loginWithEmailAndPassword() async {
    try {
      await authController.loginWithEmailAndPassword().then((success) {
        if (success) {
          homeController.setDonateIndex();
          Get.offNamed(Routes.home);
          authController.isLoading = false;
        }
      });
    } catch (exception) {
      authController.isLoading = false;

      showPopUp(
        title: AuthStrings.authFailure,
        message: exception.toString(),
        error: true,
      );

      debugPrint('TiuTiuApp: Authentication Failed ${exception.toString()}');
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
    try {
      await authController.passwordReset().then(
        (_) {
          showsOnRequestSuccessPopup(message: AuthStrings.resetPasswordInstructionsSent);
        },
      );
    } catch (exception) {
      authController.isLoading = false;
      showPopUp(
        title: AuthStrings.authFailure,
        message: exception.toString(),
        error: true,
      );
    }
  }
}
