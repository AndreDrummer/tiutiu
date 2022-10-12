import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/data/states_and_cities.dart';
import 'package:tiutiu/core/models/filter_params.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  final RxString _filterStateSelected =
      StatesAndCities().stateInitials.first.obs;
  final RxString _filterTypeTextSelected = FilterStrings.all.obs;
  final RxString _orderBy = FilterStrings.distance.obs;
  final RxString _filterByName = ''.obs;

  String get filterTypeTextSelected => _filterTypeTextSelected.value;
  String get filterStateSelected => _filterStateSelected.value;
  String get filterByName => _filterByName.value;
  String get orderBy => _orderBy.value;

  void set filterStateSelected(String? stateName) {
    _filterStateSelected(stateName ?? filterStateSelected);
  }

  void set filterTypeTextSelected(String type) {
    _filterTypeTextSelected(type);
  }

  void set orderBy(String orderParam) {
    _orderBy(orderParam);
  }

  void set filterByName(String name) {
    _filterByName(name);
  }

  void clearName() {
    filterByName = '';
  }

  FilterParams filterParams({bool disappeared = false}) {
    return FilterParams(
      type: filterTypeTextSelected,
      state: filterStateSelected,
      disappeared: disappeared,
    );
  }

  final List<String> filterTypeText = [
    FilterStrings.all,
    FilterStrings.dog,
    FilterStrings.cat,
    FilterStrings.bird,
    FilterStrings.exotic,
  ];

  final List<IconData> filterTypeIcon = [
    FontAwesomeIcons.bullseye,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.kiwiBird,
    Tiutiu.hamster,
  ];

  final List<String> orderTypeList = [
    'Distância',
    'Data',
    'Idade',
    'Nome',
  ];
}
