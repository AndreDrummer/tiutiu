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
      height: 172.0.h + pet.name!.length,
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
              margin: EdgeInsets.only(left: 4.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7.0.h),
                            child: cardBuilder.adTitle(),
                          ),
                          cardBuilder.adDescription(),
                        ],
                      ),
                      cardBuilder.favoriteButton(),
                    ],
                  ),
                  Spacer(),
                  cardBuilder.adDistanceFromUser(),
                  cardBuilder.adViews(),
                  cardBuilder.adInteresteds(),
                  cardBuilder.adPostedAt(),
                  Spacer(),
                  cardBuilder.divider(),
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
