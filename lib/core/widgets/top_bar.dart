import 'package:tiutiu/features/posts/model/filter_params.dart';
import 'package:tiutiu/core/widgets/input_close_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/warning_widget.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
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
                    );
                  },
                ),
              ),
            ],
          ),
          WarningBanner(
            showBannerCondition:
                appController.properties.internetConnected && !tiutiuUserController.tiutiuUser.emailVerified,
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
            margin: EdgeInsets.only(top: 8.0.h),
            replacement: SizedBox.shrink(),
          ),
          WarningBanner(
            showBannerCondition: !appController.properties.internetConnected && postsController.posts.isNotEmpty,
            textWarning: AppStrings.noConnectionWarning,
            padding: EdgeInsets.all(2.0.h),
            replacement: SizedBox.shrink(),
            tileColor: AppColors.warning,
            textColor: AppColors.black,
            margin: EdgeInsets.zero,
          )
        ],
      ),
    );
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
