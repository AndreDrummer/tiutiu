import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/features/full_screen/views/fullscreen_images.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/pets/services/pet_service.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/chat/common/functions.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/circle_child.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:tiutiu/Widgets/divider.dart';
import 'package:flutter/material.dart';

class AnnouncerDetails extends StatelessWidget {
  AnnouncerDetails(
    this.user, {
    this.showOnlyChat = false,
  });

  final TiutiuUser user;
  final bool showOnlyChat;

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
                          'Visto por último 09 de Janeiro de 2022',
                        ),
                        Spacer(),
                        AutoSizeText('Usuário desde 09 de Janeiro de 2022'),
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
