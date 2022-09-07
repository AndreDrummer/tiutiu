import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardAd extends StatelessWidget {
  CardAd({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    List<String> distanceText = OtherFunctions.distanceCalculate(
      context,
      pet.latitude!,
      pet.longitude!,
    );

    return InkWell(
      onTap: () async {},
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            _adImages(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8.0.h),
                  bottomLeft: Radius.circular(8.0.h),
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(8.0.h),
                child: Row(
                  children: [
                    Container(
                      width: Get.width * .93,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _adTitle(),
                              _adDistanceFromUser(distanceText[0])
                            ],
                          ),
                          Row(
                            children: [
                              _adDescription(),
                              Spacer(),
                              _views(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _interesteds(),
                              Spacer(),
                              _cityState(
                                state: pet.state!,
                                city: pet.city!,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _adImages() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.0.h),
          topLeft: Radius.circular(8.0.h),
        ),
      ),
      height: Get.height / 1.8,
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: pet.photos?.length ?? 0,
        itemBuilder: (ctx, index, i) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Container(
              width: double.infinity,
              child: AssetHandle.getImage(pet.photos!.elementAt(index)),
            ),
          );
        },
        options: CarouselOptions(
          enableInfiniteScroll: pet.photos!.length > 1,
          autoPlayCurve: Curves.easeIn,
          disableCenter: true,
          viewportFraction: 1,
          autoPlay: true,
        ),
      ),
    );
  }

  Padding _adTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: AutoSizeText(
        style: TextStyles.fontSize20(
          fontWeight: FontWeight.w700,
        ),
        pet.name!,
      ),
    );
  }

  Padding _adDistanceFromUser(String distanceText) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Row(
        children: [
          AutoSizeText(
            'Está a $distanceText de você',
            style: TextStyles.fontSize12(
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 8.0.w),
          Icon(
            Tiutiu.location_arrow,
            color: Colors.grey,
            size: 12.0.h,
          )
        ],
      ),
    );
  }

  Padding _adDescription() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: AutoSizeText(
        pet.breed!,
        style: TextStyles.fontSize14(
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
    );
  }

  Padding _views() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Row(
        children: [
          Icon(Tiutiu.eye, size: 12.0.h, color: Colors.grey[400]),
          Padding(
            padding: EdgeInsets.only(left: 4.0.w),
            child: AutoSizeText(
              '${pet.views ?? 1} ${AppStrings.views}',
              style: TextStyles.fontSize12(
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _interesteds() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Row(
        children: [
          Icon(Icons.favorite, size: 12.0.h, color: Colors.grey[400]),
          Padding(
            padding: EdgeInsets.only(left: 4.0.w),
            child: AutoSizeText(
              '15 ${pet.kind == FirebaseEnvPath.donate ? '${AppStrings.interesteds}' : '${AppStrings.infos}'}',
              style: TextStyles.fontSize12(
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _cityState({
    required String state,
    required String city,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Row(
        children: [
          Icon(Icons.pin_drop, size: 12.0.h, color: Colors.grey[400]),
          AutoSizeText(
            '$city - $state',
            style: TextStyles.fontSize12(
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
