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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const LottieAnimation(animationPath: AnimationsAssets.spinningGlobe, size: 200.0),
                  OneLineText(text: AppLocalizations.of(context).chooseWhereSeePets, fontSize: 24),
                  const SizedBox(height: 16.0),
                  Obx(
                    () => DropdownButton<String>(
                      isExpanded: true,
                      value: systemController.properties.userChoiceCountry,
                      items: ['Brasil', 'Argentina', 'Chile', 'México']
                          .map((String e) => DropdownMenuItem<String>(child: AutoSizeTexts.autoSizeText18(e), value: e))
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
                  Spacer(),
                  ButtonWide(),
                  SizedBox(height: 16.0.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
