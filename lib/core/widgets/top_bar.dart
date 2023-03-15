import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/sponsored/views/sponsored_horizontal_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/features/posts/model/filter_params.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/widgets/input_close_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/warning_widget.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final _fieldController = TextEditingController(text: filterController.getParams.name);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(6.0.w, 6.0.h, 12.0.w, 0.0.h),
          child: Column(
            children: [
              _userGreeting(),
              HighPriorityInfoBanner(),
              Obx(
                () => Visibility(
                  replacement: SponsoredHorizontalList(),
                  visible: filterController.filterParams.value.orderBy == AppLocalizations.of(context).name,
                  child: _userSearchInput(context, _fieldController),
                ),
              ),
              WarningBanner(
                showBannerCondition: !systemController.properties.internetConnected && postsController.posts.isNotEmpty,
                textWarning: AppLocalizations.of(context).noConnectionWarning,
                padding: EdgeInsets.all(2.0.h),
                replacement: SizedBox.shrink(),
                tileColor: AppColors.warning,
                textColor: AppColors.black,
                margin: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        Divider(color: Colors.blueGrey)
      ],
    );
  }

  Widget _userSearchInput(BuildContext context, TextEditingController fieldController) {
    return Column(
      children: [
        Divider(),
        TextFormField(
          textInputAction: TextInputAction.search,
          onChanged: (value) {
            filterController.updateParams(
              FilterParamsEnum.name,
              value.trim(),
            );
          },
          controller: fieldController,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxHeight: 32.0.h),
            contentPadding: EdgeInsets.only(left: 8.0.w),
            fillColor: AppColors.primary.withAlpha(20),
            suffixIcon: Visibility(
              visible: filterController.getParams.name.isNotEmpty,
              child: InputCloseButton(
                onClose: () {
                  filterController.clearName();
                  fieldController.clear();
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            hintText: AppLocalizations.of(context).searchForName,
            enabledBorder: _inputBorder(),
            errorBorder: _inputBorder(),
            border: _inputBorder(),
            filled: true,
          ),
        ),
      ],
    );
  }

  Widget _userGreeting() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 4.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AutoSizeTexts.autoSizeText22(_greeting(), textAlign: TextAlign.left),
              SizedBox(width: 4.0.w),
              _greetingIcon(),
              Spacer(),
              InkWell(
                child: Icon(Icons.map),
                onTap: () {
                  Get.toNamed(Routes.changeCountry);
                },
              ),
            ],
          ),
          SizedBox(height: 2.0.h),
          AutoSizeTexts.autoSizeText12(
            '${Formatters.formmatedExtendedDate()}',
            textAlign: TextAlign.left,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  String _greeting() {
    bool isLogged = authController.userExists;
    String? userName = isLogged
        ? tiutiuUserController.tiutiuUser.displayName?.replaceAll(',', ' ').replaceAll('.', ' ').split(' ').first
        : null;

    String greeting = OtherFunctions.getGreetingBasedOnTime(context);

    return '${userName.isNotEmptyNeighterNull() ? greeting + ', $userName' : greeting}' + '!';
  }

  Widget _greetingIcon() {
    final now = DateTime.now();

    if (now.hour < 12) {
      return Icon(FontAwesomeIcons.cloudSun, color: Colors.amberAccent);
    } else if (now.hour < 18) {
      return Icon(FontAwesomeIcons.solidSun, color: Colors.yellow);
    } else {
      return Icon(FontAwesomeIcons.cloudMoon, color: Colors.grey[800]);
    }
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: AppColors.primary,
        width: 1.0.w,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
