import 'package:tiutiu/features/posts/repository/posts_repository.dart';
import 'package:tiutiu/features/posts/validators/form_validators.dart';
import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/features/posts/utils/post_utils.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/utils/video_utils.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'dart:io';

const int _FLOW_STEPS_QTY = 7;

class PostsController extends GetxController with TiuTiuPopUp {
  PostsController({
    required PostsRepository postsRepository,
    required PostService postService,
  })  : _postsRepository = postsRepository,
        _postService = postService;

  final PostsRepository _postsRepository;
  final PostService _postService;

  final RxMap<String, dynamic> _cachedVideos = <String, dynamic>{}.obs;
  final RxBool _addressIsWithCompliment = false.obs;
  final RxList<Post> _filteredPosts = <Post>[].obs;
  final RxString _uploadingPostText = ''.obs;
  final RxBool _isInMyPostsList = false.obs;
  final RxBool _isInReviewMode = false.obs;
  final RxBool _isEditingPost = false.obs;
  final RxList<Pet> _posts = <Pet>[].obs;
  final RxString _flowErrorText = ''.obs;
  final RxBool _postReviewed = false.obs;
  final RxBool _formIsValid = true.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final Rx<Post> _post = Pet().obs;
  final RxInt _postsCount = 0.obs;
  final RxInt _flowIndex = 0.obs;

  bool get existChronicDisease => (post as Pet).health == PetHealthString.chronicDisease;
  bool get addressIsWithCompliment => _addressIsWithCompliment.value;
  String get uploadingPostText => _uploadingPostText.value;
  Map<String, dynamic> get cachedVideos => _cachedVideos;
  bool get isInMyPostsList => _isInMyPostsList.value;
  bool get isInReviewMode => _isInReviewMode.value;
  String get flowErrorText => _flowErrorText.value;
  bool get formIsInInitialState => post == Post();
  List<Post> get filteredPosts => _filteredPosts;
  bool get isEditingPost => _isEditingPost.value;
  bool get postReviewed => _postReviewed.value;
  bool get formIsValid => _formIsValid.value;
  int get postsCount => _postsCount.value;
  bool get isLoading => _isLoading.value;
  int get flowIndex => _flowIndex.value;
  bool get hasError => _hasError.value;
  ChewieController? chewieController;
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

  bool postBelongsToMe([Post? postToCompareWith]) {
    TiutiuUser myUser = tiutiuUserController.tiutiuUser;
    Post p = postToCompareWith ?? post;
    TiutiuUser postOwner = p.owner!;

    return myUser.uid == postOwner.uid;
  }

