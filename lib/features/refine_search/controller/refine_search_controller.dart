import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  final RxString _filterKindTextSelected = RefineSearchStrings.all.obs;
  final RxString _searchHomeTypeInitialValue = RefineSearchStrings.type.obs;
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
  final RxInt _kindSelected = 0.obs;

  bool get isHomeFilteringByDisappeared => _isHomeFilteringByDisappeared.value;
  String get searchHomeTypeInitialValue => _searchHomeTypeInitialValue.value;
  String get filterKindTextSelected => _filterKindTextSelected.value;
  String get homePetTypeFilterByDonate => _homePetTypeFilterByDonate.value;
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
  int get kindSelected => _kindSelected.value;
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

  void set filterKindTextSelected(String value) {
    _filterKindTextSelected(value);
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

  void set kindSelected(int value) {
    _kindSelected(value);
  }

  void clearRefineSelections() {
    distancieSelected = '';
    genderSelected = '';
    healthSelected = '';
    breedSelected = '';
    sizeSelected = '';
    ageSelected = '';
  }

  final List<String> filterKindText = [
    RefineSearchStrings.all,
    RefineSearchStrings.dog,
    RefineSearchStrings.cat,
    RefineSearchStrings.bird,
    RefineSearchStrings.hamster,
    RefineSearchStrings.other,
  ];

  final List<IconData> filterKindIcon = [
    FontAwesomeIcons.bullseye,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.kiwiBird,
    Tiutiu.hamster,
    FontAwesomeIcons.question,
  ];
}
