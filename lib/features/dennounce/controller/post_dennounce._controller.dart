import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:get/get.dart';

class PostDennounceController extends GetxController {
  final Rx<PostDennounce> _postDennounce = PostDennounce().obs;
  final RxInt _postDennounceGroupValue = 3.obs;
  final RxBool _hasError = false.obs;

  int get postDennounceGroupValue => _postDennounceGroupValue.value;
  List<String> get dennouncePostMotives => _dennouncePostMotives;
  PostDennounce get postDennounce => _postDennounce.value;
  bool get hasError => _hasError.value;

  void set updatePostDennounce(PostDennounce postDennounce) => _postDennounce(postDennounce);
  void set postDennounceGroupValue(int value) => _postDennounceGroupValue(value);
  void set hasError(bool value) => _hasError(value);

  final _dennouncePostMotives = [
    PostDennounceStrings.announceNoAnswer,
    PostDennounceStrings.sexualContent,
    PostDennounceStrings.fake,
    PostDennounceStrings.other,
  ];
}
