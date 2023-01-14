import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/features/sponsored/model/sponsored.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SponsoredScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double sponsoredAdsTileSize = Dimensions.getDimensBasedOnDeviceHeight(
      bigger: 68.0.h,
      medium: 68.0.h,
      smaller: 80.0.h,
    );

    return StreamBuilder<List<Sponsored>>(
      initialData: [],
      stream: sponsoredController.sponsoredAds(),
      builder: (context, snapshot) {
        return Obx(() {
          final visible = adminRemoteConfigController.configs.showSponsoredAds &&
              systemController.properties.internetConnected &&
              snapshot.data != null;

          final sponsoreds = snapshot.data ?? [];

          return Visibility(
            visible: visible,
            child: CarouselSlider.builder(
              itemCount: sponsoreds.length,
              itemBuilder: (context, index, realIndex) {
                return Card(
                  margin: EdgeInsets.only(top: 4.0.h),
                  elevation: 8.0,
                  child: Stack(
                    children: [
                      Container(
                        height: sponsoredAdsTileSize,
                        width: Get.width,
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: AssetHandle.getImage(sponsoreds[index].imagePath),
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
                        bottom: 16.0.h,
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
                enableInfiniteScroll: sponsoreds.length > 1,
                autoPlayCurve: Curves.easeIn,
                height: sponsoredAdsTileSize,
                enlargeCenterPage: true,
                viewportFraction: 1,
                autoPlay: true,
              ),
            ),
          );
        });
      },
    );
  }
}
