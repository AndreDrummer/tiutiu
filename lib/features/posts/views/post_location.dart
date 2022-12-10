import 'package:tiutiu/features/posts/widgets/location_selecter.dart';
import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LocationSelecter(
        fillFullAddress: postsController.isFullAddress,
        onFullAddressSelected: (value) {
          postsController.toggleFullAddress();
        },
        initialState: postsController.post.state,
        initialCity: postsController.post.city,
        onStateChanged: (state) {
          postsController.updatePost(PostEnum.state.name, state);
          postsController.updatePost(
            PostEnum.city.name,
            StatesAndCities.stateAndCities.citiesOf(stateName: postsController.post.state).first,
          );
        },
        onCityChanged: (city) {
          postsController.updatePost(PostEnum.city.name, city);
        },
      ),
    );
  }
}
