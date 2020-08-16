import 'package:google_maps_webservice/geocoding.dart';

class GeocodingModel {

  GeocodingModel({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.partialMatch,
    this.placeId,
    this.postcodeLocalities,
    this.types,
  });

  GeocodingModel.fromSnapshot(GeocodingResult  snapshot) {
    addressComponents = snapshot.addressComponents;
    formattedAddress = snapshot.formattedAddress;
    geometry = snapshot.geometry;
    partialMatch = snapshot.partialMatch;
    placeId = snapshot.placeId;
    postcodeLocalities = snapshot.postcodeLocalities;
    types = snapshot.types;
  }

  Map<dynamic, dynamic> toMap() {
    var map = {};
    map.putIfAbsent('addressComponents', () => addressComponents);
    map.putIfAbsent('formattedAddress', () => formattedAddress);
    map.putIfAbsent('geometry', () => geometry);
    map.putIfAbsent('partialMatch', () => partialMatch);
    map.putIfAbsent('placeId', () => placeId);
    map.putIfAbsent('postcodeLocalities', () => postcodeLocalities);
    map.putIfAbsent('types', () => types);
    return map;
  }

  Map<String, dynamic> toJson() {
    return {
      'addressComponents': addressComponents,
      'formattedAddress': formattedAddress,
      'geometry': geometry,
      'partialMatch': partialMatch,
      'placeId': placeId,
      'postcodeLocalities': postcodeLocalities,
      'types': types,
    };
  }

  List<AddressComponent> addressComponents;
  String formattedAddress;
  Geometry geometry;
  bool partialMatch;
  String placeId;
  List<String> postcodeLocalities;
  List<String> types;
}
