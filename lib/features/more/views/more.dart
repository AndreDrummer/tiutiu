import 'package:tiutiu/features/auth/views/authenticated_area.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/widgets/custom_list_tile.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

late TiutiuUser _user;

class More extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _user = tiutiuUserController.tiutiuUser;

    return AuthenticatedArea(
      child: SafeArea(
        child: Scaffold(
          body: _cardContent(context),
        ),
      ),
    );
  }

  Widget _cardContent(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0.h)),
      ),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          _cardHeader(),
          _cardBody(),
        ],
      ),
    );
  }

  Widget _cardHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.0.h),
          topLeft: Radius.circular(8.0.h),
        ),
      ),
      height: 56.0.h,
      child: Stack(
        children: [
          _backgroundImage(),
          Positioned(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _roundedPicture(),
                SizedBox(width: 8.0.w),
                _userName(),
              ],
            ),
            bottom: 8.0.h,
            left: 8.0,
          ),
        ],
      ),
    );
  }

  Widget _roundedPicture() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.editProfile);
      },
      child: Container(
        child: ClipOval(
          child: CircleAvatar(
            child: AssetHandle.getImage(_user.avatar, isUserImage: true),
          ),
        ),
        alignment: Alignment.center,
      ),
    );
  }

  Opacity _backgroundImage() {
    return Opacity(
      opacity: .3,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.0.h),
          topLeft: Radius.circular(8.0.h),
        ),
        child: Container(
          height: Get.width / 3,
          width: double.infinity,
          child: ClipRRect(
            child: Image.asset(
              ImageAssets.bones2,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }

  Widget _userName() {
    return Container(
      width: 200.0.w,
      child: Obx(
        () => AutoSizeTexts.autoSizeText14(
          Formatters.cuttedText('${tiutiuUserController.tiutiuUser.displayName}', size: 32),
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _cardBody() {
    final myProfileOptionsTile = moreController.myProfileOptionsTile;

    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      height: Dimensions.getDimensBasedOnDeviceHeight(
        xSmaller: Get.height / 1.45,
        smaller: Get.height / 1.35,
        bigger: Get.height,
        medium: Get.height,
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: myProfileOptionsTile.length,
        itemBuilder: (context, index) {
          final title = myProfileOptionsTile.elementAt(index);
          final lastIndex = index == myProfileOptionsTile.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: lastIndex ? 1.0.h : 0.0.h),
            child: CustomListTile(
              icon: moreController.myProfileOptionsIcon.elementAt(index),
              isToCenterText: false,
              isToExpand: true,
              onTap: () {
                moreController.handleOptionHitted(context, title);
              },
              text: title,
            ),
          );
        },
      ),
    );
  }
}
