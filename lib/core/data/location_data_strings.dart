import 'package:tiutiu/core/models/location_model.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

enum DataStringsKeys {
  name,
  initial,
}

class DataLocalStrings {
  factory DataLocalStrings() => _dataLocalStrings;
  DataLocalStrings.internal();
  static DataLocalStrings _dataLocalStrings = DataLocalStrings.internal();

  late UFLocation location;

  Future<void> getUFAndCities() async {
    const String locationJson = 'assets/json/estados-cidades.json';
    var jsonFile = await rootBundle.loadString(locationJson);
    location = UFLocation.fromMap(jsonDecode(jsonFile));
  }

  String get fisrtStateName => location.states.first.name;
  List<String> get stateNames => location.states.map((e) => e.name).toList();

  List<String> citiesOf({String stateName = 'Todos'}) {
    return location.states
        .where((state) => state.name == stateName)
        .first
        .cities
        .map((citieName) => citieName.toString())
        .toList();
  }

  List<String> get stateInitials =>
      location.states.map((e) => e.initial).toList();
}
