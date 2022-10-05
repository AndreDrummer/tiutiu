import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<TiutiuUser> _profileUser = tiutiuUserController.tiutiuUser.obs;
  final RxBool _showErrorEmptyPic = false.obs;
  final RxBool _isLoading = false.obs;

  bool get showErrorEmptyPic => _showErrorEmptyPic.value;
  bool get isLoading => _isLoading.value;
  TiutiuUser get profileUser => _profileUser.value;

  void set showErrorEmptyPic(bool value) => _showErrorEmptyPic(value);
  void set profileUser(TiutiuUser user) => _profileUser(user);

  void updateUserProfileData(TiutiuUserEnum property, dynamic data) {
    Map<String, dynamic> map = _profileUser.value.toMap();
    map[property.name] = data;

    TiutiuUser newTiutiuUser = TiutiuUser.fromMap(map);

    _profileUser(newTiutiuUser);
  }

  Future<void> save() async {
    _isLoading(true);
    tiutiuUserController.updateTiutiuUser(
      TiutiuUserEnum.uid,
      profileUser,
      true,
    );

    await tiutiuUserController.updateUserDataOnServer();
    _isLoading(false);
  }

  Stream<int> getUserPostsCount(String? uid) {
    if (uid != null)
      return tiutiuUserController.service
          .getUserPostsById(uid)
          .asyncMap<int>((event) => event.docs.length);
    return Stream.value(0);
  }
}
