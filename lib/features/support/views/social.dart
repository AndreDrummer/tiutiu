import 'package:tiutiu/core/widgets/play_store_rating.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowUs extends StatelessWidget {
  const FollowUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: Get.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetHandle.imageProvider(ImageAssets.follow),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Spacer(),
            RatingUs(),
          ],
        ),
      ),
    );
  }
}
