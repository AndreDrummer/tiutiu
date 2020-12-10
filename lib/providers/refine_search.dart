import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';

class RefineSearchProvider with ChangeNotifier {
  final _kindSelected = BehaviorSubject<int>.seeded(0);
  final _breedSelected = BehaviorSubject<String>.seeded('');
  final _sexSelected = BehaviorSubject<String>.seeded('');
  final _sizeSelected = BehaviorSubject<String>.seeded('');
  final _ageSelected = BehaviorSubject<String>.seeded('');
  final _healthSelected = BehaviorSubject<String>.seeded('');
  final _distancieSelected = BehaviorSubject<String>.seeded('');
  final _isDisappeared = BehaviorSubject<bool>.seeded(false);
  final _searchPetByTypeOnHome = BehaviorSubject<bool>.seeded(true);
  final _searchHomeType = BehaviorSubject<List<String>>.seeded(['Tipo', 'Nome do PET', 'Raça do PET']);
  final _searchHomePetType = BehaviorSubject<List<String>>.seeded(['Todos', 'Cachorro', 'Gato', 'Pássaro', 'Hamster', 'Outro']);
  final _searchHomePetTypeInitialValue = BehaviorSubject<String>.seeded('Todos');
  final _searchHomeTypeInitialValue = BehaviorSubject<String>.seeded('Tipo');

  final _isHomeFilteringByDonate = BehaviorSubject<bool>.seeded(false);
  final _isHomeFilteringByDisappeared = BehaviorSubject<bool>.seeded(false);

  final _homePetTypeFilterByDonate = BehaviorSubject<String>();
  final _homePetTypeFilterByDisappeared = BehaviorSubject<String>();

  final _stateOfResultSearch = BehaviorSubject<String>();

  Stream<int> get kindSelected => _kindSelected.stream;
  Stream<String> get breedSelected => _breedSelected.stream;
  Stream<String> get sexSelected => _sexSelected.stream;
  Stream<String> get sizeSelected => _sizeSelected.stream;
  Stream<String> get ageSelected => _ageSelected.stream;
  Stream<String> get healthSelected => _healthSelected.stream;
  Stream<String> get distancieSelected => _distancieSelected.stream;
  Stream<bool> get isDisappeared => _isDisappeared.stream;
  Stream<bool> get searchPetByTypeOnHome => _searchPetByTypeOnHome.stream;
  Stream<List<String>> get searchHomeType => _searchHomeType.stream;
  Stream<List<String>> get searchHomePetType => _searchHomePetType.stream;
  Stream<String> get searchHomePetTypeInitialValue => _searchHomePetTypeInitialValue.stream;
  Stream<String> get searchHomeTypeInitialValue => _searchHomeTypeInitialValue.stream;
  Stream<bool> get isHomeFilteringByDonate => _isHomeFilteringByDonate.stream;
  Stream<bool> get isHomeFilteringByDisappeared => _isHomeFilteringByDisappeared.stream;
  Stream<String> get homePetTypeFilterByDonate => _homePetTypeFilterByDonate.stream;
  Stream<String> get homePetTypeFilterByDisappeared => _homePetTypeFilterByDisappeared.stream;
  Stream<String> get stateOfResultSearch => _stateOfResultSearch.stream;

  void changeKindSelected(int kind) {
    _kindSelected.sink.add(kind);
    notifyListeners();
  }

  void changeSexSelected(String value) {
    _sexSelected.sink.add(value);
    notifyListeners();
  }

  void changeBreedSelected(String newList) {
    _breedSelected.sink.add(newList);
    notifyListeners();
  }

  void changeSizeSelected(String newList) {
    _sizeSelected.sink.add(newList);
    notifyListeners();
  }

  void changeAgeSelected(String newList) {
    _ageSelected.sink.add(newList);
    notifyListeners();
  }

  void changeHealthSelected(String newList) {
    _healthSelected.sink.add(newList);
    notifyListeners();
  }

  void changeDistancieSelected(String newList) {
    _distancieSelected.sink.add(newList);
    notifyListeners();
  }

  void Function(String) get changeSearchHomePetTypeInitialValue => _searchHomePetTypeInitialValue.sink.add;
  void Function(String) get changeSearchHomeTypeInitialValue => _searchHomeTypeInitialValue.sink.add;
  void Function(bool) get changeSearchPetByTypeOnHome => _searchPetByTypeOnHome.sink.add;
  void Function(bool) get changeIsHomeFilteringByDonate => _isHomeFilteringByDonate.sink.add;
  void Function(bool) get changeIsHomeFilteringByDisappeared => _isHomeFilteringByDisappeared.sink.add;
  void Function(String) get changeHomePetTypeFilterByDonate => _homePetTypeFilterByDonate.sink.add;
  void Function(String) get changeHomePetTypeFilterByDisappeared => _homePetTypeFilterByDisappeared.sink.add;
  void Function(String) get changeStateOfResultSearch => _stateOfResultSearch.sink.add;

  void loadCityByState(String stateInitial) async {
    try {
      Response response = await Dio().get('https://servicodados.ibge.gov.br/api/v1/localidades/estados/${stateInitial.toLowerCase()}/municipios');
      print(response);
    } catch (e) {
      print(e);
    }
  }

  void changeIsDisappeared(bool newValue) {
    _isDisappeared.sink.add(newValue);
    notifyListeners();
  }

  void clearRefineSelections() {
    changeBreedSelected('');
    changeSizeSelected('');
    changeAgeSelected('');
    changeHealthSelected('');
    changeSexSelected('');
    changeDistancieSelected('');
  }

  int get getKindSelected => _kindSelected.stream.value;
  String get getBreedSelected => _breedSelected.stream.value;
  String get getSexSelected => _sexSelected.stream.value;
  String get getSizeSelected => _sizeSelected.stream.value;
  String get getAgeSelected => _ageSelected.stream.value;
  String get getHealthSelected => _healthSelected.stream.value;
  String get getDistancieSelected => _distancieSelected.stream.value;
  bool get getIsDisappeared => _isDisappeared.stream.value;
  bool get getSearchPetByTypeOnHome => _searchPetByTypeOnHome.stream.value;
  List<String> get getSearchHomeType => _searchHomeType.value;
  List<String> get getSearchHomePetType => _searchHomePetType.value;
  String get getSearchHomePetTypeInitialValue => _searchHomePetTypeInitialValue.value;
  String get getSearchHomeTypeInitialValue => _searchHomeTypeInitialValue.value;
  bool get getIsHomeFilteringByDonate => _isHomeFilteringByDonate.value;
  bool get getIsHomeFilteringByDisappeared => _isHomeFilteringByDisappeared.value;
  String get getHomePetTypeFilterByDonate => _homePetTypeFilterByDonate.value;
  String get getHomePetTypeFilterByDisappeared => _homePetTypeFilterByDisappeared.value;
  String get getStateOfResultSearch => _stateOfResultSearch.value;
}
