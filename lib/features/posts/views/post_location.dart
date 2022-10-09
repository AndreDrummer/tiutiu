import 'package:tiutiu/features/posts/widgets/location_selecter.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => LocationSelecter(
          fillFullAddress: postsController.isFullAddress,
          onFullAddressSelected: (value) {
            postsController.toggleFullAddress();
          },
          initialCity: postsController.pet.city,
          initialState: postsController.pet.state,
          onStateChanged: (state) {
            postsController.updatePet(PetEnum.state, state);
          },
          onCityChanged: (city) {
            postsController.updatePet(PetEnum.city, city);
          },
        ),
      ),
    );
  }
}
