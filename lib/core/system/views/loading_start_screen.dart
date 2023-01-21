import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/features/auth/widgets/blur.dart';
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
            return _SplashScreenLoading();
          case ConnectionState.done:
            return AppBootstrap();
        }
      },
    );
  }
}

class _SplashScreenLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: systemController.getPackageInfo(),
      builder: (context, snapshot) {
        final packageInfo = snapshot.data;

        return Scaffold(
          body: Stack(
            children: [
              ImageCarouselBackground(),
              Blur(darker: true),
              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TiutiuLogo(imageHeight: 32.0.h, spaceBetween: 16.0.h),
                    SizedBox(height: 8.0.h),
                    _versionInfo(packageInfo),
                    SizedBox(height: 24.0.h),
                    _loadingIndicator(),
                    SizedBox(height: 8.0.h),
                    _feedbackText(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  AutoSizeText _feedbackText() {
    return AutoSizeTexts.autoSizeText12(
      AppStrings.weAreGettingAllReady,
      color: Colors.white,
    );
  }

  SizedBox _loadingIndicator() {
    return SizedBox(
      height: 16.0.h,
      width: 16.0.h,
      child: CircularProgressIndicator(
        strokeWidth: 1.0.h,
        backgroundColor: Colors.white,
        color: AppColors.primary,
      ),
    );
  }

  Visibility _versionInfo(PackageInfo? packageInfo) {
    return Visibility(
      visible: packageInfo != null,
      child: AutoSizeTexts.autoSizeText10(
        'v${packageInfo?.version}',
        color: Colors.white,
      ),
    );
  }
}
