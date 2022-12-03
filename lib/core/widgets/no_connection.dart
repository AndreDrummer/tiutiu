import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 3),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(ImageAssets.noConnection), fit: BoxFit.fitHeight),
            ),
          ),
          Positioned(
            child: SimpleTextButton(
              text: AppStrings.backToCivilization,
              onPressed: () => Get.back(),
            ),
            bottom: Get.width / 2,
            right: 0,
            left: 0,
          ),
        ],
      ),
    );
  }
}
