import 'package:tiutiu/features/posts/widgets/location_selecter.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/post.dart';

class PetLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => LocationSelecter(
          fillFullAddress: postsController.isFullAddress,
          onFullAddressSelected: (value) {
            postsController.toggleFullAddress();
          },
          initialCity: postsController.post.city,
          initialState: postsController.post.uf,
          onStateChanged: (uf) {
            postsController.updatePost(PostEnum.uf, uf);
          },
          onCityChanged: (city) {
            postsController.updatePost(PostEnum.city, city);
          },
        ),
      ),
    );
  }
}
