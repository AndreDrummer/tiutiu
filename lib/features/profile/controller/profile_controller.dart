import 'package:get/get.dart';
import 'package:tiutiu/features/system/controllers.dart';

class ProfileController extends GetxController {
  final RxBool _showErrorEmptyPic = false.obs;

  bool get showErrorEmptyPic => _showErrorEmptyPic.value;

  void set showErrorEmptyPic(bool value) => _showErrorEmptyPic(value);

  Stream<int> getUserPostsCount(String? uid) {
    if (uid != null)
      return tiutiuUserController.service
          .getUserPostsById(uid)
          .asyncMap<int>((event) => event.docs.length);
    return Stream.value(0);
  }
}
