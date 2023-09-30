import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:tiutiu/features/auth/views/terms_and_conditions.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/auth/views/privacy_policy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/auth/widgets/blur.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/tiutiu_logo.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartScreen extends StatefulWidget {
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(
        () {
          final hasAcceptedTerms = authController.userExists
              ? tiutiuUserController.tiutiuUser.hasAcceptedTerms
              : systemController.properties.hasAcceptedTerms;

          return Stack(
            children: [
              ImageCarouselBackground(),
              Blur(),
              Positioned(
                bottom: 16.0.h,
                right: 0.0.h,
                left: 0.0.h,
                child: Container(
                  alignment: Alignment.center,
                  height: 300.0.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AutoSizeTexts.autoSizeText32(
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        AppLocalizations.of(context)!.headline1,
                        fontSize: 32.0,
                      ),
                      SizedBox(height: 24.0.h),
                      AutoSizeTexts.autoSizeText22(
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w300,
                        color: AppColors.white,
                        AppLocalizations.of(context)!.headline2,
                        fontSize: 20.0,
                      ),
                      Spacer(),
                      _docButtons(context, hasAcceptedTerms: hasAcceptedTerms),
                      SizedBox(height: 8.0.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ButtonWide(
                          text: AppLocalizations.of(context)!.getStarted,
                          color: AppColors.primary,
                          onPressed: () async {
                            if (hasAcceptedTerms) {
                              Get.toNamed(Routes.authOrHome);
                              filterController.reset();
                            } else {
                              setState(() => hasError = true);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 8.0.w,
                top: 40.0.h,
                left: 8.0.w,
                child: SizedBox(
                  width: Get.width,
                  child: TiutiuLogo(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _docButtons(BuildContext context, {required bool hasAcceptedTerms}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AutoSizeTexts.autoSizeText12(
          color: hasError ? Colors.amber : AppColors.white,
          AppLocalizations.of(context)!.whenContinue,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Theme(
              data: ThemeData(unselectedWidgetColor: hasError ? Colors.amber : AppColors.white),
              child: Checkbox(
                value: hasAcceptedTerms,
                visualDensity: VisualDensity.comfortable,
                activeColor: AppColors.secondary,
                checkColor: Colors.white,
                onChanged: (value) {
                  tiutiuUserController.updateTiutiuUser(TiutiuUserEnum.hasAcceptedTerms, value);
                  authController.saveUserTermsAndConditionsChoice();
                  setState(() => hasError = false);
                },
              ),
            ),
            termsAndConditions(context),
            AutoSizeTexts.autoSizeText14(
              color: hasError ? Colors.amber : AppColors.white,
              '${AppLocalizations.of(context)!.andThe} ',
              textAlign: TextAlign.center,
            ),
            privacyPolicy(context),
          ],
        )
      ],
    );
  }

  Widget termsAndConditions(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(TermsAndConditions());
      },
      child: AutoSizeTexts.autoSizeText14(
        color: hasError ? Colors.amber : AppColors.white,
        AppLocalizations.of(context)!.termsAndConditions,
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget privacyPolicy(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(PrivacyPolicy());
      },
      child: AutoSizeTexts.autoSizeText14(
        color: hasError ? Colors.amber : AppColors.white,
        AppLocalizations.of(context)!.privacyPolicy,
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.center,
      ),
    );
  }
}
