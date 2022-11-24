import 'package:tiutiu/features/posts/repository/posts_repository.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/features/posts/validators/form_validators.dart';
import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/utils/file_cache_manager.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/ordenators.dart';
import 'package:flutter/foundation.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'dart:io';

const int _FLOW_STEPS_QTY = 7;

class PostsController extends GetxController {
  PostsController({
    required PostsRepository postsRepository,
  }) : _postsRepository = postsRepository;

  final PostsRepository _postsRepository;

  final RxMap<String, dynamic> _cachedVideos = <String, dynamic>{}.obs;
  final RxList<Post> _filteredPosts = <Post>[].obs;
  final RxString _uploadingPostText = ''.obs;
  final RxList<Post> _myPosts = <Pet>[].obs;
  final RxBool _isInMyPostsList = false.obs;
  final RxBool _isInReviewMode = false.obs;
  final RxBool _isEditingPost = false.obs;
  final RxBool _isFullAddress = false.obs;
  final RxList<Pet> _posts = <Pet>[].obs;
  final RxInt _postPhotoFrameQty = 1.obs;
  final RxString _flowErrorText = ''.obs;
  final RxBool _postReviewed = false.obs;
  final RxBool _formIsValid = true.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final Rx<Post> _post = Pet().obs;
  final RxInt _postsCount = 0.obs;
  final RxInt _flowIndex = 0.obs;

  bool get existChronicDisease => (post as Pet).health == PetHealthString.chronicDisease;
  String get uploadingPostText => _uploadingPostText.value;
  Map<String, dynamic> get cachedVideos => _cachedVideos;
  int get postPhotoFrameQty => _postPhotoFrameQty.value;
  bool get isInMyPostsList => _isInMyPostsList.value;
  bool get isInReviewMode => _isInReviewMode.value;
  String get flowErrorText => _flowErrorText.value;
  bool get formIsInInitialState => post == Post();
  List<Post> get filteredPosts => _filteredPosts;
  bool get isEditingPost => _isEditingPost.value;
  bool get isFullAddress => _isFullAddress.value;
  bool get postReviewed => _postReviewed.value;
  bool get formIsValid => _formIsValid.value;
  int get postsCount => _postsCount.value;
  bool get isLoading => _isLoading.value;
  int get flowIndex => _flowIndex.value;
  bool get hasError => _hasError.value;
  ChewieController? chewieController;
  List<Post> get myPosts => _myPosts;
  List<Post> get posts => _posts;
  Post get post => _post.value;

  void set isInMyPostsList(bool value) => _isInMyPostsList(value);
  void set isInReviewMode(bool value) => _isInReviewMode(value);
  void set isEditingPost(bool value) => _isEditingPost(value);
  void set postReviewed(bool value) => _postReviewed(value);
  void set isLoading(bool value) => _isLoading(value);
  void set post(Post pet) => _post(pet);

  bool isInStepReview() => _flowIndex.value == _FLOW_STEPS_QTY - 1 && !postReviewed;
  bool lastStep() => _flowIndex.value == _FLOW_STEPS_QTY - 1 && postReviewed;
  bool firstStep() => _flowIndex.value == 0;

  List<String> _urlPicturesToBeDeleted = [];

  @override
  void onInit() {
    ever(filterController.filterParams, (_) {
      _filterPosts();
    });

    super.onInit();
  }

  Map<String, dynamic> _insertOwnerData(Map<String, dynamic> postMap) {
    if (post.owner == null) {
      postMap[PostEnum.owner.name] = tiutiuUserController.tiutiuUser.toMap();
      postMap[PostEnum.ownerId.name] = tiutiuUserController.tiutiuUser.uid;
    }

    return postMap;
  }

  List _handlePetOtherCaracteristics(String incomingCaracteristic) {
    List caracteristics = [];
    caracteristics.addAll((post as Pet).otherCaracteristics);

    if (caracteristics.contains(incomingCaracteristic)) {
      caracteristics.remove(incomingCaracteristic);
    } else {
      caracteristics.add(incomingCaracteristic);
    }

    return caracteristics;
  }

  Future<void> uploadPost() async {
    if (post.createdAt == null) updatePost(PostEnum.createdAt.name, DateTime.now().toIso8601String());

    await _mockPostData();

    isLoading = true;
    await _uploadVideo();
    await _uploadImages();
    await _uploadPostData();
    await allPosts(getFromInternet: true);
    await getMyPosts();
    isLoading = false;
    isEditingPost = false;
    clearForm();
    goToHome();
  }

