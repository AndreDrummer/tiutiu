import 'package:get/get.dart';
import 'package:tiutiu/features/system/controllers.dart';

class ProfileController extends GetxController {
  Stream<int> getUserPostsCount(String uid) {
    return tiutiuUserController.service
        .getUserPostsById(uid)
        .asyncMap<int>((event) => event.docs.length);
  }
}
