import 'package:tiutiu/core/utils/formatter.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  Profile(this.user);

  final TiutiuUser user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AutoSizeText(user.displayName!),
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            width: double.infinity,
            height: Get.height / 1.55,
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0.h),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Opacity(
                        opacity: .3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12.0.h),
                            topLeft: Radius.circular(12.0.h),
                          ),
                          child: Container(
                            height: Get.height / 3,
                            width: double.infinity,
                            child: ClipRRect(
                              child: Image.asset(
                                ImageAssets.bones2,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 64.0,
                        left: 64.0,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000.0.h),
                          ),
                          child: ClipOval(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: AssetHandle.getImage(
                                user.avatar,
                                fit: BoxFit.fill,
                              ),
                              radius: 96.0.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: Get.height / 4,
                    margin: EdgeInsets.only(left: 8.0.w, top: 16.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          'Visto por último ${Formatter.getFormattedDate(user.lastLogin!)}',
                        ),
                        Spacer(),
                        AutoSizeText(
                            'Usuário desde ${Formatter.getFormattedDate(user.createdAt!)}'),
                        Spacer(),
                        AutoSizeText('2 Posts'),
                        Spacer(),
                        Divider(),
                        AutoSizeText('Contato'),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ButtonWide(
                                color: AppColors.secondary,
                                text: AppStrings.chat,
                                isToExpand: false,
                                icon: Icons.phone,
                                action: () {},
                              ),
                            ),
                            Expanded(
                              child: ButtonWide(
                                text: AppStrings.whatsapp,
                                color: AppColors.primary,
                                icon: Tiutiu.whatsapp,
                                isToExpand: false,
                                action: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
