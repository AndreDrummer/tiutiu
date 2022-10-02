import 'package:tiutiu/features/tiutiu_user/services/tiutiu_user_service.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TiutiuUserController extends GetxController {
  TiutiuUserController(TiutiuUserService tiutiuUserService)
      : _tiutiuUserService = tiutiuUserService;

  final TiutiuUserService _tiutiuUserService;

  final Rx<TiutiuUser> _tiutiuUser = TiutiuUser().obs;
  final RxBool _isLoading = false.obs;

  TiutiuUserService get service => _tiutiuUserService;
  TiutiuUser get tiutiuUser => _tiutiuUser.value;
  bool get isLoading => _isLoading.value;

  void updateTiutiuUser(TiutiuUserEnum property, dynamic data) {
    Map<String, dynamic> map = _tiutiuUser.value.toMap();
    map[property.name] = data;

    TiutiuUser newTiutiuUser = TiutiuUser.fromMap(map);

    _tiutiuUser(newTiutiuUser);
  }

  void set isLoading(bool value) => _isLoading(value);

  Future<void> handleNotifications(data) async {}

  Stream<QuerySnapshot> loadNotifications() {
    return _tiutiuUserService.loadNotifications(tiutiuUser.uid!);
  }

  Future<TiutiuUser> getUserById(String id) async {
    return await _tiutiuUserService.getUserByID(id);
  }

  Future<void> updateUserDataOnServer() async {
    var avatarPath = tiutiuUser.avatar;

    if (avatarPath != null && !avatarPath.toString().contains('http')) {
      var urlAvatar = await _tiutiuUserService.uploadAvatar(
        tiutiuUser.uid!,
        avatarPath,
      );

      updateTiutiuUser(TiutiuUserEnum.avatar, urlAvatar);
    }

    await _tiutiuUserService.updateUser(userData: tiutiuUser);
  }

  void resetUserData() {
    _tiutiuUser(TiutiuUser());
  }
}
