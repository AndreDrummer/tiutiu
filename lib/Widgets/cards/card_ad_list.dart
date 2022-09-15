import 'package:tiutiu/Widgets/cards/widgets/card_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/utils/formatter.dart';
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
      height: 128.0.h,
      padding: EdgeInsets.zero,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.h),
        ),
        elevation: 8.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.0.h),
                  topLeft: Radius.circular(12.0.h),
                ),
              ),
              child: AssetHandle.getImage(pet.photos!.first),
              width: Get.width * .4,
            ),
            Container(
              margin: EdgeInsets.only(left: 4.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 7.0.h),
                    height: 16.0.h,
                    child: AutoSizeText(
                      pet.name!,
                      textAlign: TextAlign.left,
                      style: TextStyles.fontSize20(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0.h,
                    width: 200.0.w,
                    child: AutoSizeText(
                      pet.breed!,
                      textAlign: TextAlign.left,
                      style: TextStyles.fontSize12(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.eye,
                        size: 10.0.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 2.0.h,
                          left: 4.0.w,
                        ),
                        child: AutoSizeText(
                          '${pet.views} ${AppStrings.views}',
                          textAlign: TextAlign.left,
                          style: TextStyles.fontSize10(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0.h),
                    child: SizedBox(
                      height: 16.0.h,
                      width: 200.0.w,
                      child: AutoSizeText(
                        '${AppStrings.postedAt} ${Formatter.getFormattedDate(pet.createdAt!)}',
                        textAlign: TextAlign.left,
                        style: TextStyles.fontSize10(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 8.0.h),
                  SizedBox(
                    height: 16.0.h,
                    child: AutoSizeText(
                      '${pet.city} - ${pet.state}',
                      textAlign: TextAlign.left,
                      style: TextStyles.fontSize10(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
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
