import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/input_close_button.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final _fieldController = TextEditingController(
      text: filterController.filterByName,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(6.0.w, 8.0.h, 8.0.w, 0.0.h),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () {
                return TextFormField(
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    filterController.filterByName = value;
                  },
                  controller: _fieldController,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(maxHeight: 32.0.h),
                    contentPadding: EdgeInsets.only(left: 8.0.w),
                    fillColor: AppColors.secondary.withAlpha(20),
                    suffixIcon: Visibility(
                      visible: filterController.filterByName.isNotEmpty,
                      child: InputCloseButton(
                        onClose: () {
                          filterController.clearName();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    hintStyle: TextStyles.fontSize12(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
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
          Padding(
            padding: EdgeInsets.only(top: 8.0.h),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.comments,
                    color: AppColors.secondary,
                    size: 16.0.h,
                  ),
                ),
                Stack(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: Icon(
                        color: AppColors.secondary,
                        FontAwesomeIcons.bell,
                        size: 16.0.h,
                      ),
                    ),
                    Positioned(
                      right: 8.0.w,
                      child: Badge(
                        color: AppColors.info,
                        text: 0,
                      ),
                    )
                  ],
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    homeController.changeCardVisibilityKind();
                  },
                  icon: Obx(
                    () => Icon(
                      color: AppColors.secondary,
                      homeController.cardVisibilityKind ==
                              CardVisibilityKind.card
                          ? FontAwesomeIcons.list
                          : FontAwesomeIcons.tableCells,
                      size: 16.0.h,
                    ),
                  ),
                )
              ],
            ),
          ),
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
