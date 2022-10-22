import 'package:tiutiu/features/posts/validators/form_validators.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/utils/video_cache_manager.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

const int _FLOW_STEPS_QTY = 8;

class PostsController extends GetxController {
  PostsController({required PostService postService})
      : _postService = postService;

  PostService _postService;

  final RxString _uploadingPostText = ''.obs;
  final RxBool _isInReviewMode = false.obs;
  final RxString _flowErrorText = ''.obs;
  final RxBool _isFullAddress = false.obs;
  final RxBool _postReviewed = false.obs;
  final RxInt _postPhotoFrameQty = 1.obs;
  final RxBool _formIsValid = true.obs;
  final RxList _cachedVideos = [].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final Rx<Pet> _post = Pet().obs;
  final RxInt _flowIndex = 0.obs;

  bool get existChronicDiseaseInfo =>
      _post.value.health == PetHealthString.chronicDisease;
  String get uploadingPostText => _uploadingPostText.value;
  int get postPhotoFrameQty => _postPhotoFrameQty.value;
  String get flowErrorText => _flowErrorText.value;
  bool get isInReviewMode => _isInReviewMode.value;
  bool get isFullAddress => _isFullAddress.value;
  bool get formIsInInitialState => post == Pet();
  bool get postReviewed => _postReviewed.value;
  bool get formIsValid => _formIsValid.value;
  bool get isLoading => _isLoading.value;
  List get cachedVideos => _cachedVideos;
  int get flowIndex => _flowIndex.value;
  bool get hasError => _hasError.value;
  Pet get post => _post.value;

  void set isInReviewMode(bool value) => _isInReviewMode(value);
  void set postReviewed(bool value) => _postReviewed(value);
  void set isLoading(bool value) => _isLoading(value);

  void updatePet(PetEnum property, dynamic data) {
    final postMap = _insertOwnerData(post.toMap());
    postMap[property.name] = data;

    if (property == PetEnum.otherCaracteristics) {
      postMap[property.name] = _handlePetOtherCaracteristics(data);
    }

    if ((post.latitude == null || post.longitude == null)) {
      _setPostStateAndCity(postMap);
      _insertLatLng(postMap);
    }

    debugPrint('>> $postMap');

    _post(Pet.fromMap(postMap));
  }

  void _insertLatLng(Map<String, dynamic> postMap) {
    postMap[PetEnum.longitude.name] =
        currentLocationController.location.longitude;
    postMap[PetEnum.latitude.name] =
        currentLocationController.location.latitude;
  }

  void _setPostStateAndCity(Map<String, dynamic> postMap) async {
    final placemark = currentLocationController.currentPlacemark;

    postMap[PetEnum.city.name] = placemark.subAdministrativeArea;
    postMap[PetEnum.state.name] = placemark.administrativeArea;
  }

  Map<String, dynamic> _insertOwnerData(Map<String, dynamic> postMap) {
    if (post.owner == null) {
      postMap[PetEnum.owner.name] = tiutiuUserController.tiutiuUser.toMap();
      postMap[PetEnum.ownerId.name] = tiutiuUserController.tiutiuUser.uid;
    }

    return postMap;
  }

  void addPictureOnIndex(dynamic picture, int index) {
    if (index <= 5) {
      final postMap = _insertOwnerData(post.toMap());
      var newImageList = [];

      newImageList.addAll(postMap[PetEnum.photos.name]);
      newImageList.add(picture);

      postMap[PetEnum.photos.name] = newImageList;
      _post(Pet.fromMap(postMap));
    }
  }

  void removePictureOnIndex(int index) {
    var postMap = post.toMap();
    var newImageList = postMap[PetEnum.photos.name];
    newImageList.removeAt(index);
    postMap[PetEnum.photos.name] = newImageList;
    _post(Pet.fromMap(postMap));
  }

  List _handlePetOtherCaracteristics(String incomingCaracteristic) {
    List caracteristics = [];
    caracteristics.addAll(post.otherCaracteristics);

    if (caracteristics.contains(incomingCaracteristic)) {
      caracteristics.remove(incomingCaracteristic);
    } else {
      caracteristics.add(incomingCaracteristic);
    }

    return caracteristics;
  }

  bool isInStepReview() => _flowIndex.value == _FLOW_STEPS_QTY - 2;
  bool lastStep() => _flowIndex.value == _FLOW_STEPS_QTY - 1;
  bool firstStep() => _flowIndex.value == 0;

