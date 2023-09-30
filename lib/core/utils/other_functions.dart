import 'package:tiutiu/features/posts/views/announcer_profile.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/models/dynamic_link_parameters.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/utils/file_cache_manager.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/location/models/latlng.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiutiu/core/utils/math_functions.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/foundation.dart';
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
    final anyNumberRegex = RegExp('[0-9]+');

    final list = description.split(' ').map((word) {
      if (anyNumberRegex.hasMatch(word) && word.length > 3) {
        String stars = '';
        for (int i = 0; i < word.length; i++) {
          stars += '*';
        }
        return stars;
      }
      return word;
    }).toList();

    String output = '';

    for (int i = 0; i < list.length; i++) {
      output += '${list[i]} ';
    }
    return output;
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

  static IconData getIconFromPetType(BuildContext context, String type) {
    final Map<String, dynamic> petIconType = {
      AppLocalizations.of(context)!.bird: FontAwesomeIcons.b,
      AppLocalizations.of(context)!.other: FontAwesomeIcons.question,
      AppLocalizations.of(context)!.dog: FontAwesomeIcons.dog,
      AppLocalizations.of(context)!.cat: FontAwesomeIcons.cat,
    };

    return petIconType.containsKey(type) ? petIconType[type] : FontAwesomeIcons.dog;
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
        if (kDebugMode) debugPrint('TiuTiuApp: File $fileName Successfully Uploaded');
      });

      fileURL = await ref.getDownloadURL();
    } on FirebaseException catch (error) {
      if (kDebugMode) debugPrint('TiuTiuApp: Ocorreu um erro ao fazer upload do arquivo $fileName: $error.');
      rethrow;
    }

    return fileURL;
  }

  static Future<String?> getPostImageToShare(Post post) async {
    if (kDebugMode) debugPrint('TiuTiuApp: Sharing Post...');
    try {
      String file;
      final sharedFilesMap = await LocalStorage.getValueUnderLocalStorageKey(
        LocalStorageKey.sharedFilesMap,
      );

      if (kDebugMode) debugPrint('TiuTiuApp: Shared Files Map $sharedFilesMap');

      if (sharedFilesMap != null && (sharedFilesMap as Map).containsKey(post.uid)) {
        if (kDebugMode) debugPrint('TiuTiuApp: Shared Files Map was NOT null $sharedFilesMap');
        file = sharedFilesMap[post.uid];
      } else {
        if (kDebugMode) debugPrint('TiuTiuApp: Shared Files Map is null $sharedFilesMap');
        file = await FileDownloader.save(
          filename: post.name ?? '${post.type}',
          fileUrl: post.photos[0],
          type: FileType.images,
        );

        if (kDebugMode) debugPrint('TiuTiuApp: Post First Image downloaded $file');

        Map<String, dynamic> map = {};
        if (sharedFilesMap != null) map.addAll(sharedFilesMap);

        map.putIfAbsent(post.uid!, () => file);
        if (kDebugMode) debugPrint('TiuTiuApp: Post First Image will be cached $map');

        await LocalStorage.setValueUnderLocalStorageKey(
          key: LocalStorageKey.sharedFilesMap,
          value: map,
        );

        if (kDebugMode) debugPrint('TiuTiuApp: Post First Image cached $map');
      }

      return file;
    } catch (exception) {
      if (kDebugMode) debugPrint('TiuTiuApp: An error occured when trying get post image to share: $exception.');
      rethrow;
    }
  }

  static Future<String> getPostTextToShare({
    required TiuTiuDynamicLinkParameters tiuTiuDynamicLinkParameters,
    required BuildContext context,
  }) async {
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

    String typeIcon = _getPetTypeIcon(context, type);

    if (kDebugMode) debugPrint('TiuTiuApp: DynamicLinkPrefix ${tiuTiuDynamicLinkParameters.dynamicLinkPrefix}');
    if (kDebugMode) debugPrint('TiuTiuApp: AppStoreId ${tiuTiuDynamicLinkParameters.iosParameters.appStoreId}');
    if (kDebugMode) debugPrint('TiuTiuApp: UriPrefix ${tiuTiuDynamicLinkParameters.uriPrefix}');

    final dynamicLinkParams = DynamicLinkParameters(
      androidParameters: tiuTiuDynamicLinkParameters.androidParameters,
      iosParameters: tiuTiuDynamicLinkParameters.iosParameters,
      uriPrefix: tiuTiuDynamicLinkParameters.uriPrefix,
      link: tiuTiuDynamicLinkParameters.link,
    );

    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    String headerText =
        'Olha ${_getPetGender(context, type, gender).trim()}  ${typeIcon.trim()} que eu vi no app *Tiu, tiu*:';

    String bodyText = '*$postTitle*\n⚧️ $gender\n🎂 $age\n📐 $size\n🎨 $color';

    String footerText = 'Tem mais detalhes dele nesse link: ${dynamicLink.shortUrl}.';

    return '$headerText\n\n$bodyText\n\n$footerText';
  }

  static String _getPetGender(BuildContext context, String type, String gender) {
    if (gender == AppLocalizations.of(context)!.female) {
      if (type == AppLocalizations.of(context)!.dog) {
        return 'essa cachorra';
      } else if (type == AppLocalizations.of(context)!.cat) {
        return 'essa gata';
      }
    } else if (gender == AppLocalizations.of(context)!.male) {
      if (type == AppLocalizations.of(context)!.dog) {
        return 'esse cachorro';
      } else if (type == AppLocalizations.of(context)!.cat) {
        return 'esse gato';
      }
    }

    return 'esse pet';
  }

  static String _getPetTypeIcon(BuildContext context, String type) {
    return type == AppLocalizations.of(context)!.cat
        ? '🐈'
        : type == AppLocalizations.of(context)!.dog
            ? '🐶'
            : type == AppLocalizations.of(context)!.bird
                ? '🐧'
                : '';
  }

  static String getGreetingBasedOnTime(BuildContext context) {
    final now = DateTime.now();
    String greeting = '';

    if (now.hour < 12) {
      greeting = AppLocalizations.of(context)!.goodMorning;
    } else if (now.hour < 18) {
      greeting = AppLocalizations.of(context)!.goodAfternoon;
    } else {
      greeting = AppLocalizations.of(context)!.goodNight;
    }

    return greeting;
  }

  static String getWhatsAppInitialMessage(BuildContext context, Post post) {
    String petType = (post as Pet).type;
    String greeting = 'Olá, ${getGreetingBasedOnTime(context).toLowerCase()}! Tudo bem?\n\n';
    String message =
        'Eu gostaria de ter mais informações sobre ${post.name}, ${_getPetGender(context, petType, post.gender)} ${_getPetTypeIcon(context, petType)} que você postou no app *Tiu, tiu*!';
    return '$greeting$message';
  }

  static bool isSmallerThan(String version1, String version2) {
    if (kDebugMode) debugPrint('TiuTiuApp: Is to close app? v1: $version1 <--> v2: $version2');

    final int v1Major = int.tryParse(version1.split('.').first) ?? 0;
    final int v1Minor = int.tryParse(version1.split('.')[1]) ?? 0;
    final int v1Patch = int.tryParse(version1.split('.').last) ?? 0;

    final int v2Major = int.tryParse(version2.split('.').first) ?? 0;
    final int v2Minor = int.tryParse(version2.split('.')[1]) ?? 0;
    final int v2Patch = int.tryParse(version2.split('.').last) ?? 0;

    if (v1Major < v2Major) return true;
    if (v1Minor < v2Minor) return true;
    if (v1Patch < v2Patch) return true;

    return false;
  }
}
