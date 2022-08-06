import 'package:tiutiu/core/constants/strings.dart';
import 'package:get/get.dart';

class RefineSearchController extends GetxController {
  final RxList<String> _searchHomePetType = [
    RefineSearchStrings.all,
    RefineSearchStrings.dog,
    RefineSearchStrings.cat,
    RefineSearchStrings.bird,
    RefineSearchStrings.hamster,
    RefineSearchStrings.other,
  ].obs;

  final RxList<String> _searchHomeType = [
    RefineSearchStrings.type,
    RefineSearchStrings.petName,
    RefineSearchStrings.petBreed,
  ].obs;

  final RxString _searchHomePetTypeInitialValue = RefineSearchStrings.all.obs;
  final RxString _searchHomeTypeInitialValue = RefineSearchStrings.type.obs;
  final RxString _homePetTypeFilterByDisappeared = ''.obs;
  final RxBool _isHomeFilteringByDisappeared = false.obs;
  final RxString _homePetTypeFilterByDonate = ''.obs;
  final RxBool _isHomeFilteringByDonate = false.obs;
  final RxBool _searchPetByTypeOnHome = true.obs;
  final RxString _stateOfResultSearch = ''.obs;
  final RxString _distancieSelected = ''.obs;
  final RxString _healthSelected = ''.obs;
  final RxBool _isDisappeared = false.obs;
  final RxString _breedSelected = ''.obs;
  final RxString _sizeSelected = ''.obs;
  final RxString _sexSelected = ''.obs;
  final RxString _ageSelected = ''.obs;
  final RxInt _kindSelected = 0.obs;

  int get kindSelected => _kindSelected.value;
  String get breedSelected => _breedSelected.value;
  String get sexSelected => _sexSelected.value;
  String get sizeSelected => _sizeSelected.value;
  String get ageSelected => _ageSelected.value;
  String get healthSelected => _healthSelected.value;
  String get distancieSelected => _distancieSelected.value;
  bool get isDisappeared => _isDisappeared.value;
  bool get searchPetByTypeOnHome => _searchPetByTypeOnHome.value;
  List<String> get searchHomeType => _searchHomeType;
  List<String> get searchHomePetType => _searchHomePetType;
  String get searchHomePetTypeInitialValue =>
      _searchHomePetTypeInitialValue.value;
  String get searchHomeTypeInitialValue => _searchHomeTypeInitialValue.value;
  bool get isHomeFilteringByDonate => _isHomeFilteringByDonate.value;
  bool get isHomeFilteringByDisappeared => _isHomeFilteringByDisappeared.value;
  String get homePetTypeFilterByDonate => _homePetTypeFilterByDonate.value;
  String get homePetTypeFilterByDisappeared =>
      _homePetTypeFilterByDisappeared.value;
  String get stateOfResultSearch => _stateOfResultSearch.value;

  void changeDistancieSelected(String) => _distancieSelected;
  void changeHealthSelected(String) => _healthSelected;
  void changeBreedSelected(String) => _breedSelected;
  void changeSizeSelected(String) => _sizeSelected;
  void changeSexSelected(String) => _sexSelected;
  void changeAgeSelected(String) => _ageSelected;
  void changeKindSelected(int) => _kindSelected;

  void Function(bool) get changeSearchPetByTypeOnHome => _searchPetByTypeOnHome;
  void Function(String) get changeStateOfResultSearch => _stateOfResultSearch;
  void Function(String) get changeHomePetTypeFilterByDisappeared =>
      _homePetTypeFilterByDisappeared;
  void Function(String) get changeSearchHomePetTypeInitialValue =>
      _searchHomePetTypeInitialValue;
  void Function(String) get changeSearchHomeTypeInitialValue =>
      _searchHomeTypeInitialValue;
  void Function(bool) get changeIsHomeFilteringByDisappeared =>
      _isHomeFilteringByDisappeared;
  void Function(String) get changeHomePetTypeFilterByDonate =>
      _homePetTypeFilterByDonate;
  void Function(bool) get changeIsHomeFilteringByDonate =>
      _isHomeFilteringByDonate;

  void Function(bool) get changeIsDisappeared => _isDisappeared;

  void clearRefineSelections() {
    changeDistancieSelected('');
    changeHealthSelected('');
    changeBreedSelected('');
    changeSizeSelected('');
    changeAgeSelected('');
    changeSexSelected('');
  }
}
