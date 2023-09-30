import 'package:tiutiu/features/dennounce/services/dennounce_services.dart';
import 'package:tiutiu/features/dennounce/model/user_dennounce.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

class UserDennounceController extends GetxController {
  UserDennounceController({required DennounceServices dennounceServices}) : _dennounceServices = dennounceServices;

  final DennounceServices _dennounceServices;

  final Rx<UserDennounce> _userDennounce = _defaultUserDennounce().obs;
  final RxInt _userDennounceGroupValue = 2.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;

  int get userDennounceGroupValue => _userDennounceGroupValue.value;
  List get dennounceUserMotives => _dennounceUserMotives;
  UserDennounce get userDennounce => _userDennounce.value;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;

  void set userDennounceGroupValue(int value) => _userDennounceGroupValue(value);
  void set isLoading(bool value) => _isLoading(value);
  void set hasError(bool value) => _hasError(value);

  void updateUserDennounce(UserDennounceEnum property, dynamic data) {
    if (property == UserDennounceEnum.dennouncedUser) _userDennounce(userDennounce.copyWith(dennouncedUser: data));
    if (property == UserDennounceEnum.description) _userDennounce(userDennounce.copyWith(description: data));
    if (property == UserDennounceEnum.dennouncer) _userDennounce(userDennounce.copyWith(dennouncer: data));
    if (property == UserDennounceEnum.motive) _userDennounce(userDennounce.copyWith(motive: data));
    if (property == UserDennounceEnum.uid) _userDennounce(userDennounce.copyWith(uid: data));
  }

  void resetForm() {
    _userDennounce(_defaultUserDennounce());
    _userDennounceGroupValue(2);
    _hasError(false);
  }

  void setLoading(bool loadingValue) {
    _isLoading(loadingValue);
  }

  Future<void> submit() async {
    setLoading(true);
    updateUserDennounce(UserDennounceEnum.dennouncer, tiutiuUserController.tiutiuUser);
    updateUserDennounce(UserDennounceEnum.uid, Uuid().v4());

    _dennounceServices.uploadUserDennounceData(userDennounce);
    _dennounceServices.increaseUserDennounces(userDennounce.dennouncedUser!.uid!);
    resetForm();
    setLoading(false);
  }

  static UserDennounce _defaultUserDennounce() {
    return UserDennounce(
      dennouncer: tiutiuUserController.tiutiuUser,
      motive: AppLocalizations.of(Get.context!)!.other,
    );
  }

  final _dennounceUserMotives = [
    AppLocalizations.of(Get.context!)!.sexualAppeal,
    AppLocalizations.of(Get.context!)!.scamTry,
    AppLocalizations.of(Get.context!)!.other,
  ];
}
