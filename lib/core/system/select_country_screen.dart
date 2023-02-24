import 'package:tiutiu/core/system/views/loading_start_screen.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountrySelecter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: AppLocalizations.of(context).selectACountry),
      body: FutureBuilder(
        future: systemController.setUserChoiceCountry(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return LoadingStartScreen();

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const LottieAnimation(animationPath: AnimationsAssets.spinningGlobe, size: 200.0),
                  OneLineText(text: AppLocalizations.of(context).chooseWhereSeePets, fontSize: 24),
                  const SizedBox(height: 16.0),
                  Obx(
                    () => DropdownButton<String>(
                      isExpanded: true,
                      value: systemController.properties.userChoiceCountry,
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
                        await LocalStorage.setValueUnderLocalStorageKey(
                          key: LocalStorageKey.userChoiceCountry,
                          value: country,
                        );

                        systemController.setUserChoiceCountry();
                      },
                    ),
                  ),
                  _selectRadius(context),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 16.0.h),
        child: ButtonWide(),
      ),
    );
  }

  Widget _selectRadius(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: systemController.properties.userChoiceCountry != 'brazil',
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
                      await LocalStorage.setValueUnderLocalStorageKey(
                        key: LocalStorageKey.userChoiceRadiusDistanceToShowPets,
                        value: radius,
                      );

                      systemController.setUserChoiceRadiusDistanceToShowPets();
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
