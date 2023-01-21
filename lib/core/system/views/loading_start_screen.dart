import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/system/app_bootstrap.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/tiutiu_logo.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

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
        color: AppColors.primary,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            _loadingIndicator(),
            _feedbackText(),
          ],
        ),
      ),
    );
  }

  AutoSizeText _feedbackText() {
    return AutoSizeTexts.autoSizeText10(
      AppStrings.weAreGettingAllReady,
      color: Colors.white,
    );
  }

  Widget _loadingIndicator() {
    return Container(
      margin: EdgeInsets.only(top: 16.0.h, bottom: 8.0.h),
      height: 1.0.h,
      width: 56.0.w,
      child: LinearProgressIndicator(
        backgroundColor: Colors.white,
        color: AppColors.primary,
      ),
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
