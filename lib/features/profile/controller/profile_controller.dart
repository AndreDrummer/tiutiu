import 'package:get/get.dart';
import 'package:tiutiu/features/system/controllers.dart';

class ProfileController extends GetxController {
  Stream<int> getUserPostsCount(String? uid) {
    if (uid != null)
      return tiutiuUserController.service
          .getUserPostsById(uid)
          .asyncMap<int>((event) => event.docs.length);
    return Stream.value(0);
  }
}
