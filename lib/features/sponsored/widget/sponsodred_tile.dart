import 'package:tiutiu/features/sponsored/model/sponsored.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SponsoredTile extends StatelessWidget {
  const SponsoredTile({super.key, required this.sponsored, this.radius});

  final Sponsored sponsored;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Launcher.openBrowser(sponsored.link!);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 8.0.h)),
        child: Container(
          height: Dimensions.getDimensBasedOnDeviceHeight(
            smaller: 80.0.h,
            bigger: 68.0.h,
            medium: 68.0.h,
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius ?? 8.0.h)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 8.0.h),
            child: AssetHandle.getImage(sponsored.imagePath),
          ),
          alignment: Alignment.center,
          width: Get.width,
        ),
        margin: EdgeInsets.only(top: 4.0.h),
      ),
    );
  }
}
