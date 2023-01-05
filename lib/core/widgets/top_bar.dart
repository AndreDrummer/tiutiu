import 'package:tiutiu/features/posts/model/filter_params.dart';
import 'package:tiutiu/core/widgets/input_close_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/warning_widget.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final _fieldController = TextEditingController(
      text: filterController.getParams.name,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(6.0.w, 6.0.h, 12.0.w, 4.0.h),
      child: Column(
        children: [
          Obx(
            () => Visibility(
              replacement: _userGreeting(),
              visible: filterController.filterParams.value.orderBy == FilterStrings.name,
              child: TextFormField(
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  filterController.updateParams(
                    FilterParamsEnum.name,
                    value.trim(),
                  );
                },
                controller: _fieldController,
                decoration: InputDecoration(
                  constraints: BoxConstraints(maxHeight: 32.0.h),
                  contentPadding: EdgeInsets.only(left: 8.0.w),
                  fillColor: AppColors.primary.withAlpha(20),
                  suffixIcon: Visibility(
                    visible: filterController.getParams.name.isNotEmpty,
                    child: InputCloseButton(
                      onClose: () {
                        filterController.clearName();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  hintText: HomeStrings.searchForName,
                  enabledBorder: _inputBorder(),
                  errorBorder: _inputBorder(),
                  border: _inputBorder(),
                  filled: true,
                ),
              ),
            ),
          ),
          WarningBanner(
            showBannerCondition:
                appController.properties.internetConnected && !tiutiuUserController.tiutiuUser.emailVerified,
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
            margin: EdgeInsets.only(top: 8.0.h),
            replacement: SizedBox.shrink(),
          ),
          WarningBanner(
            showBannerCondition: !appController.properties.internetConnected && postsController.posts.isNotEmpty,
            textWarning: AppStrings.noConnectionWarning,
            margin: EdgeInsets.only(top: 8.0.h),
            padding: EdgeInsets.all(2.0.h),
            replacement: SizedBox.shrink(),
            tileColor: AppColors.warning,
            textColor: AppColors.black,
          )
        ],
      ),
    );
  }

  Widget _userGreeting() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 4.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeTexts.autoSizeText22(_greeting(), textAlign: TextAlign.left),
              SizedBox(width: 4.0.w),
              _greetingIcon(),
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
    String userName = tiutiuUserController.tiutiuUser.displayName!.split(' ').first;
    final now = DateTime.now();
    String greeting = '';

    if (now.hour < 12) {
      greeting = GreetingStrings.goodMonring;
    } else if (now.hour < 18) {
      greeting = GreetingStrings.goodAfternoon;
    } else {
      greeting = GreetingStrings.goodNight;
    }

    return '$greeting, ' + userName + '!';
  }

  Widget _greetingIcon() {
    final now = DateTime.now();

    if (now.hour < 12) {
      return Transform.rotate(angle: 12, child: Icon(Icons.wb_sunny_rounded, color: Colors.amber));
    } else if (now.hour < 18) {
      return Transform.rotate(angle: 12, child: Icon(Icons.wb_sunny_sharp, color: Colors.amberAccent));
    } else {
      return Transform.rotate(angle: 12, child: Icon(Icons.nightlight_round_outlined, color: Colors.grey[700]));
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
