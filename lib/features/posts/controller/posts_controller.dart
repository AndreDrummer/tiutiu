import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  final RxBool _isFullAddress = false.obs;
  final Rx<Pet> _Pet = Pet().obs;
  final RxInt _flowIndex = 0.obs;

  bool get isFullAddress => _isFullAddress.value;
  int get flowIndex => _flowIndex.value;
  Pet get pet => _Pet.value;

  void set flowIndex(int index) => _flowIndex(index);

  void updatePet(PetEnum property, dynamic data) {
    final petMap = pet.toMap();
    petMap[property.name] = data;

    print('>> $petMap');

    _Pet(Pet.fromMap(petMap));
  }

  void toggleFullAddress() {
    _isFullAddress(!isFullAddress);
  }
}
