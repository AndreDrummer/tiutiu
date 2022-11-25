import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/features/talk_with_us/model/talk_with_us.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TalkWithUsController extends GetxController {
  final Rx<TalkWithUs> _talkWithUs = TalkWithUs().obs;
  final RxBool _insertImages = false.obs;
  final RxString _loadingText = ''.obs;
  final RxBool _isFormValid = true.obs;
  final RxBool _isLoading = false.obs;
  final int maxScreenshots = 3;

  TalkWithUs get talkWithUs => _talkWithUs.value;
  bool get insertImages => _insertImages.value;
  String get loadingText => _loadingText.value;
  bool get isFormValid => _isFormValid.value;
  bool get isLoading => _isLoading.value;

  void set insertImages(bool value) => _insertImages(value);
  void set loadingText(String text) => _loadingText(text);
  void set isLoading(bool value) => _isLoading(value);

  void updateTalkWithUs(TalkWithUsEnum property, dynamic data) {
    final map = talkWithUs.toMap();
    map[property.name] = data;

    debugPrint('>> Updating talk with us data $map');

    _talkWithUs(TalkWithUs.fromMap(map));
  }

  void addPictureOnIndex(dynamic picture, int index) {
    if (index <= maxScreenshots) {
      final talkWithUsMap = talkWithUs.toMap();
      var newImageList = [];

      newImageList.addAll(talkWithUsMap[TalkWithUsEnum.screenshots.name]);
      newImageList.add(picture);

      talkWithUsMap[TalkWithUsEnum.screenshots.name] = newImageList;
      _talkWithUs(TalkWithUs.fromMap(talkWithUsMap));
    }
  }

  void removePictureOnIndex(int index) {
    var talkWithUsMap = talkWithUs.toMap();
    var newImageList = talkWithUsMap[TalkWithUsEnum.screenshots.name];

    newImageList.removeAt(index);

    talkWithUsMap[TalkWithUsEnum.screenshots.name] = newImageList;
    _talkWithUs(TalkWithUs.fromMap(talkWithUsMap));
  }

  void _checkIfformIsValid() {
    final value = talkWithUs.contactSubject.isNotEmptyNeighterNull() &&
        talkWithUs.contactMessage.isNotEmptyNeighterNull() &&
        (insertImages ? talkWithUs.screenshots.isNotEmpty : true);

    _isFormValid(value);
  }

  void setLoading(bool loadingValue, String loadingText) {
    isLoading = loadingValue;
    _loadingText(loadingText);
  }

  Future<void> submitForm() async {
    _checkIfformIsValid();
    if (isFormValid) {
      setLoading(true, TalkWithUsStrings.sendingYourMessage);
      print('Let\'s go!');
      await Future.delayed(Duration(seconds: 2));
      if (!insertImages) updateTalkWithUs(TalkWithUsEnum.screenshots, []);
      setLoading(false, '');
    }
  }
}
