import 'package:tiutiu/features/posts/validators/form_validators.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

const int FLOW_STEPS_QTY = 7;

class PostsController extends GetxController {
  final RxString _uploadingAdText = ''.obs;
  final RxBool _isFullAddress = false.obs;
  final RxInt _postPhotoFrameQty = 1.obs;
  final RxBool _formIsValid = true.obs;
  final RxBool _hasError = false.obs;
  final Rx<Pet> _post = Pet().obs;
  final RxInt _flowIndex = 0.obs;

  bool get existChronicDiseaseInfo =>
      _post.value.health == PetHealthString.chronicDisease;
  int get postPhotoFrameQty => _postPhotoFrameQty.value;
  String get uploadingAdText => _uploadingAdText.value;
  bool get isFullAddress => _isFullAddress.value;
  bool get formIsInInitialState => post == Pet();
  bool get formIsValid => _formIsValid.value;
  int get flowIndex => _flowIndex.value;
  bool get hasError => _hasError.value;
  Pet get post => _post.value;

  void setError(String errorMessage) {
    _uploadingAdText(errorMessage);
    _hasError(true);
  }

  void clearError() {
    _uploadingAdText('');
    _hasError(false);
  }

  void increasePhotosQty() {
    if (postPhotoFrameQty < 6) _postPhotoFrameQty(postPhotoFrameQty + 1);
  }

  void decreasePhotosQty() {
    if (postPhotoFrameQty > 1) _postPhotoFrameQty(postPhotoFrameQty - 1);
  }

  void updatePet(PetEnum property, dynamic data) {
    final postMap = _insertOwnerData(post.toMap());
    postMap[property.name] = data;

    if (property == PetEnum.otherCaracteristics) {
      postMap[property.name] = _handlePetOtherCaracteristics(data);
    }

    if ((post.latitude == null || post.longitude == null)) {
      _insertLatLng(postMap);
    }

    print('>> $postMap');

    _post(Pet.fromMap(postMap));
  }

  void _insertLatLng(Map<String, dynamic> postMap) {
    postMap[PetEnum.longitude.name] =
        currentLocationController.location.longitude;
    postMap[PetEnum.latitude.name] =
        currentLocationController.location.latitude;
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

  void onContinue() {
    PostFormValidator validator = PostFormValidator(post);
    // nextStep();

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
        petsController.pet = Pet.fromMap(post.toMap());
        debugPrint(post.toString());
        debugPrint(petsController.pet.toString());
        break;
      case 6:
        break;
    }

    if (formIsValid) nextStep();
  }

  void clearForm() {
    _isFullAddress(false);
    _formIsValid(true);
    _post(Pet());
  }

  void nextStep() {
    if (flowIndex < FLOW_STEPS_QTY) _flowIndex(flowIndex + 1);
  }

  void previousStep() {
    if (flowIndex == 0) {
      clearForm();
      homeController.bottomBarIndex = 0;
    } else
      _flowIndex(flowIndex - 1);
  }

  void toggleFullAddress() {
    _isFullAddress(!isFullAddress);
  }
}
