import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sponsored extends StatelessWidget {
  const Sponsored({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.black,
      AppColors.danger,
      AppColors.info,
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
    ];

    return Obx(
      () => Visibility(
        visible: adminRemoteConfigController.configs.showSponsoredAds,
        child: CarouselSlider.builder(
          itemCount: colors.length,
          itemBuilder: (context, index, realIndex) {
            return Card(
              margin: EdgeInsets.only(top: 4.0.h),
              elevation: 8.0,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0.h),
                      color: colors[index],
                    ),
                    width: Get.width,
                    height: 96.0.h,
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              style: BorderStyle.solid,
                              color: colors[index],
                              width: 1.0.w,
                            ),
                          ),
                          child: AutoSizeTexts.autoSizeText12(
                            color: AppColors.black,
                            'Logo',
                          ),
                          width: Get.width / 4,
                        ),
                        SizedBox(width: 8.0.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2.0.h),
                            AutoSizeTexts.autoSizeText16(
                              'O nome da sua empresa',
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(height: 4.0.h),
                            AutoSizeTexts.autoSizeText10(
                              'Seu slogan',
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                              color: AppColors.white,
                            ),
                            Spacer(),
                            AutoSizeTexts.autoSizeText(
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                              fontSize: 8,
                              'Contato',
                            ),
                            Row(
                              children: [
                                AutoSizeTexts.autoSizeText10(
                                  '(11) 9 9999-9999',
                                  color: AppColors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 6.0.h),
                                  child: Icon(
                                    Icons.phone,
                                    size: 6.0.h,
                                    color: AppColors.white,
                                  ),
                                ),
                                AutoSizeTexts.autoSizeText10(
                                  ' | (11) 9 9999-9999',
                                  color: AppColors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.0.h),
                                  child: Icon(
                                    FontAwesomeIcons.whatsapp,
                                    size: 6.0.h,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 32.0.h,
                    right: 32.0.w,
                    child: AutoSizeTexts.autoSizeText22(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      'Anúncie Aqui',
                    ),
                  )
                ],
              ),
            );
          },
          options: CarouselOptions(
            enableInfiniteScroll: colors.length > 1,
            autoPlayCurve: Curves.easeIn,
            enlargeCenterPage: true,
            viewportFraction: 1,
            autoPlay: true,
            height: 96.0.h,
          ),
        ),
      ),
    );
  }
}
