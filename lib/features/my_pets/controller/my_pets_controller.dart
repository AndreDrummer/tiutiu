import 'package:get/get.dart';
import 'package:tiutiu/features/my_pets/services/my_pets_service.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';

class MyPetsController extends GetxController {
  MyPetsController(MyPetsService myPetsService)
      : _myPetsService = myPetsService;

  final RxList<Pet> _myPetsDisappeareds = <Pet>[].obs;
  final RxList<Pet> _myPetsToDonate = <Pet>[].obs;

  List<Pet> get myPetsDisappeareds => _myPetsDisappeareds;
  List<Pet> get myPetsToDonate => _myPetsToDonate;

  final MyPetsService _myPetsService;

  Future<void> loadMyPetsDisappeareds() async {
    _myPetsDisappeareds(
      await _myPetsService.loadMyPetsDisappeareds('myUserId'),
    );
  }

  Future<void> loadMyPetsToDonate() async {
    _myPetsToDonate(
      await _myPetsService.loadMyPetsToDonate('myUserId'),
    );
  }
}
