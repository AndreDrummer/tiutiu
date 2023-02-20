import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/system/app_bootstrap.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/tiutiu_logo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingStartScreen extends StatefulWidget {
  const LoadingStartScreen({super.key});

  @override
  State<LoadingStartScreen> createState() => _LoadingStartScreenState();
}

class _LoadingStartScreenState extends State<LoadingStartScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: systemController.loadApp(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
          case ConnectionState.none:
            return SplashScreenLoading();
          case ConnectionState.done:
            return systemController.properties.isLoading ? SplashScreenLoading() : AppBootstrap();
        }
      },
    );
  }
}

class SplashScreenLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primaryDark,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Stack(
              children: [
                TiutiuLogo(spaceBetween: 16.0.h, textHeight: 20),
                Positioned(
                  bottom: 24.0.h,
                  right: 0.0.w,
                  child: _versionInfo(),
                )
              ],
            ),
            _feedbackText(context),
            _loadingIndicator(),
            Spacer(),
            _madeBy(context)
          ],
        ),
      ),
    );
  }

  Widget _feedbackText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0.h, bottom: 8.0.h),
      child: AutoSizeTexts.autoSizeText10(
        AppLocalizations.of(context).weAreGettingAllReady,
        color: Colors.white,
      ),
    );
  }

  Widget _loadingIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0.h),
      height: 1.0.h,
      width: 104.0.w,
      child: LinearProgressIndicator(
        backgroundColor: Colors.white,
        color: AppColors.primary,
      ),
    );
  }

  Stack _madeBy(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 16.0.h),
          height: 120.0.h,
          width: Get.width,
        ),
        Positioned(
          bottom: 16.0.h,
          left: Get.width / 2.5,
          child: Row(
            children: [
              AutoSizeText(
                AppLocalizations.of(context).madeBy,
                minFontSize: 10,
                maxFontSize: 12,
                style: GoogleFonts.inter(
                  fontStyle: FontStyle.italic,
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 4.0.w),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0.h),
                child: AutoSizeText(
                  'Anja',
                  minFontSize: 14,
                  maxFontSize: 16,
                  style: GoogleFonts.krub(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _versionInfo() {
    final runningVersions = systemController.properties.runningVersion;
    return Visibility(
      visible: systemController.properties.runningVersion.isNotEmpty,
      child: AutoSizeTexts.autoSizeText('v$runningVersions', color: Colors.white, fontSize: 8),
    );
  }
}