  Stream<List<Post>> postsStream() {
    return _postService.pathToPostsStream().snapshots().asyncMap((postSnapshot) {
      final postsList = postSnapshot.docs.map((post) {
        return Pet().fromMap(post.data());
      }).toList();

      _posts(postsList);
      return PostUtils.filterPosts(postsList: _posts);
    });
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

  Future<void> cacheVideos() async {
    await VideoUtils(post: post).cacheVideos(isInReviewMode: isInReviewMode);
  }

  Future<void> getCachedVideos() async {
    _cachedVideos(await VideoUtils(post: post).cachedVideosMap());

    debugPrint('TiuTiuApp: getCachedVideos Videos $cachedVideos');
  }

  Future<void> uploadPost() async {
    if (post.createdAt == null) updatePost(PostEnum.createdAt.name, DateTime.now().toIso8601String());

    setLoading(true);
    await _uploadVideo();
    await _uploadImages();
    await _uploadPostData();
    await getAllPosts();
    setLoading(false);
    isEditingPost = false;
    clearForm();
    goToHome();
  }

  Future<int> deletePost() async {
    setLoading(true, loadingText: PostFlowStrings.deletingAd);

    await _postsRepository.deletePost(post: post);
    await getAllPosts();
    clearForm();
    setLoading(false);

    return loggedUserPosts().length;
  }

  Future<void> getAllPosts() async {
    final list = await _postsRepository.getPostList();
    _posts(list);

    final filteredPosts = PostUtils.filterPosts(postsList: _posts);

    _filteredPosts(filteredPosts);
    _postsCount(filteredPosts.length);
  }

  List<Post> loggedUserPosts() {
    return _posts.where(postBelongsToMe).toList();
  }

  Future<void> _uploadVideo() async {
    if (post.video != null) {
      _uploadingPostText(PostFlowStrings.sendingVideo);

      Future.delayed(Duration(seconds: 30), () {
        _uploadingPostText(PostFlowStrings.stillSendingAd);
      });

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

  Future<void> handleContactTapped({String contactType = 'whatsapp', required Future Function() onAdWatched}) async {
    setLoading(true);
    final lastTimeWatchedRewarded = await LocalStorage.getValueUnderLocalStorageKey(
      contactType == 'whatsapp'
          ? LocalStorageKey.lastTimeWatchedWhatsappRewarded
          : LocalStorageKey.lastTimeWatchedChatRewarded,
    );

    debugPrint(
      'TiuTiuApp: Last Time Watched a ${contactType == 'whatsapp' ? 'WhatsApp Rewarded' : 'Chat Rewarded'} $lastTimeWatchedRewarded',
    );

    if (lastTimeWatchedRewarded == null) {
      warningUserAboutRewarded(contactType);
    } else {
      final minutes = DateTime.now().difference(DateTime.parse(lastTimeWatchedRewarded)).inMinutes;

      if (minutes >= adMobController.minutesFreeOfRewardedAd(contactType)) {
        debugPrint('TiuTiuApp: Must Show Rewarded..');
        warningUserAboutRewarded(contactType);
      } else {
        await onAdWatched();
      }
    }

    setLoading(false);
  }

  Future<void> warningUserAboutRewarded(String contactType) async {
    await adMobController.loadRewardedAd();
    await LocalStorage.deleteDataUnderLocalStorageKey(
      contactType == 'whatsapp'
          ? LocalStorageKey.lastTimeWatchedWhatsappRewarded
          : LocalStorageKey.lastTimeWatchedChatRewarded,
    );

    await showPopUp(
      message: AppStrings.watchAnAd,
      confirmText: AppStrings.back,
      textColor: AppColors.black,
      mainAction: () async {
        Get.back();
        setLoading(false);
        await adMobController.showRewardedAd(contactType);
      },
      secondaryAction: () {
        Get.back();
        setLoading(false);
      },
      denyText: AppStrings.watch,
      barrierDismissible: false,
      title: AppStrings.ad,
      warning: false,
      error: false,
      info: true,
    );
  }

  void setLoading(bool loadingValue, {String loadingText = ''}) {
    _isLoading(loadingValue);
    _uploadingPostText(loadingText);
  }

  void _filterPosts() {
    final postsTofilter = isInMyPostsList ? loggedUserPosts() : _posts;
    _filteredPosts(PostUtils.filterPosts(postsList: postsTofilter));
    _postsCount(filteredPosts.length);
  }

  void updatePost(String property, dynamic data) {
    final postMap = _insertOwnerData(post.toMap());
    postMap[property] = data;

    debugPrint('TiuTiuApp: updating post... $postMap');

    if (property == PetEnum.otherCaracteristics.name) {
      postMap[property] = _handlePetOtherCaracteristics(data);
    }

    if ((post.latitude == null || post.longitude == null)) {
      _setPostStateAndCity(postMap);
      _insertLatLng(postMap);
    }

    final newPost = Pet().fromMap(postMap);
    debugPrint('TiuTiuApp: post updated $newPost');

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
      state = StatesAndCities.stateAndCities.getStateNameFromInitial(placemark.administrativeArea!);
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
        _formIsValid(validator.isStep4Valid(addressIsWithCompliment));
        break;
      case 4:
        _formIsValid(validator.isStep5Valid());
        break;
      case 5:
        setLoading(false);
        break;
    }

    // _nextStep();
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
    _addressIsWithCompliment(false);
    _isEditingPost(false);
    _postReviewed(false);
    _formIsValid(true);
    _flowIndex(0);
    _post(Pet());
    if (isInReviewMode) disposeVideoController();
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
    if (!isEditingPost && !isInReviewMode && !postBelongsToMe()) {
      await _postService.increasePostViews(post.uid!, post.views);
    }
  }

  Future<bool> showsCancelPostPopUp({bool isInsideFlow = false}) async {
    bool returnValue = false;

    await showPopUp(
      message: PostFlowStrings.postCancelMessage,
      title: PostFlowStrings.postCancelTitle,
      mainAction: () => Get.back(),
      confirmText: AppStrings.yes,
      barrierDismissible: false,
      denyText: AppStrings.no,
      secondaryAction: () {
        Get.back();

        if (postsController.isEditingPost) {
          postsController.isEditingPost = false;
          Get.back();
        } else {
          homeController.setDonateIndex();
        }

        postsController.clearForm();
        if (isInsideFlow) returnValue = true;
      },
      error: true,
    );

    return returnValue;
  }

  Stream<int> postViews(String postId) {
    return _postService.postViews(postId);
  }

  void openMypostsLists() {
    filterController.reset();
    postsController.isInMyPostsList = true;
    _filterPosts();
    Get.toNamed(Routes.myPosts);
  }

  void closeMypostsLists() {
    postsController.isInMyPostsList = false;
    filterController.reset();
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
    _addressIsWithCompliment(!addressIsWithCompliment);
  }
}
