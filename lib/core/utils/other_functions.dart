import 'package:tiutiu/features/posts/views/announcer_profile.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/location/models/latlng.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiutiu/core/utils/math_functions.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
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

  static String getPhotoName(String photoUrl) {
    String photoName = photoUrl.split('%2F').last.split('?').first;
    return photoName;
  }

  static void navigateToAnnouncerDetail(TiutiuUser user, {bool popAndPush = false}) {
    if (popAndPush)
      Get.off(() => AnnouncerProfile(user: user));
    else
      Get.to(() => AnnouncerProfile(user: user));
  }

  static IconData getIconFromPetType(String type) {
    final Map<String, dynamic> petIconType = {
      PetTypeStrings.bird: FontAwesomeIcons.b,
      PetTypeStrings.exotic: FontAwesomeIcons.staffSnake,
      PetTypeStrings.dog: FontAwesomeIcons.dog,
      PetTypeStrings.cat: FontAwesomeIcons.cat,
    };

    return petIconType[type];
  }

  static Future<String?> getVideoUrlDownload({
    required String storagePath,
    required dynamic videoPath,
  }) async {
    String? fileDonwloadUrl;

    if (videoPath != null && !videoPath.toString().isUrl()) {
      var urldonwload = await uploadPostFile('$storagePath', videoPath);

      fileDonwloadUrl = urldonwload;
    } else {
      fileDonwloadUrl = videoPath;
    }

    return fileDonwloadUrl;
  }

  static Future<List<String?>> getImageListUrlDownload({
    required String storagePath,
    required List imagesPathList,
  }) async {
    List<String?> listDonwloadUrl = [];

    for (var imagePath in imagesPathList) {
      if (!imagePath.toString().isUrl()) {
        var imageUrlDonwload = await uploadPostFile(
          '$storagePath/${Uuid().v4()}',
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
      debugPrint('Ocorreu um erro ao fazer upload do arquivo $fileName: $error.');
    }

    return fileURL;
  }
}
