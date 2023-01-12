import 'package:tiutiu/core/models/dynamic_link_parameters.dart';
import 'package:tiutiu/features/posts/views/announcer_profile.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/utils/file_cache_manager.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/location/models/latlng.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiutiu/core/utils/math_functions.dart';
import 'package:tiutiu/features/posts/model/post.dart';
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

  static String replacePhoneNumberWithStars(String description) {
    try {
      String phoneNumber = description;

      if (phoneNumber.contains(RegExp(r"[0-9]"))) {
        phoneNumber = phoneNumber.split(phoneNumber.split(RegExp(r"[0-9]")).first).last;

        String stars = '';
        final starList = List.generate(phoneNumber.length, ((index) => '*'));
        starList.forEach((star) => stars += star);

        description = description.replaceAll(phoneNumber, stars);
      }
    } catch (err) {
      debugPrint('An error occurred when trying remove phone number');
      rethrow;
    }

    return description;
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
        debugPrint('TiuTiuApp: File $fileName Successfully Uploaded');
      });

      fileURL = await ref.getDownloadURL();
    } on FirebaseException catch (error) {
      debugPrint('TiuTiuApp: Ocorreu um erro ao fazer upload do arquivo $fileName: $error.');
      rethrow;
    }

    return fileURL;
  }

  static Future<String?> getPostImageToShare(Post post) async {
    debugPrint('TiuTiuApp: Sharing Post...');
    try {
      String file;
      final sharedFilesMap = await LocalStorage.getValueUnderLocalStorageKey(
        LocalStorageKey.sharedFilesMap,
      );

      debugPrint('TiuTiuApp: Shared Files Map $sharedFilesMap');

      if (sharedFilesMap != null && (sharedFilesMap as Map).containsKey(post.uid)) {
        debugPrint('TiuTiuApp: Shared Files Map was NOT null $sharedFilesMap');
        file = sharedFilesMap[post.uid];
      } else {
        debugPrint('TiuTiuApp: Shared Files Map is null $sharedFilesMap');
        file = await FileCacheManager.save(
          filename: post.name ?? '${post.type}',
          fileUrl: post.photos[0],
          type: FileType.images,
        );

        debugPrint('TiuTiuApp: Post First Image downloaded $file');

        Map<String, dynamic> map = {};
        if (sharedFilesMap != null) map.addAll(sharedFilesMap);

        map.putIfAbsent(post.uid!, () => file);
        debugPrint('TiuTiuApp: Post First Image will be cached $map');

        await LocalStorage.setValueUnderLocalStorageKey(
          key: LocalStorageKey.sharedFilesMap,
          value: map,
        );

        debugPrint('TiuTiuApp: Post First Image cached $map');
      }

      return file;
    } catch (exception) {
      debugPrint('TiuTiuApp: An error occured when trying get post image to share: $exception.');
      rethrow;
    }
  }

  static Future<String> getPostTextToShare({required TiuTiuDynamicLinkParameters tiuTiuDynamicLinkParameters}) async {
    String postTitle = tiuTiuDynamicLinkParameters.postTitle;
    int ageMonth = tiuTiuDynamicLinkParameters.ageMonth;
    String gender = tiuTiuDynamicLinkParameters.gender;
    int ageYear = tiuTiuDynamicLinkParameters.ageYear;
    String color = tiuTiuDynamicLinkParameters.color;
    String type = tiuTiuDynamicLinkParameters.type;
    String size = tiuTiuDynamicLinkParameters.size;

    bool showNewBornText = ageYear == 0 && ageMonth == 0;

    String age = showNewBornText
        ? 'Recém Nascido'
        : ageYear <= 0
            ? '$ageMonth meses'
            : '$ageYear anos';

    String typeIcon = type == PetTypeStrings.cat
        ? '🐈'
        : type == PetTypeStrings.dog
            ? '🐶'
            : type == PetTypeStrings.bird
                ? '🐧'
                : '';

    debugPrint('TiuTiuApp: DynamicLinkPrefix ${tiuTiuDynamicLinkParameters.dynamicLinkPrefix}');
    debugPrint('TiuTiuApp: AppStoreId ${tiuTiuDynamicLinkParameters.iosParameters.appStoreId}');
    debugPrint('TiuTiuApp: UriPrefix ${tiuTiuDynamicLinkParameters.uriPrefix}');

    final dynamicLinkParams = DynamicLinkParameters(
      androidParameters: tiuTiuDynamicLinkParameters.androidParameters,
      iosParameters: tiuTiuDynamicLinkParameters.iosParameters,
      uriPrefix: tiuTiuDynamicLinkParameters.uriPrefix,
      link: tiuTiuDynamicLinkParameters.link,
    );

    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    String headerText = 'Olha ${_getPetGender(type, gender).trim()}  ${typeIcon.trim()} que eu vi no app *Tiu, tiu*:';

    String bodyText = '*$postTitle*\n⚧️ $gender\n🎂 $age\n📐 $size\n🎨 $color';

    String footerText = 'Tem mais detalhes dele nesse link: ${dynamicLink.shortUrl}.';

    return '$headerText\n\n$bodyText\n\n$footerText';
  }

  static String _getPetGender(String type, String gender) {
    if (gender == PostDetailsStrings.female) {
      if (type == PetTypeStrings.dog) {
        return 'essa cachorra';
      } else if (type == PetTypeStrings.cat) {
        return 'essa gata';
      }
    } else if (gender == PostDetailsStrings.male) {
      if (type == PetTypeStrings.dog) {
        return 'esse cachorro';
      } else if (type == PetTypeStrings.cat) {
        return 'esse gato';
      }
    }

    return 'esse ${type.toLowerCase()}';
  }
}
