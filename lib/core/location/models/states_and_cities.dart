import 'package:tiutiu/core/location/models/location_model.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

enum DataStringsKeys {
  name,
  initial,
}

class StatesAndCities {
  StatesAndCities.internal();
  static StatesAndCities stateAndCities = StatesAndCities.internal();

  late UFLocation location;

  Future<void> getUFAndCities() async {
    var jsonFile = await rootBundle.loadString(JsonAssets.ufAndCities);
    location = UFLocation.fromMap(jsonDecode(jsonFile));
  }

  String getStateNameFromInitial(String ufInitial) {
    return stateNames.elementAt(StatesAndCities.stateAndCities.stateInitials.indexOf(ufInitial));
  }

  String get fisrtStateName => location.states.first.name;
  List<String> get stateNames => location.states.map((e) => e.name).toList();

  List<String> citiesOf({String stateName = 'Acre'}) {
    final states = location.states;
    final statesName = states.map((e) => e.name).toList();
    final stateNameExists = statesName.contains(stateName);

    final stateNameToSearch = stateNameExists ? stateName : 'Acre';

    return states
        .firstWhere((state) => state.name == stateNameToSearch)
        .cities
        .map((citieName) => citieName.toString())
        .toList();
  }

  List<String> get stateInitials => location.states.map((e) => e.initial).toList();
}
