import 'package:tiutiu/features/dennounce/services/dennounce_services.dart';
import 'package:tiutiu/features/dennounce/model/user_dennounce.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

class UserDennounceController extends GetxController {
  final Rx<UserDennounce> _postDennounce = _defaultUserDennounce().obs;
  final RxInt _postDennounceGroupValue = 3.obs;
  final RxBool _showPopup = false.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;

  int get postDennounceGroupValue => _postDennounceGroupValue.value;
  List<String> get dennounceUserMotives => _dennounceUserMotives;
  UserDennounce get postDennounce => _postDennounce.value;
  bool get popupIsVisible => _showPopup.value;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;

  void set postDennounceGroupValue(int value) => _postDennounceGroupValue(value);
  void set isLoading(bool value) => _isLoading(value);
  void set hasError(bool value) => _hasError(value);

  void updateUserDennounce(UserDennounceEnum property, dynamic data) {
    if (property == UserDennounceEnum.dennouncedUser) _postDennounce(postDennounce.copyWith(dennouncedUser: data));
    if (property == UserDennounceEnum.description) _postDennounce(postDennounce.copyWith(description: data));
    if (property == UserDennounceEnum.dennouncer) _postDennounce(postDennounce.copyWith(dennouncer: data));
    if (property == UserDennounceEnum.motive) _postDennounce(postDennounce.copyWith(motive: data));
    if (property == UserDennounceEnum.uid) _postDennounce(postDennounce.copyWith(uid: data));
  }

  void resetForm() {
    _postDennounce(_defaultUserDennounce());
    _postDennounceGroupValue(3);
    _hasError(false);
  }

  void setLoading(bool loadingValue) {
    _isLoading(loadingValue);
  }

  void hidePopup() {
    _showPopup(false);
  }

  void showPopup() {
    _showPopup(true);
  }

  Future<void> submit() async {
    setLoading(true);
    updateUserDennounce(UserDennounceEnum.dennouncer, tiutiuUserController.tiutiuUser);
    updateUserDennounce(UserDennounceEnum.uid, Uuid().v4());

    debugPrint('TiuTiuApp: User Dennounce UID ${postDennounce.uid}');

    DennounceServices().uploadUserDennounceData(postDennounce);
    resetForm();
    setLoading(false);
  }

  static UserDennounce _defaultUserDennounce() {
    return UserDennounce(
      dennouncer: tiutiuUserController.tiutiuUser,
      motive: UserDennounceStrings.other,
    );
  }

  final _dennounceUserMotives = [
    UserDennounceStrings.sexualAppeal,
    UserDennounceStrings.scamTry,
    UserDennounceStrings.other,
  ];
}
