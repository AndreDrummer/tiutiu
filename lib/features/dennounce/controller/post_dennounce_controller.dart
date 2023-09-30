import 'package:tiutiu/features/dennounce/services/dennounce_services.dart';
import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/features/posts/utils/post_utils.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

class PostDennounceController extends GetxController {
  final Rx<PostDennounce> _postDennounce = _defaultPostDennounce().obs;
  final RxInt _postDennounceGroupValue = 3.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;

  int get postDennounceGroupValue => _postDennounceGroupValue.value;
  List<String> get dennouncePostMotives => _dennouncePostMotives;
  PostDennounce get postDennounce => _postDennounce.value;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;

  void set postDennounceGroupValue(int value) => _postDennounceGroupValue(value);
  void set isLoading(bool value) => _isLoading(value);
  void set hasError(bool value) => _hasError(value);

  void updatePostDennounce(PostDennounceEnum property, dynamic data) {
    if (property == PostDennounceEnum.dennouncedPost) _postDennounce(postDennounce.copyWith(dennouncedPost: data));
    if (property == PostDennounceEnum.description) _postDennounce(postDennounce.copyWith(description: data));
    if (property == PostDennounceEnum.dennouncer) _postDennounce(postDennounce.copyWith(dennouncer: data));
    if (property == PostDennounceEnum.motive) _postDennounce(postDennounce.copyWith(motive: data));
    if (property == PostDennounceEnum.uid) _postDennounce(postDennounce.copyWith(uid: data));
  }

  void resetForm() {
    _postDennounce(_defaultPostDennounce());
    _postDennounceGroupValue(3);
    _hasError(false);
  }

  void setLoading(bool loadingValue) {
    _isLoading(loadingValue);
  }

  Future<void> submit() async {
    setLoading(true);
    updatePostDennounce(PostDennounceEnum.dennouncer, tiutiuUserController.tiutiuUser);
    updatePostDennounce(PostDennounceEnum.uid, Uuid().v4());

    await DennounceServices().uploadPostDennounceData(postDennounce);
    if (postDennounce.motive == AppLocalizations.of(Get.context!)!.other) {
      postsController
          .increasePostDennounces('${AppLocalizations.of(Get.context!)!.other}: ${postDennounce.description}');
    } else {
      postsController.increasePostDennounces(postDennounce.motive);
    }

    await checkIfMustBeDeleted();

    resetForm();
    setLoading(false);
  }

  Future<void> checkIfMustBeDeleted() async {
    final post = postDennounce.dennouncedPost;

    final postReference = PostUtils.updatePostReferenceAndReturn(post!.uid!);
    final snapshot = await postReference.get();

    final map = snapshot.data() as Map<String, dynamic>;
    final pet = Pet().fromMap(map);

    if (snapshot.exists && pet.timesDennounced > 3) {
      PostUtils.deletePostDataOnStorage(post);
      postReference.delete();
    }
  }

  static PostDennounce _defaultPostDennounce() {
    return PostDennounce(
      dennouncer: tiutiuUserController.tiutiuUser,
      motive: AppLocalizations.of(Get.context!)!.other,
    );
  }

  final _dennouncePostMotives = [
    AppLocalizations.of(Get.context!)!.announceNoAnswer,
    AppLocalizations.of(Get.context!)!.sexualContent,
    AppLocalizations.of(Get.context!)!.fake,
    AppLocalizations.of(Get.context!)!.other,
  ];
}
