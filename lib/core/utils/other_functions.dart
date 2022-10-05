import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiutiu/features/profile/views/profile.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/utils/math_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherFunctions {
  static List<String> distanceCalculate(
    double petLatitude,
    double petLongitude,
  ) {
    LatLng currentLoction = currentLocationController.location;
    String textDistance = '';
    String textTime = '';

    double distance = MathFunctions.distanceMatrix(
      longX: currentLoction.longitude,
      latX: currentLoction.latitude,
      longY: petLongitude,
      latY: petLatitude,
    );

    String time = MathFunctions.time(distance);

    if (double.parse(time) > 60) {
      textTime = "$time\ h";
    } else {
      textTime = "${time.split('.').first}\ min";
    }

    if (distance < 1000) {
      textDistance = "${distance.toStringAsFixed(2)} m";
    } else {
      textDistance = (distance / 1000).toStringAsFixed(0);
      textDistance = textDistance.split('.').first + ' km';
    }

    return [textDistance, textTime];
  }

  static String firstCharacterUpper(String text) {
    return text.trim().capitalize!;
  }

  // static Future<String>? getAddress(provider.Location location) async {
  static Future<String>? getAddress(LatLng position) async {
    final result = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    print(result);
    // GeocodingModel local = GeocodingModel.fromSnapshot(result.results.first);
    // return local.formattedAddress;
    return '';
  }

  static Future<List<Pet>> filterResultsByState(
      List<Pet> petsListResult, String stateName) async {
    List<Pet> newPetList = [];

    for (int i = 0; i < petsListResult.length; i++) {
      // List<Address> addresses = await Geocoder.local
      //     .findAddressesFromCoordinates(Coordinates(
      //         petsListResult[i].latitude, petsListResult[i].longitude));
      // if (addresses.first.adminArea == stateName) {
      //   newPetList.add(petsListResult[i]);
      // }
    }

    return newPetList;
  }

  static Future<String> getUserLocalState(LatLng local) async {
    // List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(
    //     Coordinates(local.latitude, local.longitude));

    // return addresses.first.adminArea;
    return '';
  }

  static String getPhotoName(String photoUrl, String hasKey) {
    String photoName =
        photoUrl.split(hasKey).last.split('?').first.split('%2F').last;
    return photoName;
  }

  static Future<DocumentReference> getReferenceById(
      String id, String collectionName) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
        await firebaseFirestore.collection(collectionName).doc('$id').get();
    return documentSnapshot.reference;
  }

  static void navigateToAnnouncerDetail(TiutiuUser user) {
    profileController.profileUser = user;
    Get.to(() => Profile());
  }

  static IconData getIconFromPetType(String type) {
    final Map<String, dynamic> petIconType = {
      FilterStrings.bird: Tiutiu.twitter_bird,
      FilterStrings.exotic: Tiutiu.hamster,
      FilterStrings.dog: Tiutiu.dog,
      FilterStrings.cat: Tiutiu.cat,
    };

    return petIconType[type];
  }
}
