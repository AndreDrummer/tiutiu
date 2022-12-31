import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:get/get.dart';

class PostDennounceController extends GetxController {
  final Rx<PostDennounce> _postDennounce = PostDennounce(motive: PostDennounceStrings.other).obs;
  final RxInt _postDennounceGroupValue = 3.obs;
  final RxBool _hasError = false.obs;

  int get postDennounceGroupValue => _postDennounceGroupValue.value;
  List<String> get dennouncePostMotives => _dennouncePostMotives;
  PostDennounce get postDennounce => _postDennounce.value;
  bool get hasError => _hasError.value;

  void set postDennounceGroupValue(int value) => _postDennounceGroupValue(value);
  void set hasError(bool value) => _hasError(value);

  void updatePostDennounce(PostDennounceEnum property, dynamic data) {
    if (property == PostDennounceEnum.dennouncedPost) _postDennounce(postDennounce.copyWith(dennouncedPost: data));
    if (property == PostDennounceEnum.description) _postDennounce(postDennounce.copyWith(description: data));
    if (property == PostDennounceEnum.dennouncer) _postDennounce(postDennounce.copyWith(dennouncer: data));
    if (property == PostDennounceEnum.motive) _postDennounce(postDennounce.copyWith(motive: data));
  }

  void resetForm() {
    _postDennounce(PostDennounce(motive: PostDennounceStrings.other));
    _postDennounceGroupValue(3);
  }

  final _dennouncePostMotives = [
    PostDennounceStrings.announceNoAnswer,
    PostDennounceStrings.sexualContent,
    PostDennounceStrings.fake,
    PostDennounceStrings.other,
  ];
}
