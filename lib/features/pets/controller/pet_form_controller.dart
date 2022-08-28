import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:get/get.dart';

class PetFormController extends GetxController {
  final RxList _petSelectedCaracteristics = [].obs;
  final RxString _petSize = 'Pequeno-porte'.obs;
  final RxString _petColor = 'Abóbora'.obs;
  final Rx<Pet> _petInEdition = Pet().obs;
  final RxString _petDescription = ''.obs;
  final RxString _petSex = 'Macho'.obs;
  final RxInt _petHealthIndex = 0.obs;
  final RxInt _petBreedIndex = 0.obs;
  final RxInt _petTypeIndex = 0.obs;
  final RxList _petPhotos = [].obs;
  final RxString _petName = ''.obs;
  final RxString _petKind = ''.obs;
  final RxInt _petMonths = 0.obs;
  final RxInt _petAge = 0.obs;

  List get petSelectedCaracteristics => _petSelectedCaracteristics;
  String get petDescription => _petDescription.value;
  int get petHealthIndex => _petHealthIndex.value;
  int get petBreedIndex => _petBreedIndex.value;
  int get petTypeIndex => _petTypeIndex.value;
  Pet get petInEdition => _petInEdition.value;
  String get petColor => _petColor.value;
  int get petMonths => _petMonths.value;
  String get petName => _petName.value;
  String get petKind => _petKind.value;
  String get petSize => _petSize.value;
  String get petSex => _petSex.value;
  List get petPhotos => _petPhotos;
  int get petAge => _petAge.value;

  void set petSelectedCaracteristics(List list) =>
      _petSelectedCaracteristics(list);
  void set petDescription(String value) => _petDescription(value);
  void set petHealthIndex(int value) => _petHealthIndex(value);
  void set petBreedIndex(int value) => _petBreedIndex(value);
  void set petTypeIndex(int value) => _petTypeIndex(value);
  void set petInEdition(Pet value) => _petInEdition(value);
  void set petColor(String value) => _petColor(value);
  void set petPhotos(List value) => _petPhotos(value);
  void set petMonths(int value) => _petMonths(value);
  void set petName(String value) => _petName(value);
  void set petKind(String value) => _petKind(value);
  void set petSize(String value) => _petSize(value);
  void set petSex(String value) => _petSex(value);
  void set petAge(int value) => _petAge(value);

  List _subjects() {
    return [petName, petAge, petMonths, petDescription, petPhotos];
  }

  bool formIsvalid() {
    bool formStatus = true;
    List newList = _subjects();
    if (petKind != FirebaseEnvPath.donate) newList.removeAt(1);

    for (BehaviorSubject subject in newList) {
      if (subject.value == null || subject.value == "") {
        subject.addError("* Campo obrigatório");
        formStatus = false;
      }

      if (subject.value.runtimeType == int && subject.value < 0) {
        subject.addError("* Campo obrigatório");
        formStatus = false;
      }
    }

    return formStatus;
  }

  @override
  void dispose() {
    _petSelectedCaracteristics.close();
    _petHealthIndex.close();
    _petDescription.close();
    _petBreedIndex.close();
    _petInEdition.close();
    _petTypeIndex.close();
    _petMonths.close();
    _petColor.close();
    _petName.close();
    _petKind.close();
    _petSize.close();
    _petSex.close();
    _petAge.close();
    super.dispose();
  }
}