  Future<int> deletePost() async {
    isLoading = true;
    _uploadingPostText(PostFlowStrings.deletingAd);

    await _postsRepository.deletePost(post: post);
    await allPosts(getFromInternet: true);
    clearForm();
    _uploadingPostText('');
    isLoading = false;

    return myPosts.length;
  }

  Future<void> allPosts({bool getFromInternet = false}) async {
    final list = await _postsRepository.getPostList(getFromInternet: getFromInternet);

    _posts(list);
    _filterPosts();
  }

  Future<void> getMyPosts() async {
    _myPosts(await _postsRepository.getMyPostList(tiutiuUserController.tiutiuUser.uid!));
    _filterPosts();
  }

  List<Post> _filterPosts() {
    final postsToFilter = isInMyPostsList ? _myPosts : _posts;
    final filterParams = filterController.getParams;

    debugPrint('>> isInMyPostsList $isInMyPostsList');
    debugPrint('>> filteredPosts');
    debugPrint('>> filters $filterParams');

    final filteredByType = _filterByType(postsToFilter, filterParams.type);
    final filteredByState = _filterByState(filteredByType, filterParams.state);

    final filteredByDisappeared = _filterByDisappeared(
      filteredByState,
      filterParams.disappeared,
    );

    final isFilteringByName = filterParams.name.isNotEmptyNeighterNull();
    final filteredList = filteredByDisappeared;

    final returnedList = _ordernatedList(
      isFilteringByName ? _filterByName(filterParams.name) : filteredList,
      filterParams.orderBy,
    );

    _filteredPosts(returnedList);
    _postsCount(filteredPosts.length);

    return returnedList;
  }

  List<Post> _filterByName(String filterName) {
    List<Pet> postsFilteredByName = [];

    _posts.forEach((post) {
      final isFilteringByName = filterName.isNotEmptyNeighterNull();

      String petName = post.name!.toLowerCase();

      if (isFilteringByName) {
        if (petName.contains(filterName.toLowerCase())) {
          postsFilteredByName.add(post);
        }
      } else {
        postsFilteredByName.add(post);
      }
    });

    return postsFilteredByName;
  }

  List<Post> _filterByType(List<Post> list, String type) {
    debugPrint('>> _filterByType');

    if (type != PetTypeStrings.all) {
      return list.where((post) {
        return post.type == type;
      }).toList();
    }

    return list;
  }

  List<Post> _filterByState(List<Post> list, String state) {
    debugPrint('>> _filterByState');

    final isBr = state == StatesAndCities().stateInitials.first;

    if (!isBr) {
      final filterState = StatesAndCities().getStateNameFromInitial(state);

      return list.where((post) {
        return post.state == filterState;
      }).toList();
    }

    return list;
  }

  List<Post> _filterByDisappeared(List<Post> list, bool disappeared) {
    debugPrint('>> _filterByDisappeared');
    return list.where((post) {
      return (post as Pet).disappeared == disappeared;
    }).toList();
  }

  List<Post> _ordernatedList(List<Post> list, String orderParam) {
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
    if (post.video != null) {
      _uploadingPostText(PostFlowStrings.sendingVideo);
      await _postsRepository.uploadVideo(
        onUploaded: (videoUrlDownload) {
          updatePost(PostEnum.video.name, videoUrlDownload);
        },
        post: post,
      );
    }
  }

