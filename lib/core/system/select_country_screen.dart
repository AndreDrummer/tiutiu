import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/system/model/system.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountrySelecter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: AppLocalizations.of(context).selectACountry),
      body: FutureBuilder(
        future: systemController.getUserChoiceCountry(),
        builder: (context, _) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                LottieAnimation(animationPath: AnimationsAssets.spinningGlobe, size: 200.0.h),
                OneLineText(text: AppLocalizations.of(context).chooseWhereSeePets, fontSize: 24),
                const SizedBox(height: 16.0),
                _countrySelectDropdown(),
                _selectRadius(context),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 16.0.h),
        child: ButtonWide(
          text: AppLocalizations.of(context).ok,
          onPressed: () async {
            Get.back();
            filterController.reset();
            await systemController.saveUserChosenCountryOption();
            Get.offAllNamed(Routes.authOrHome);
          },
        ),
      ),
    );
  }

  Widget _countrySelectDropdown() {
    return Obx(
      () => Column(
        children: [
          DropdownButton<String>(
            underline: Container(
              color: AppColors.black.withOpacity(.5),
              width: Get.width,
              height: 0.5.h,
            ),
            isExpanded: true,
            value: systemController.properties.userCountryChoice ?? defaultCountry,
            items: DummyData.countrieNames.entries
                .toList()
                .map(
                  (MapEntry<String, String> e) => DropdownMenuItem<String>(
                    child: AutoSizeTexts.autoSizeText18(e.value),
                    value: e.key,
                  ),
                )
                .toList(),
            onChanged: (country) async {
              systemController.updateUserChoiceRadiusDistanceToShowPets(radius: 10);
              systemController.setUserChoiceCountry(country: country!);
            },
          ),
        ],
      ),
    );
  }

  Widget _selectRadius(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: systemController.properties.userCountryChoice != defaultCountry &&
            systemController.properties.userCountryChoice.isNotEmptyNeighterNull(),
        child: Column(
          children: [
            SizedBox(height: 40.0.h),
            OneLineText(text: AppLocalizations.of(context).setARadiusToSearchPets, fontSize: 24),
            SizedBox(height: 8.0.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Slider(
                    onChanged: (radius) async {
                      systemController.updateUserChoiceRadiusDistanceToShowPets(radius: radius);
                    },
                    value: systemController.properties.userChoiceRadiusDistanceToShowPets,
                    max: 500,
                    min: 0,
                  ),
                ),
                OneLineText(
                  text: systemController.properties.userChoiceRadiusDistanceToShowPets.toStringAsFixed(0) + ' km',
                  fontSize: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
