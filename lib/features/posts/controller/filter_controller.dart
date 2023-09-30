import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/features/posts/model/filter_params.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  final Rx<FilterParams> filterParams = FilterParams(
    state: StatesAndCities.stateAndCities.stateInitials.first,
    orderBy: AppLocalizations.of(Get.context!)!.date,
    type: AppLocalizations.of(Get.context!)!.all,
    disappeared: false,
    name: '',
  ).obs;

  void updateParams(FilterParamsEnum property, dynamic data) {
    final paramMap = filterParams.value.toMap();
    paramMap[property.name] = data;

    final shoulRequestAccessToLocation = property == FilterParamsEnum.orderBy &&
        data == AppLocalizations.of(Get.context!)!.distance &&
        systemController.properties.accessLocationDenied;

    if (shoulRequestAccessToLocation) {
      _setLocation();
    }

    filterParams(FilterParams.fromMap(paramMap));
  }

  void reset([bool disappeared = false]) {
    filterParams(FilterParams(
      state: StatesAndCities.stateAndCities.stateInitials.first,
      orderBy: AppLocalizations.of(Get.context!)!.date,
      type: AppLocalizations.of(Get.context!)!.all,
      disappeared: disappeared,
      name: '',
    ));
  }

  FilterParams get getParams => filterParams.value;

  void clearName() {
    updateParams(FilterParamsEnum.name, '');
  }

  final List<String> filterTypeText = [
    AppLocalizations.of(Get.context!)!.all,
    AppLocalizations.of(Get.context!)!.dog,
    AppLocalizations.of(Get.context!)!.cat,
    AppLocalizations.of(Get.context!)!.bird,
    AppLocalizations.of(Get.context!)!.other,
  ];

  final List<IconData> filterTypeIcon = [
    FontAwesomeIcons.bullseye,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.cat,
    FontAwesomeIcons.kiwiBird,
    FontAwesomeIcons.staffSnake,
  ];

  List<String> orderTypeList(bool hasAccessToLocal) {
    final orderByOptions = [
      AppLocalizations.of(Get.context!)!.distance,
      AppLocalizations.of(Get.context!)!.date,
      AppLocalizations.of(Get.context!)!.age,
      AppLocalizations.of(Get.context!)!.name,
    ];

    return orderByOptions;
  }

  Future<void> _setLocation() async {
    systemController.setLoading(true);
    await currentLocationController.checkPermission();
    await currentLocationController.setUserLocation();
    systemController.setLoading(false);
  }
}
