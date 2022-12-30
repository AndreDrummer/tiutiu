import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:get/get.dart';

class PostDennounceController extends GetxController {
  final Rx<PostDennounce> _postBeingDennounced = PostDennounce().obs;

  PostDennounce get postBeingDennounced => _postBeingDennounced.value;

  void updatePostDennounce(PostDennounceEnum property, dynamic data) {
    final dennounceMap = postBeingDennounced.toMap();

    dennounceMap[property.name] = data;

    if (dennounceMap[PostDennounceEnum.dennouncer.name] == null) {
      dennounceMap[PostDennounceEnum.dennouncer.name] = tiutiuUserController.tiutiuUser.toMap();
    }

    _postBeingDennounced(PostDennounce.fromMap(dennounceMap));
  }
}
