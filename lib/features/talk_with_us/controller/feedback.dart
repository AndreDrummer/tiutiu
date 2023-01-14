import 'package:tiutiu/features/talk_with_us/service/feedback.dart';
import 'package:tiutiu/features/talk_with_us/model/feedback.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController with TiuTiuPopUp {
  FeedbackController({required FeedbackService feedbackService}) : _feedbackService = feedbackService;

  final FeedbackService _feedbackService;

  final Rx<Feedback> _feedback = Feedback().obs;
  final RxBool _insertImages = false.obs;
  final RxString _loadingText = ''.obs;
  final RxBool _isFormValid = true.obs;
  final RxBool _isLoading = false.obs;
  final int maxScreenshots = 3;

  bool get insertImages => _insertImages.value;
  String get loadingText => _loadingText.value;
  bool get isFormValid => _isFormValid.value;
  Feedback get feedback => _feedback.value;
  bool get isLoading => _isLoading.value;

  void set insertImages(bool value) => _insertImages(value);
  void set loadingText(String text) => _loadingText(text);
  void set isLoading(bool value) => _isLoading(value);

  void updateFeedback(FeedbackEnum property, dynamic data) {
    final map = feedback.toMap();
    map[property.name] = data;

    debugPrint('TiuTiuApp: Updating talk with us data $map');

    _feedback(Feedback.fromMap(map));
  }

  void addPictureOnIndex(dynamic picture, int index) {
    if (index <= maxScreenshots) {
      final feedbackMap = feedback.toMap();
      var newImageList = [];

      newImageList.addAll(feedbackMap[FeedbackEnum.screenshots.name]);
      newImageList.add(picture);

      feedbackMap[FeedbackEnum.screenshots.name] = newImageList;
      _feedback(Feedback.fromMap(feedbackMap));
    }
  }

  void removePictureOnIndex(int index) {
    var feedbackMap = feedback.toMap();
    var newImageList = feedbackMap[FeedbackEnum.screenshots.name];

    newImageList.removeAt(index);

    feedbackMap[FeedbackEnum.screenshots.name] = newImageList;
    _feedback(Feedback.fromMap(feedbackMap));
  }

  void _checkIfFormIsValid() {
    final value = feedback.contactSubject.isNotEmptyNeighterNull() &&
        feedback.contactMessage.isNotEmptyNeighterNull() &&
        (insertImages ? feedback.screenshots.isNotEmpty : true);

    _isFormValid(value);
  }

  void setLoading(bool loadingValue, String loadingText) {
    _isLoading(loadingValue);
    _loadingText(loadingText);
  }

  void clearForm() {
    _feedback(Feedback());
    setLoading(false, '');
    _insertImages(false);
    _isFormValid(true);
    Get.offNamedUntil(Routes.home, (routeName) => routeName == Routes.home);
  }

  Future<void> submitForm() async {
    _checkIfFormIsValid();

    if (isFormValid) {
      setLoading(true, '');

      updateFeedback(FeedbackEnum.deviceInfo, await systemController.getDeviceInfo());

      await _submit().then((_) async => _showsSuccessPopup(), onError: (error, stackTrace) {
        debugPrint('TiuTiuApp: Error when tryna upload feedback: $error, $stackTrace');
        setLoading(false, '');
        _showsErrorPopup();
      });
    }

    setLoading(false, '');
  }

  Future<void> _submit() async {
    if (feedback.createdAt == null) updateFeedback(FeedbackEnum.createdAt, DateTime.now().toIso8601String());
    if (feedback.ownerId == null) updateFeedback(FeedbackEnum.ownerId, tiutiuUserController.tiutiuUser.uid);
    if (feedback.uid == null) updateFeedback(FeedbackEnum.uid, Uuid().v4());
    if (!insertImages) updateFeedback(FeedbackEnum.screenshots, []);

    await _uploadPrints();
    await _uploadFeedbackData();
  }

  Future<void> _uploadPrints() async {
    if (feedback.screenshots.isNotEmpty) {
      _loadingText(PostFlowStrings.imageQty(feedback.screenshots.length));

      await _feedbackService.uploadPrints(
        onPrintsUploaded: (printsUrlList) {
          updateFeedback(FeedbackEnum.screenshots, printsUrlList);
        },
        feedback: feedback,
      );
    }
  }

  Future<void> _uploadFeedbackData() async {
    setLoading(true, FeedbackStrings.sendingYourMessage);

    await _feedbackService.uploadFeedbackData(feedback);
  }

  Future<void> _showsSuccessPopup() async {
    await showsOnRequestSuccessPopup(
      message: FeedbackStrings.successSent,
      onDone: () {
        Get.back();
        clearForm();
      },
    );
  }

  Future<void> _showsErrorPopup() async {
    await showsOnRequestErrorPopup(
      message: FeedbackStrings.failureWarning,
      title: FeedbackStrings.failure,
      confirmText: AppStrings.cancel,
      denyText: AppStrings.tryAgain,
      onCancel: Get.back,
      onRetry: () {
        setLoading(true, FeedbackStrings.tryingAgain);
        Get.back();
        submitForm();
      },
    );
  }
}
