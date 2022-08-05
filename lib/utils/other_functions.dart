import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/core/controllers/location_controller.dart' as provider;
import 'package:tiutiu/screen/announcer_datails.dart';
import 'package:tiutiu/utils/math_functions.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/utils/string_extension.dart';

class OtherFunctions {
  static List<String> distanceCalculate(
      BuildContext context, double petLatitude, double petLongitude) {
    provider.Location currentLoction = Provider.of(context, listen: false);
    String textDistance = '';
    String textTime = '';

    String? distance = MathFunctions.distanceMatrix(
      latX: currentLoction.getLocation.latitude,
      longX: currentLoction.getLocation.longitude,
      latY: petLatitude,
      longY: petLongitude,
    );

    String time = MathFunctions.time(double.parse(distance!));

    if (double.parse(time) > 60) {
      textTime = "$time\ h";
    } else {
      textTime = "${time.split('.').first}\ min";
    }

    if (double.parse(distance) < 1000) {
      textDistance = "${distance.split('.').first}m";
    } else {
      textDistance = (double.parse(distance) / 1000).toStringAsFixed(0);
      textDistance = textDistance.split('.').first + ' Km';
    }

    return [textDistance, textTime];
  }

  static List<Pet> filterResultsByDistancie(BuildContext context,
      List<Pet> petsListResult, String providerDistanceSelected) {
    List<Pet> newPetList = [];
    provider.Location location = Provider.of<provider.Location>(context);

    for (int i = 0; i < petsListResult.length; i++) {
      String? distance = MathFunctions.distanceMatrix(
        latX: location.getLocation.latitude,
        longX: location.getLocation.longitude,
        latY: petsListResult[i].latitude,
        longY: petsListResult[i].longitude,
      );

      String? distancieSelected =
          providerDistanceSelected.split('Km').first.split('Até').last;
      double distanceRefineSelected =
          double.tryParse(distancieSelected) ?? 1000000;

      if (double.parse(distance!) < distanceRefineSelected * 1000) {
        newPetList.add(petsListResult[i]);
      }
    }

    return newPetList;
  }

  static String firstCharacterUpper(String text) {
    return text.trim().capitalize();
  }

  static Future<String>? getAddress(provider.Location location) async {
    // final geocoding = new GoogleMapsGeocoding(apiKey: Constantes.WEB_API_KEY);
    // final result = await geocoding.searchByLocation(location);
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

  static void navigateToAnnouncerDetail(BuildContext context, User user,
      {bool showOnlyChat = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AnnouncerDetails(user, showOnlyChat: showOnlyChat);
        },
      ),
    );
  }
}
