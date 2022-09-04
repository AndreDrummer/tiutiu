import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:get/get.dart';
import 'package:tiutiu/core/models/filter_params.dart';

class FilterController extends GetxController {
  final RxString _searchHomeTypeInitialValue = FilterStrings.type.obs;
  final RxString _filterTypeTextSelected = FilterStrings.all.obs;

  final RxString _homePetTypeFilterByDisappeared = ''.obs;
  final RxBool _isHomeFilteringByDisappeared = false.obs;
  final RxString _homePetTypeFilterByDonate = ''.obs;
  final RxBool _isHomeFilteringByDonate = false.obs;
  final RxBool _searchPetByTypeOnHome = true.obs;
  final RxString _stateOfResultSearch = ''.obs;
  final RxString _distancieSelected = ''.obs;
  final RxString _genderSelected = ''.obs;
  final RxString _healthSelected = ''.obs;
  final RxBool _isDisappeared = false.obs;
  final RxString _breedSelected = ''.obs;
  final RxString _sizeSelected = ''.obs;
  final RxString _ageSelected = ''.obs;
  final RxInt _typeSelected = 0.obs;

  bool get isHomeFilteringByDisappeared => _isHomeFilteringByDisappeared.value;
  String get searchHomeTypeInitialValue => _searchHomeTypeInitialValue.value;
  String get homePetTypeFilterByDonate => _homePetTypeFilterByDonate.value;
  String get filterTypeTextSelected => _filterTypeTextSelected.value;
  bool get isHomeFilteringByDonate => _isHomeFilteringByDonate.value;
  bool get searchPetByTypeOnHome => _searchPetByTypeOnHome.value;
  String get stateOfResultSearch => _stateOfResultSearch.value;
  String get distancieSelected => _distancieSelected.value;
  String get healthSelected => _healthSelected.value;
  String get genderSelected => _genderSelected.value;
  String get breedSelected => _breedSelected.value;
  String get sizeSelected => _sizeSelected.value;
  bool get isDisappeared => _isDisappeared.value;
  String get ageSelected => _ageSelected.value;
  int get typeSelected => _typeSelected.value;
  String get homePetTypeFilterByDisappeared =>
      _homePetTypeFilterByDisappeared.value;

  void set homePetTypeFilterByDisappeared(String value) {
    _homePetTypeFilterByDisappeared(value);
  }

  void set isHomeFilteringByDisappeared(bool value) {
    _isHomeFilteringByDisappeared(value);
  }

  void set searchHomeTypeInitialValue(String value) {
    _searchHomeTypeInitialValue(value);
  }

  void set filterTypeTextSelected(String value) {
    _filterTypeTextSelected(value);
  }

  void set homePetTypeFilterByDonate(String value) {
    _homePetTypeFilterByDonate(value);
  }

  void set isHomeFilteringByDonate(bool value) {
    _isHomeFilteringByDonate(value);
  }

  void set searchPetByTypeOnHome(bool value) {
    _searchPetByTypeOnHome(value);
  }

  void set stateOfResultSearch(String value) {
    _stateOfResultSearch(value);
  }

  void set distancieSelected(String value) {
    _distancieSelected(value);
  }

  void set healthSelected(String value) {
    _healthSelected(value);
  }

  void set genderSelected(String value) {
    _genderSelected(value);
  }

  void set breedSelected(String value) {
    _breedSelected(value);
  }

  void set sizeSelected(String value) {
    _sizeSelected(value);
  }

  void set isDisappeared(bool value) {
    _isDisappeared(value);
  }

  void set ageSelected(String value) {
    _ageSelected(value);
  }

  void set typeSelected(int value) {
    _typeSelected(value);
  }

  void clearRefineSelections() {
    distancieSelected = '';
    genderSelected = '';
    healthSelected = '';
    breedSelected = '';
    sizeSelected = '';
    ageSelected = '';
  }

  FilterParams filterParams() {
    return FilterParams(type: filterTypeTextSelected);
  }

  final List<String> filterTypeText = [
    FilterStrings.all,
    FilterStrings.dog,
    FilterStrings.cat,
    FilterStrings.disappeared,
    FilterStrings.bird,
    FilterStrings.exotic,
  ];

  final List<IconData> filterTypeIcon = [
    FontAwesomeIcons.bullseye,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.question,
    FontAwesomeIcons.kiwiBird,
    Tiutiu.hamster,
  ];
}
