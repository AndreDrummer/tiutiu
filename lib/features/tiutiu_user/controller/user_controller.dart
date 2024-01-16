import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:tiutiu/features/tiutiu_user/services/tiutiu_user_service.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/validators.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TiutiuUserController extends GetxController {
  TiutiuUserController(TiutiuUserService tiutiuUserService) : _tiutiuUserService = tiutiuUserService;

  final TiutiuUserService _tiutiuUserService;

  final RxBool _whatsappNumberHasBeenUpdated = false.obs;
  final Rx<TiutiuUser> _tiutiuUser = TiutiuUser().obs;
  final RxBool _isAppropriatelyRegistered = false.obs;
  final RxBool _isLoading = false.obs;

  bool get whatsappNumberHasBeenUpdated => _whatsappNumberHasBeenUpdated.value;
  bool get isAppropriatelyRegistered => _isAppropriatelyRegistered.value;
  TiutiuUser get tiutiuUser => _tiutiuUser.value;
  bool get isLoading => _isLoading.value;

  void set whatsappNumberHasBeenUpdated(bool value) => _whatsappNumberHasBeenUpdated(value);

  void updateTiutiuUser(TiutiuUserEnum property, dynamic data, [bool replace = false]) {
    if (replace && data is TiutiuUser) {
      _tiutiuUser(data);
    } else {
      Map<String, dynamic> map = _tiutiuUser.value.toMap();
      map[property.name] = data;

      TiutiuUser newTiutiuUser = TiutiuUser.fromMap(map);

      _tiutiuUser(newTiutiuUser);
    }
  }

  void set isLoading(bool value) => _isLoading(value);

  void resetUserWithThisUser({TiutiuUser? user}) {
    _tiutiuUser(user ?? TiutiuUser());
  }

  Future<TiutiuUser> getUserById(String id) async {
    final TiutiuUser user = await _tiutiuUserService.getUserByID(id);
    return user;
  }

  Future<DocumentReference> getUserReferenceById(String id) async {
    final DocumentReference userReference = await _tiutiuUserService.getUserReferenceById(id);
    return userReference;
  }

  Future<void> updateUserDataOnServer() async {
    var avatarPath = tiutiuUser.avatar;

    isLoading = true;
    if (avatarPath != null && !avatarPath.toString().isUrl()) {
      if (kDebugMode) debugPrint('TiuTiuApp: Updating Avatar...');
      var urlAvatar = await _tiutiuUserService.uploadAvatar(
        tiutiuUser.uid ?? authController.user!.uid,
        avatarPath,
      );

      updateTiutiuUser(TiutiuUserEnum.avatar, urlAvatar);
    }

    if (tiutiuUser.reference == null) updateUserReference();

    _tiutiuUserService.updateUser(userData: tiutiuUser);
    isLoading = false;
  }

  Future<void> updateLoggedUserData(String userId) async {
    _tiutiuUser(await getUserById(userId));
  }

  Future<bool> updateUserReference() async {
    bool success = false;

    try {
      final docRef = EndpointResolver.getDocumentEndpoint(EndpointNames.pathToUser.name, [tiutiuUser.uid!]);
      await docRef.set({TiutiuUserEnum.reference.name: docRef}, SetOptions(merge: true));

      if (kDebugMode) debugPrint('TiuTiuApp: User Reference Updated Successfully ${tiutiuUser.uid}');
      success = true;
    } on Exception catch (exception) {
      crashlyticsController.reportAnError(
        message: 'Erro when tryna to update user reference: $exception',
        exception: exception,
        stackTrace: StackTrace.current,
      );
    }

    return success;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserPostsById(String userId) {
    return _tiutiuUserService.getUserPostsById(userId);
  }

  void checkUserRegistered() {
    bool registered = false;

    final hasNumber = Validators.isValidPhone(tiutiuUser.phoneNumber);
    final hasName = tiutiuUser.displayName != null;
    final hasAvatar = tiutiuUser.avatar != null;
    final hasUid = tiutiuUser.uid != null;

    registered = hasNumber && hasName && hasAvatar && hasUid;

    _isAppropriatelyRegistered(registered);
  }
}
