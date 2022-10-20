import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/pets/views/announcer_profile.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/utils/math_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

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
    return TiutiuStringExtension(text.trim()).capitalize();
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
    Get.to(() => AnnouncerProfile(user: user));
  }

  static IconData getIconFromPetType(String type) {
    final Map<String, dynamic> petIconType = {
      PetTypeStrings.bird: Tiutiu.twitter_bird,
      PetTypeStrings.exotic: Tiutiu.hamster,
      PetTypeStrings.dog: Tiutiu.dog,
      PetTypeStrings.cat: Tiutiu.cat,
    };

    return petIconType[type];
  }

  static Future<String?> getVideoUrlDownload({
    required String storagePath,
    required dynamic videoPath,
  }) async {
    String? fileDonwloadUrl;

    if (!videoPath.toString().isUrl()) {
      var urldonwload = await uploadPostFile('$storagePath', videoPath);

      fileDonwloadUrl = urldonwload;
    } else {
      fileDonwloadUrl = videoPath;
    }

    return fileDonwloadUrl;
  }

  static Future<List<String?>> getImageListUrlDownload({
    required String storagePathBase,
    required List imagesPathList,
  }) async {
    List<String?> listDonwloadUrl = [];

    for (var imagePath in imagesPathList) {
      if (!imagePath.toString().isUrl()) {
        var imageUrlDonwload = await uploadPostFile(
          '$storagePathBase/image${imagesPathList.indexOf(imagePath)}',
          imagePath,
        );

        listDonwloadUrl.add(imageUrlDonwload);
      } else {
        listDonwloadUrl.add(imagePath);
      }
    }

    return listDonwloadUrl;
  }

  static Future<String?> uploadPostFile(String storagePath, File file) async {
    return await _uploadPostFile(
      storagePath: storagePath,
      file: file,
    );
  }

  static Future<String?> _uploadPostFile({
    required String storagePath,
    required File file,
  }) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    String? fileName = storagePath.split('/').last;
    Reference ref = _storage.ref(storagePath);
    String? fileURL;

    try {
      var uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() {
        debugPrint('File $fileName Successfully Uploaded');
      });

      fileURL = await ref.getDownloadURL();
    } on FirebaseException catch (error) {
      debugPrint(
          'Ocorreu um erro ao fazer upload do arquivo $fileName: $error.');
    }

    return fileURL;
  }
}
