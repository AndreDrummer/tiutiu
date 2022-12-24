import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyListScreen extends StatelessWidget {
  EmptyListScreen({
    this.showClearFiltersButton = true,
    this.isAPetScreenList = true,
    this.text,
  });

  final bool showClearFiltersButton;
  final bool isAPetScreenList;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          child: Container(
            child: Image.asset(ImageAssets.notFoundET),
            height: Get.width / 2,
          ),
          visible: isAPetScreenList,
        ),
        AutoSizeTexts.autoSizeText12(text ?? AppStrings.noPostFound),
        Visibility(
          visible: showClearFiltersButton,
          child: SimpleTextButton(
            text: AppStrings.cleanFilters,
            textColor: Colors.lightBlue,
            fontSize: 12,
            onPressed: () {
              filterController.reset();
              if (homeController.bottomBarIndex <= 1) {
                homeController.setDonateIndex();
              }
            },
          ),
        ),
      ],
    );
  }
}
