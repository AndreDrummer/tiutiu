import 'package:tiutiu/features/posts/repository/posts_repository.dart';
import 'package:tiutiu/features/posts/validators/form_validators.dart';
import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/models/dynamic_link_parameters.dart';
import 'package:tiutiu/core/Exceptions/tiutiu_exceptions.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/features/posts/utils/post_utils.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:ui';

const int _FLOW_STEPS_QTY = 7;

enum CardVisibilityKind {
  banner,
  card,
}

class PostsController extends GetxController with TiuTiuPopUp {
  PostsController({
    required PostsRepository postsRepository,
    required PostService postService,
  })  : _postsRepository = postsRepository,
        _postService = postService;

  final PostsRepository _postsRepository;
  final PostService _postService;

  final Rx<CardVisibilityKind> _cardVisibilityKind = CardVisibilityKind.banner.obs;
  final RxMap<String, dynamic> _cachedVideos = <String, dynamic>{}.obs;
  final RxString _tiutiuTokStartingVideoPostId = ''.obs;
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

  bool get existChronicDisease => (post as Pet).health == AppLocalizations.of(Get.context!).chronicDisease;
  String get tiutiuTokStartingVideoPostId => _tiutiuTokStartingVideoPostId.value;
  CardVisibilityKind get cardVisibilityKind => _cardVisibilityKind.value;
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
  List<Post> get posts => _posts;
  Post get post => _post.value;

  void set tiutiuTokStartingVideoPostId(String value) => _tiutiuTokStartingVideoPostId(value);
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
    TiutiuUser postOwner = p.owner ?? TiutiuUser();