  Future<void> _uploadImages() async {
    _uploadingPostText(PostFlowStrings.imageQty(post.photos.length));

    await _postsRepository.uploadImages(
      imagesToDelete: _urlPicturesToBeDeleted,
      onUploaded: (urlList) {
        updatePost(PostEnum.photos.name, urlList);
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

  Future<void> _cacheVideo(Map<String, dynamic> cachedVideosMap) async {
    debugPrint('>>Cache _cacheVideo');
    final videoPathSaved = await FileCacheManager.save(
      fileUrl: post.video,
      filename: post.uid!,
      type: FileType.video,
    );

    cachedVideosMap.putIfAbsent(post.uid!, () => videoPathSaved);

    debugPrint('>>Cache current video map $cachedVideosMap');

    await LocalStorage.setValueUnderLocalStorageKey(
      key: LocalStorageKey.videosCached,
      value: cachedVideosMap,
    );
  }

  Future<void> getCachedAssets() async {
    _cachedVideos(await _cachedVideosMap());

    debugPrint('>>getCachedAssets Videos $cachedVideos');
  }

  Future<void> cacheVideos() async {
    final videosCachedData = await _cachedVideosMap();

    if (!isInReviewMode && post.video != null) {
      if (!videosCachedData.keys.contains(post.uid)) {
        debugPrint('>>Cache cacheVideos Video Not Saved');
        await _cacheVideo(videosCachedData);
      } else {
        debugPrint('>>Cache cacheVideos Video Already Saved');
      }
    }
  }

  Future<Map<String, dynamic>> _cachedVideosMap() async {
    final storagedVideos = await LocalStorage.getValueUnderLocalStorageKey(
      LocalStorageKey.videosCached,
    );

    debugPrint('>>Storaged Videos $storagedVideos');

    final Map<String, dynamic> cachedVideosMap = {};

    if (storagedVideos != null) {
      cachedVideosMap.addAll(storagedVideos);
    }

    return cachedVideosMap;
  }

  void updatePost(String property, dynamic data) {
    final postMap = _insertOwnerData(post.toMap());
    postMap[property] = data;

    debugPrint('>> updating post... $postMap');

    if (property == PetEnum.otherCaracteristics.name) {
      postMap[property] = _handlePetOtherCaracteristics(data);
    }

    if ((post.latitude == null || post.longitude == null)) {
      _setPostStateAndCity(postMap);
      _insertLatLng(postMap);
    }

    final newPost = Pet().fromMap(postMap);
    debugPrint('>> post updated $newPost');

    _post(newPost);
  }

  void _insertLatLng(Map<String, dynamic> postMap) {
    postMap[PostEnum.longitude.name] = currentLocationController.location.longitude;
    postMap[PostEnum.latitude.name] = currentLocationController.location.latitude;
  }

  void _setPostStateAndCity(Map<String, dynamic> postMap) async {
    final placemark = currentLocationController.currentPlacemark;
    late String state;
    late String city;

    if (Platform.isAndroid) {
      city = placemark.subAdministrativeArea!;
      state = placemark.administrativeArea!;
    } else if (Platform.isIOS) {
      state = StatesAndCities().getStateNameFromInitial(placemark.administrativeArea!);
      city = placemark.locality!;
    }

    postMap[PostEnum.state.name] = state;
    postMap[PostEnum.city.name] = city;
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
    _urlPicturesToBeDeleted.clear();
    _isFullAddress(false);
    _isEditingPost(false);
    _postReviewed(false);
    _formIsValid(true);
    _flowIndex(0);
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

      newImageList.addAll(postMap[PostEnum.photos.name]);
      newImageList.add(picture);

      postMap[PostEnum.photos.name] = newImageList;
      _post(Pet().fromMap(postMap));
    }
  }

  void removePictureOnIndex(int index) {
    var postMap = post.toMap();
    var newImageList = postMap[PostEnum.photos.name];
    final removedImage = newImageList.removeAt(index);
    if (removedImage.toString().isUrl()) {
      _urlPicturesToBeDeleted.add(removedImage);
    }
    postMap[PostEnum.photos.name] = newImageList;
    _post(Pet().fromMap(postMap));
  }

  void increasePhotosQty() {
    if (postPhotoFrameQty < 6) _postPhotoFrameQty(postPhotoFrameQty + 1);
  }

  void decreasePhotosQty() {
    if (postPhotoFrameQty > 1) _postPhotoFrameQty(postPhotoFrameQty - 1);
  }

  void _nextStep() {
    _pauseVideo();
    if (flowIndex < _FLOW_STEPS_QTY) _flowIndex(flowIndex + 1);
  }

  void previousStepFlow() {
    _postReviewed(false);
    _formIsValid(true);
    _pauseVideo();

    if (firstStep()) {
      Get.back();
    } else {
      _flowIndex(flowIndex - 1);
    }
  }

  void _pauseVideo() {
    if (chewieController != null) {
      chewieController!.pause();
    }
  }

  void reviewPost() {
    _postReviewed(false);
    isInReviewMode = true;
    Get.toNamed(Routes.postDetails)?.then((_) {
      _postReviewed(true);
      isInReviewMode = false;
    });
  }

  Future<void> increasePostViews() async {
    if (!isEditingPost && !isInReviewMode) {
      await PostService().increasePostViews(post.uid!, post.views);
    }
  }

  Stream<int> postViews(String postId) {
    return PostService().postViews(postId);
  }

  void openMypostsLists() {
    filterController.reset();
    postsController.isInMyPostsList = true;
    _filterPosts();
    Get.toNamed(Routes.myPosts);
  }

  void closeMypostsLists() {
    postsController.isInMyPostsList = false;
    Get.back();
  }

  void backReviewAndPost() {
    _pauseVideo();
    Get.back();
    uploadPost();
  }

  void goToHome() {
    Get.offNamedUntil(Routes.home, (route) {
      return route.settings.name == Routes.home;
    });

    homeController.setDonateIndex();
  }

  void toggleFullAddress() {
    _isFullAddress(!isFullAddress);
  }
}
