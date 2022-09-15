import 'package:tiutiu/Widgets/cards/widgets/card_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardAdList extends StatelessWidget {
  const CardAdList({
    required this.pet,
  });

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    List<String> distanceText = OtherFunctions.distanceCalculate(
      context,
      pet.latitude!,
      pet.longitude!,
    );

    CardBuilder cardBuilder = CardBuilder(
      distanceText: distanceText[0],
      pet: pet,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0.h),
      ),
      height: 168.0.h + pet.name!.length,
      padding: EdgeInsets.zero,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.h),
        ),
        elevation: 8.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cardBuilder.adImages(),
            Container(
              width: Get.width * .55,
              margin: EdgeInsets.only(left: 4.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 7.0.h),
                    child: Row(
                      children: [
                        cardBuilder.adTitle(),
                        Spacer(),
                        cardBuilder.favoriteButton()
                      ],
                    ),
                  ),
                  cardBuilder.adDescription(),
                  cardBuilder.adViews(),
                  cardBuilder.adPostedAt(),
                  Divider(height: 8.0.h),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0.h),
                    child: cardBuilder.adCityState(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
