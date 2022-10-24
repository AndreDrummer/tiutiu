import 'package:tiutiu/features/posts/repository/posts_repository.dart';
import 'package:tiutiu/features/posts/validators/form_validators.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/ordenators.dart';
import 'package:flutter/foundation.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

const int _FLOW_STEPS_QTY = 8;

class PostsController extends GetxController {
  PostsController({
    required PostsRepository postsRepository,
  }) : _postsRepository = postsRepository;

  final PostsRepository _postsRepository;

  final RxMap<String, dynamic> _cachedVideos = <String, dynamic>{}.obs;
  final RxString _orderParam = FilterStrings.distance.obs;
  final RxBool _isFilteringByName = false.obs;
  final RxString _uploadingPostText = ''.obs;
  final RxBool _isInReviewMode = false.obs;
  final RxString _flowErrorText = ''.obs;
  final RxBool _isFullAddress = false.obs;
  final RxList<Pet> _posts = <Pet>[].obs;
  final RxBool _postReviewed = false.obs;
  final RxInt _postPhotoFrameQty = 1.obs;
  final RxBool _formIsValid = true.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final Rx<Pet> _post = Pet().obs;
  final RxInt _petsCount = 0.obs;
  final RxInt _flowIndex = 0.obs;

  bool get existChronicDisease => post.health == PetHealthString.chronicDisease;
  String get uploadingPostText => _uploadingPostText.value;
  Map<String, dynamic> get cachedVideos => _cachedVideos;
  bool get isFilteringByName => _isFilteringByName.value;
  int get postPhotoFrameQty => _postPhotoFrameQty.value;
  String get flowErrorText => _flowErrorText.value;
  bool get isInReviewMode => _isInReviewMode.value;
  bool get isFullAddress => _isFullAddress.value;
  bool get formIsInInitialState => post == Pet();
  bool get postReviewed => _postReviewed.value;
  String get orderParam => _orderParam.value;
  bool get formIsValid => _formIsValid.value;
  bool get isLoading => _isLoading.value;
  int get flowIndex => _flowIndex.value;
  int get petsCount => _petsCount.value;
  bool get hasError => _hasError.value;
  ChewieController? chewieController;
  List<Pet> get posts => _posts;
  Pet get post => _post.value;

  void set isInReviewMode(bool value) => _isInReviewMode(value);
  void set postReviewed(bool value) => _postReviewed(value);
  void set isLoading(bool value) => _isLoading(value);
  void set post(Pet pet) => _post(pet);

  bool isInStepReview() => _flowIndex.value == _FLOW_STEPS_QTY - 2;
  bool isInStepPost() => _flowIndex.value == _FLOW_STEPS_QTY - 1;
  bool lastStep() => _flowIndex.value == _FLOW_STEPS_QTY - 1;
  bool firstStep() => _flowIndex.value == 0;

