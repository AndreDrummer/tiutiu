import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/auth/widgets/blur.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/widgets/tiutiu_logo.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocScreen extends StatelessWidget {
  const DocScreen({super.key, required this.docType, required this.docTitle});

  final String docTitle;
  final String docType;

  Future<DocumentSnapshot<Map<String, dynamic>>> _getDocuments() async {
    return await FirebaseFirestore.instance
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.documents)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ImageCarouselBackground(autoPlay: false),
          Blur(darker: true),
          SafeArea(
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _getDocuments(),
              builder: (context, snapshot) {
                return AsyncHandler<DocumentSnapshot<Map<String, dynamic>>>(
                  buildWidget: (documents) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: Stack(
                        children: [
                          ListView(
                            children: [
                              SizedBox(height: 8.0.h),
                              TiutiuLogo(),
                              SizedBox(height: 8.0.h),
                              AutoSizeTexts.autoSizeText24(
                                textAlign: TextAlign.center,
                                color: AppColors.white,
                                docTitle,
                              ),
                              SizedBox(height: 16.0.h),
                              AutoSizeTexts.autoSizeText16(
                                (documents.get(docType) as String).replaceAll('/n', '\n'),
                                textAlign: TextAlign.justify,
                                color: AppColors.white,
                              ),
                              SizedBox(height: 64.0.h)
                            ],
                          ),
                          Positioned(
                            left: 0.0.w,
                            right: 0.0.w,
                            bottom: 0.0.h,
                            child: ButtonWide(
                              text: AppStrings.back,
                              onPressed: Get.back,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  snapshot: snapshot,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
