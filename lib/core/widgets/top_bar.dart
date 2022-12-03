import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/core/widgets/toggle_posts_card_appearence.dart';
import 'package:tiutiu/core/widgets/input_close_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/warning_widget.dart';
import 'package:tiutiu/features/posts/model/filter_params.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/widgets/badge.dart';
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
      padding: EdgeInsets.fromLTRB(9.5.w, 4.0.h, 8.0.w, 0.0.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(
                  () {
                    return TextFormField(
                      textInputAction: TextInputAction.search,
                      onChanged: (value) {
                        filterController.updateParams(
                          FilterParamsEnum.name,
                          value,
                        );
                      },
                      controller: _fieldController,
                      decoration: InputDecoration(
                        constraints: BoxConstraints(maxHeight: 32.0.h),
                        contentPadding: EdgeInsets.only(left: 8.0.w),
                        fillColor: AppColors.secondary.withAlpha(20),
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
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Visibility(
                    visible: authController.userExists,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Get.toNamed(Routes.contacts);
                      },
                      icon: Icon(
                        Icons.forum,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: authController.userExists,
                    child: Stack(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.secondary,
                          ),
                        ),
                        Positioned(
                          right: 11.0.w,
                          top: 8.0.w,
                          child: Badge(
                            show: true,
                            color: AppColors.info,
                            text: 0,
                          ),
                        )
                      ],
                    ),
                  ),
                  TogglePostCardAppearence()
                ],
              ),
            ],
          ),
          WarningBanner(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
            showBannerCondition: systemController.internetConnected,
            textWarning: AppStrings.noConnectionWarning,
            tileColor: AppColors.warning,
            textColor: AppColors.black,
            margin: EdgeInsets.only(
              right: Dimensions.getDimensBasedOnDeviceHeight(
                greaterDeviceHeightDouble: 0.0.w,
                minDeviceHeightDouble: 4.0.w,
              ),
              left: 0.0.h,
              top: 0.0.h,
            ),
            child: SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: AppColors.secondary,
        width: 1.0.w,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