  Map<String, dynamic> _insertOwnerData(Map<String, dynamic> postMap) {
    if (post.owner == null) {
      postMap[PetEnum.owner.name] = tiutiuUserController.tiutiuUser.toMap();
      postMap[PetEnum.ownerId.name] = tiutiuUserController.tiutiuUser.uid;
    }

    return postMap;
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

  Future<void> uploadPost() async {
    updatePet(PetEnum.createdAt, DateTime.now().toIso8601String());

    await _mockPostData();

    isLoading = true;
    await _uploadVideo();
    await _uploadImages();
    await _uploadPostData();
    isLoading = false;
    clearForm();
    goToHome();
  }

  Future<void> loadPosts({
    bool isFilteringByName = false,
    bool disappeared = false,
    String? orderParam,
  }) async {
    _isFilteringByName(isFilteringByName);
    _orderParam(orderParam);

    final list = await _postsRepository.getPostList(
      filterController.filterParams(
        disappeared: disappeared,
      ),
    );
    _petsCount(list.length);
    _posts(list);
    print('>> PostsL $posts');
  }

  List<Pet> ordernateList(List<Pet> list) {
    if (orderParam == FilterStrings.distance) {
      list.sort(Ordenators.orderByDistance);
    } else if (orderParam == FilterStrings.date) {
      list.sort(Ordenators.orderByPostDate);
    } else if (orderParam == FilterStrings.age) {
      list.sort(Ordenators.orderByAge);
    } else if (orderParam == FilterStrings.name) {
      list.sort(Ordenators.orderByName);
    }

    return list;
  }

  Future<void> _uploadVideo() async {
    if (post.video != null) _uploadingPostText(PostFlowStrings.sendingVideo);

    await _postsRepository.uploadVideo(
      onUploaded: (videoUrlDownload) {
        updatePet(PetEnum.video, videoUrlDownload);
      },
      post: post,
    );
  }

  Future<void> _uploadImages() async {
    if (post.video != null) {
      _uploadingPostText(PostFlowStrings.imageQty(post.photos.length));
    }

    await _postsRepository.uploadImages(
      onUploaded: (urlList) {
        updatePet(PetEnum.photos, urlList);
      },
      post: post,
    );
  }

  Future<void> _uploadPostData() async {
    _uploadingPostText(PostFlowStrings.sendingData);
    await _postsRepository.uploadPostData(post: post);

    _uploadingPostText(PostFlowStrings.finalizing);
    await Future.delayed(Duration(seconds: 1));

    _uploadingPostText('');
  }

  Future<void> _mockPostData() async {
    // await LocalStorage.setDataUnderKey(
    //   key: LocalStorageKey.mockedPost,
    //   data: post.toMap(convertFileToVideoPath: true),
    // );

    // final mocked = await LocalStorage.getDataUnderKey(
    //         key: LocalStorageKey.mockedPost, mapper: Pet()) !=
    //     null;

    // print('>>Mocked? $mocked');
  }

  void updatePet(PetEnum property, dynamic data) {
    final postMap = _insertOwnerData(post.toMap());
    postMap[property.name] = data;

    debugPrint('>>update $postMap');

    if (property == PetEnum.otherCaracteristics) {
      postMap[property.name] = _handlePetOtherCaracteristics(data);
    }

    if ((post.latitude == null || post.longitude == null)) {
      _setPostStateAndCity(postMap);
      _insertLatLng(postMap);
    }

    _post(Pet().fromMap(postMap));
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

  void nextStepFlow() {
    PostFormValidator validator = PostFormValidator(post);
    _postReviewed(false);

    switch (flowIndex) {
      case 0:
        _formIsValid(validator.isStep1Valid(existChronicDisease));
        break;
      case 1:
        _formIsValid(validator.isStep2Valid());
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
    disposeVideoController();
  }

  void disposeVideoController() {
    chewieController?.pause();
    chewieController?.dispose();
    chewieController == null;
  }

  void addPictureOnIndex(dynamic picture, int index) {
    if (index <= 5) {
      final postMap = _insertOwnerData(post.toMap());
      var newImageList = [];

      newImageList.addAll(postMap[PetEnum.photos.name]);
      newImageList.add(picture);

      postMap[PetEnum.photos.name] = newImageList;
      _post(Pet().fromMap(postMap));
    }
  }

  void removePictureOnIndex(int index) {
    var postMap = post.toMap();
    var newImageList = postMap[PetEnum.photos.name];
    newImageList.removeAt(index);
    postMap[PetEnum.photos.name] = newImageList;
    _post(Pet().fromMap(postMap));
  }

  void increasePhotosQty() {
    if (postPhotoFrameQty < 6) _postPhotoFrameQty(postPhotoFrameQty + 1);
  }

  void decreasePhotosQty() {
    if (postPhotoFrameQty > 1) _postPhotoFrameQty(postPhotoFrameQty - 1);
  }

  void _nextStep() {
    _pauseVideoController();
    if (flowIndex < _FLOW_STEPS_QTY) _flowIndex(flowIndex + 1);
  }

  void previousStepFlow() {
    _formIsValid(true);
    _pauseVideoController();

    if (firstStep()) {
      Get.back();
    } else if (isInStepPost()) {
      _flowIndex(flowIndex - 2);
    } else {
      _flowIndex(flowIndex - 1);
    }
  }

  void _pauseVideoController() {
    if (chewieController != null) {
      chewieController!.pause();
    }
  }

  void reviewPost() {
    if (!lastStep()) {
      Get.toNamed(
        Routes.petDetails,
        arguments: true,
      )?.then((_) {
        _nextStep();
      });
    }
  }

  void goToHome() {
    Get.offNamedUntil(Routes.home, (route) {
      return route.settings.name == Routes.home;
    });

    homeController.bottomBarIndex = 0;
  }

  void toggleFullAddress() {
    _isFullAddress(!isFullAddress);
  }
}