  Future<void> _cacheVideo() async {
    final videoPath = post.video;
    var fileName = '${post.uid}-$videoPath';
    debugPrint('>>Cache _cacheVideo');
    await VideoCacheManager.save(videoPath, fileName);
  }

  Future<String> _getCachedVideo() async {
    final videoPath = post.video;
    var fileName = '${post.uid}-$videoPath';
    debugPrint('>>Cache _getCachedVideo');
    return await VideoCacheManager.getCachedVideoIfExists(fileName);
  }

  Future<void> _saveVideosOnCache() async {
    final videoPath = post.video;
    var fileName = '${post.uid}-$videoPath';

    final value = await LocalStorage.getValueUnderString(fileName);
    debugPrint('>>Cache _saveVideosOnCache');
    if (value == null) _cacheVideo();
  }

  Future<void> _getVideosOnCache() async {
    final currentVideosCachedList = [];
    currentVideosCachedList.addAll(_cachedVideos);
    debugPrint('>>Cache _getVideosOnCache');
    final cachedVideo = await _getCachedVideo();
    currentVideosCachedList.add(cachedVideo);
  }

  Future<void> cacheAndGetVideos() async {
    debugPrint('>>Cache cacheAndGetVideos');
    if (!isInReviewMode) {
      await _saveVideosOnCache();
      await _getVideosOnCache();
    }
  }

  Future<void> uploadPost() async {
    updatePet(PetEnum.createdAt, DateTime.now().toIso8601String());

    isLoading = true;
    await _uploadVideo();
    await _uploadImages();
    await _uploadPostData();
    isLoading = false;
  }

  Future<void> _uploadVideo() async {
    if (post.video != null) _uploadingPostText(PostFlowStrings.sendingVideo);

    await _postService.uploadVideo(
      onVideoUploaded: (videoUrlDownload) {
        updatePet(PetEnum.video, videoUrlDownload);
      },
      post: post,
    );
  }

  Future<void> _uploadImages() async {
    if (post.video != null) {
      _uploadingPostText(PostFlowStrings.imageQty(post.photos.length));
    }

    await _postService.uploadImages(
      onImagesUploaded: (urlList) {
        updatePet(PetEnum.photos, urlList);
      },
      post: post,
    );
  }

  Future<void> _uploadPostData() async {
    _uploadingPostText(PostFlowStrings.sendingData);
    await _postService.uploadPostData(post);

    _uploadingPostText(PostFlowStrings.finalizing);
    await Future.delayed(Duration(seconds: 1));

    _uploadingPostText('');
  }

  void nextStepFlow() {
    PostFormValidator validator = PostFormValidator(post);
    _postReviewed(false);

    switch (flowIndex) {
      case 0:
        _formIsValid(validator.isStep1Valid());
        break;
      case 1:
        _formIsValid(validator.isStep2Valid(existChronicDiseaseInfo));
        break;
      case 2:
        _formIsValid(validator.isStep3Valid());
        break;
      case 3:
        _formIsValid(validator.isStep4Valid(isFullAddress));
        break;
      case 4:
        _formIsValid(validator.isStep5Valid());
        break;
      case 5:
        _isInReviewMode(true);
        isLoading = false;
        petsController.pet = Pet.fromMap(post.toMap());
        break;
      case 7:
        isLoading = true;
        Future.delayed(Duration(seconds: 10), () {
          isLoading = false;
        });
        break;
    }

    if (formIsValid) _nextStep();
  }

  void setError(String errorMessage) {
    _flowErrorText(errorMessage);
    _hasError(true);
  }

  void clearError() {
    _flowErrorText('');
    _hasError(false);
  }

  void clearForm() {
    _isFullAddress(false);
    _formIsValid(true);
    _post(Pet());
  }

  void increasePhotosQty() {
    if (postPhotoFrameQty < 6) _postPhotoFrameQty(postPhotoFrameQty + 1);
  }

  void decreasePhotosQty() {
    if (postPhotoFrameQty > 1) _postPhotoFrameQty(postPhotoFrameQty - 1);
  }

  void _nextStep() {
    if (flowIndex < _FLOW_STEPS_QTY) _flowIndex(flowIndex + 1);
  }

  void previousStepFlow() {
    _formIsValid(true);

    if (flowIndex == 0) {
      Get.back();
    } else {
      _flowIndex(flowIndex - 1);
    }
  }

  void reviewPost() {
    Get.toNamed(
      Routes.petDetails,
      arguments: true,
    )?.then((_) {
      _nextStep();
    });
  }

  void toggleFullAddress() {
    _isFullAddress(!isFullAddress);
  }
}
