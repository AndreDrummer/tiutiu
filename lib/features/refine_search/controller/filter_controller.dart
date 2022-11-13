import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/data/states_and_cities.dart';
import 'package:tiutiu/core/models/filter_params.dart';
import 'package:tiutiu/core/constants/strings.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  final Rx<FilterParams> filterParams = FilterParams(
    state: StatesAndCities().stateInitials.first,
    orderBy: FilterStrings.distance,
    type: PetTypeStrings.all,
    disappeared: false,
    name: '',
  ).obs;

  void updateParams(FilterParamsEnum property, dynamic data) {
    final paramMap = filterParams.value.toMap();
    paramMap[property.name] = data;

    filterParams(FilterParams.fromMap(paramMap));
  }

  FilterParams get getParams => filterParams.value;

  void clearName() {
    updateParams(FilterParamsEnum.name, '');
  }

  final List<String> filterTypeText = [
    PetTypeStrings.all,
    PetTypeStrings.dog,
    PetTypeStrings.cat,
    PetTypeStrings.bird,
    PetTypeStrings.exotic,
  ];

  final List<IconData> filterTypeIcon = [
    FontAwesomeIcons.bullseye,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.kiwiBird,
    FontAwesomeIcons.staffSnake,
  ];

  final List<String> orderTypeList = [
    'Distância',
    'Data',
    'Idade',
    'Nome',
  ];
}
