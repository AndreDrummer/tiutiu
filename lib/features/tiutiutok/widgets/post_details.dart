import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 88.0.h,
      left: 8.0.w,
      child: SizedBox(
        width: Get.width * .8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeTexts.autoSizeText16(
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              '${Formatters.cuttedText(post.name!)} | ${(post as Pet).city} - ${StatesAndCities.stateAndCities.getInitialFromStateName(post.state)}',
            ),
            SizedBox(height: 4.0.h),
            AutoSizeTexts.autoSizeText12(
              fontWeight: FontWeight.w400,
              color: AppColors.white,
              '${(post as Pet).breed} - ${(post as Pet).gender} - ${(post as Pet).color}',
            ),
            SizedBox(height: 8.0.h),
            AutoSizeTexts.autoSizeText12(
              fontWeight: FontWeight.w400,
              color: AppColors.white,
              '${Formatters.cuttedText(OtherFunctions.replacePhoneNumberWithStars(post.description), size: 200)}',
            ),
          ],
        ),
      ),
    );
  }
}