    return myUser.uid == postOwner.uid;
  }

  Map<String, dynamic> _insertOwnerData(Map<String, dynamic> postMap) {
    if (post.owner == null) {
      postMap[PostEnum.owner.name] = tiutiuUserController.tiutiuUser.toMap();
      postMap[PostEnum.ownerId.name] = tiutiuUserController.tiutiuUser.uid;
    }

    return postMap;
  }

  bool get tiutiutokPostsListIsEmpty => _posts.where((post) => post.video != null).toList().isEmpty;

  List<Post> loggedUserPosts() => _posts.where(postBelongsToMe).toList();

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

  Stream<List<Post>> postsStream() {
    return _postService.pathToPostsStream().snapshots().asyncMap((postSnapshot) {
      final postsList = postSnapshot.docs.map((post) {
        final map = post.data();

        return Pet().fromMap(map);
      }).toList();

      _posts(postsList);
      return PostUtils.filterPosts(postsList: _posts);
    });
  }

  Stream<int> postViews(String postId) => _postService.postViews(postId);

  Stream<int> postSharedTimes(String postId) => _postService.postSharedTimes(postId);

  Future<void> uploadPost() async {
    if (post.createdAt == null) updatePost(PostEnum.createdAt.name, DateTime.now().toIso8601String());

    setLoading(true);
    try {
      await _uploadVideo();
      await _uploadImages();
      await _uploadPostData();
      await _updatePostReference();
      await getAllPosts();
    } catch (_) {
      setLoading(false);
    }

    setLoading(false);
    isEditingPost = false;
    clearForm();
    goToHome();
  }

  Future<int> deletePost() async {
    setLoading(true, loadingText: AppLocalizations.of(Get.context!).deletingAd);

    await _postsRepository.deletePost(post: post);
    await getAllPosts();

    clearForm();
    setLoading(false);

    return loggedUserPosts().length;
  }

  Future<List<Post>> getAllPosts() async {
    final list = await _postsRepository.getPostList();
    _posts(list);

    final filteredPosts = PostUtils.filterPosts(postsList: isInMyPostsList ? loggedUserPosts() : _posts);

    _filteredPosts(filteredPosts);
    _postsCount(filteredPosts.length);

    return filteredPosts;
  }

  Future<void> _uploadVideo() async {
    if (post.video != null) {
      _uploadingPostText(AppLocalizations.of(Get.context!).sendingVideo);

      Future.delayed(Duration(seconds: 30), () {
        _uploadingPostText(AppLocalizations.of(Get.context!).stillSendingAd);
      });

      await _postsRepository.uploadVideo(
        onUploaded: (videoUrlDownload) {
          updatePost(PostEnum.video.name, videoUrlDownload);
        },
        post: post,
      );
    }
  }

  Future<bool> shwoDeletePostPopup() async {
    bool isTodelete = false;

    await showPopUp(
      message: AppLocalizations.of(Get.context!).deleteForever,
      confirmText: AppLocalizations.of(Get.context!).yes,
      textColor: AppColors.black,
      mainAction: () {
        Get.back();
      },
      secondaryAction: () async {
        isTodelete = true;
        Get.back();
      },
      backGroundColor: AppColors.warning,
      title: AppLocalizations.of(Get.context!).deleteAd,
      barrierDismissible: false,
      denyText: AppLocalizations.of(Get.context!).no,
    );

    return isTodelete;
  }

  Future<void> _uploadImages() async {
    _uploadingPostText(AppLocalizations.of(Get.context!).imageQty(post.photos.length));

    await _postsRepository.uploadImages(
      imagesToDelete: _urlPicturesToBeDeleted,
      onUploaded: (urlList) {
        updatePost(PostEnum.photos.name, urlList);
      },
      post: post,
    );
  }

  Future<void> _uploadPostData() async {
    _uploadingPostText(AppLocalizations.of(Get.context!).sendingData);
    await _postsRepository.uploadPostData(post: post);

    _uploadingPostText(AppLocalizations.of(Get.context!).finalizing);
    await Future.delayed(Duration(seconds: 1));

    _uploadingPostText('');
  }

  Future<void> _updatePostReference() async => await _postsRepository.updatePostReference(post: post);

  Future<void> increasePostViews([String? postId]) async {
    if (postId != null || (!isEditingPost && !isInReviewMode && !postBelongsToMe())) {
      await _postService.increasePostViews(postId ?? post.uid!);
    }
  }

  Future<void> increasePostSharedTimes() async {
    if (!isEditingPost && !isInReviewMode && !postBelongsToMe()) {
      await _postService.increasePostSharedTimes(post.uid!);
    }
  }

  Future<void> increasePostDennounces(String dennounceMotive) async {
    if (!isEditingPost && !isInReviewMode && !postBelongsToMe()) {
      List currentDennounces = post.dennounceMotives;
      List dennounceMotives = [...currentDennounces];

      dennounceMotives.add(dennounceMotive);

      await _postService.increasePostDennounces(post.uid!, dennounceMotives);
    }
  }

  Future<bool> showsCancelPostPopUp({bool isInsideFlow = false}) async {
    bool returnValue = false;

    await showPopUp(
      message: AppLocalizations.of(Get.context!).postCancelMessage,
      title: AppLocalizations.of(Get.context!).postCancelTitle,
      mainAction: () => Get.back(),
      confirmText: AppLocalizations.of(Get.context!).yes,
      barrierDismissible: false,
      denyText: AppLocalizations.of(Get.context!).no,
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
      backGroundColor: AppColors.danger,
    );

    return returnValue;
  }

  Future<void> sharePost() async {
    final success = await _share();

    if (!success) {
      crashlyticsController.reportAnError(
        message: AppLocalizations.of(Get.context!).unableToGenerateSharebleFile,
        exception: TiuTiuException(''),
      );

      showPopUp(
          message: AppLocalizations.of(Get.context!).unableToGenerateSharebleFile, backGroundColor: AppColors.danger);
    } else {
      increasePostSharedTimes();
    }
  }

  Future<bool> _share() async {
    setLoading(true, loadingText: AppLocalizations.of(Get.context!).preparingPostToShare);

    try {
      final String dynamicLinkPrefix = adminRemoteConfigController.configs.dynamicLinkPrefix;
      final String appStoreId = adminRemoteConfigController.configs.appStoreId;
      final String uriPrefix = adminRemoteConfigController.configs.uriPrefix;

      String? postFirstImage = await OtherFunctions.getPostImageToShare(post);

      TiuTiuDynamicLinkParameters parameters = PostUtils.generateParametersBasedOn(
        dynamicLinkPrefix: dynamicLinkPrefix,
        appStoreId: appStoreId,
        uriPrefix: uriPrefix,
        post: post,
      );

      String postText = await OtherFunctions.getPostTextToShare(
        tiuTiuDynamicLinkParameters: parameters,
        context: Get.context!,
      );

      setLoading(false);

      if (postFirstImage != null) {
        Share.shareXFiles([XFile(postFirstImage)],
            text: postText, sharePositionOrigin: Rect.fromLTWH(0, 0, Get.width, Get.height / 2));
      } else {
        Share.share(postText, sharePositionOrigin: Rect.fromLTWH(0, 0, Get.width, Get.height / 2));
      }

      return true;
    } catch (exception) {
      setLoading(false);

      crashlyticsController.reportAnError(
        message: 'An error ocurred when generating share link: $exception',
        exception: exception,
      );

      return false;
    }
  }

  void changeCardVisibilityKind() {
    if (cardVisibilityKind == CardVisibilityKind.card) {
      setCardVisibilityToDefaut();
    } else {
      _cardVisibilityKind(CardVisibilityKind.card);
    }
  }

  void setCardVisibilityToDefaut() {
    _cardVisibilityKind(CardVisibilityKind.banner);
  }

  void setLoading(bool loadingValue, {String loadingText = ''}) {
    _isLoading(loadingValue);
    _uploadingPostText(loadingText);
  }

  void _filterPosts() {
    final postsTofilter = isInMyPostsList ? loggedUserPosts() : _posts;
    _filteredPosts(PostUtils.filterPosts(postsList: postsTofilter, isInMyPostsList: isInMyPostsList));
    _postsCount(filteredPosts.length);
  }

  void updatePost(String property, dynamic data) {
    final postMap = _insertOwnerData(post.toMap());
    postMap[property] = data;

    if (kDebugMode) debugPrint('TiuTiuApp: updating post... $postMap');

    if (property == PetEnum.otherCaracteristics.name) {
      postMap[property] = _handlePetOtherCaracteristics(data);
    }

    _setPostStateAndCity(postMap);
    _insertLatLng(postMap);

    final newPost = Pet().fromMap(postMap);
    if (kDebugMode) debugPrint('TiuTiuApp: post updated $newPost');

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

    if (placemark.isoCountryCode == 'BR') {
      if (Platform.isAndroid) {
        city = placemark.subAdministrativeArea!;
        state = placemark.administrativeArea!;
      } else if (Platform.isIOS) {
        state = StatesAndCities.stateAndCities.getStateNameFromInitial(placemark.administrativeArea!);
        city = placemark.locality!;
      }
    } else {
      state = 'Acre';
      city = 'Acrelândia';
    }

    postMap[PostEnum.country.name] = systemController.properties.userCountryChoice;
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
        _formIsValid(validator.isStep4Valid());
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
    if (flowIndex < _FLOW_STEPS_QTY) _flowIndex(flowIndex + 1);
  }

  void previousStepFlow() {
    _postReviewed(false);
    _formIsValid(true);

    if (firstStep()) {
      Get.back();
    } else {
      _flowIndex(flowIndex - 1);
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
