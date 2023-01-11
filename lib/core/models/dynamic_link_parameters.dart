import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

enum TiuTiuDynamicLinkParametersEnum {
  androidParameters,
  dynamicLinkPrefix,
  iosParameters,
  postTitle,
  uriPrefix,
  ageMonth,
  ageYear,
  gender,
  link,
  color,
  type,
  size,
}

class TiuTiuDynamicLinkParameters {
  TiuTiuDynamicLinkParameters({
    required this.androidParameters,
    required this.dynamicLinkPrefix,
    required this.iosParameters,
    required this.postTitle,
    required this.uriPrefix,
    required this.ageMonth,
    required this.ageYear,
    required this.gender,
    required this.link,
    required this.color,
    required this.type,
    required this.size,
  });

  factory TiuTiuDynamicLinkParameters.fromMap(Map<String, dynamic> map) {
    return TiuTiuDynamicLinkParameters(
      androidParameters: map[TiuTiuDynamicLinkParametersEnum.androidParameters.name],
      dynamicLinkPrefix: map[TiuTiuDynamicLinkParametersEnum.dynamicLinkPrefix.name],
      iosParameters: map[TiuTiuDynamicLinkParametersEnum.iosParameters.name],
      postTitle: map[TiuTiuDynamicLinkParametersEnum.postTitle.name],
      uriPrefix: map[TiuTiuDynamicLinkParametersEnum.uriPrefix.name],
      ageMonth: map[TiuTiuDynamicLinkParametersEnum.ageMonth.name],
      ageYear: map[TiuTiuDynamicLinkParametersEnum.ageYear.name],
      gender: map[TiuTiuDynamicLinkParametersEnum.gender.name],
      link: map[TiuTiuDynamicLinkParametersEnum.link.name],
      color: map[TiuTiuDynamicLinkParametersEnum.color.name],
      type: map[TiuTiuDynamicLinkParametersEnum.type.name],
      size: map[TiuTiuDynamicLinkParametersEnum.size.name],
    );
  }

  AndroidParameters androidParameters;
  IOSParameters iosParameters;
  String dynamicLinkPrefix;
  String postTitle;
  String uriPrefix;
  String gender;
  String color;
  int ageMonth;
  String type;
  String size;
  int ageYear;
  Uri link;

  Map<String, dynamic> toMap() {
    return {
      TiuTiuDynamicLinkParametersEnum.androidParameters.name: androidParameters,
      TiuTiuDynamicLinkParametersEnum.dynamicLinkPrefix.name: dynamicLinkPrefix,
      TiuTiuDynamicLinkParametersEnum.iosParameters.name: iosParameters,
      TiuTiuDynamicLinkParametersEnum.postTitle.name: postTitle,
      TiuTiuDynamicLinkParametersEnum.uriPrefix.name: uriPrefix,
      TiuTiuDynamicLinkParametersEnum.ageMonth.name: ageMonth,
      TiuTiuDynamicLinkParametersEnum.ageYear.name: ageYear,
      TiuTiuDynamicLinkParametersEnum.gender.name: gender,
      TiuTiuDynamicLinkParametersEnum.link.name: link,
      TiuTiuDynamicLinkParametersEnum.color.name: color,
      TiuTiuDynamicLinkParametersEnum.type.name: type,
      TiuTiuDynamicLinkParametersEnum.size.name: size,
    };
  }

  @override
  String toString() {
    return '''
        androidParameters: $androidParameters,
        dynamicLinkPrefix: $dynamicLinkPrefix,
        iosParameters: $iosParameters,
        postTitle: $postTitle,
        uriPrefix: $uriPrefix,
        ageMonth: $ageMonth,
        ageYear: $ageYear,
        gender: $gender,
        link: $link,
        color: $color,
        type: $type,
        size: $size
      ''';
  }
}
