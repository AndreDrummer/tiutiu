class GeocodingModel {
  GeocodingModel({
    required this.postcodeLocalities,
    required this.addressComponents,
    required this.formattedAddress,
    required this.partialMatch,
    required this.geometry,
    required this.placeId,
    required this.types,
  });

  GeocodingModel.fromSnapshot(GeocodingResult snapshot) {
    GeocodingModel(
      postcodeLocalities: null,
      addressComponents: null,
      formattedAddress: null,
      partialMatch: null,
      geometry: null,
      placeId: null,
      types: null,
    );
  }

  Map<dynamic, dynamic> toMap() {
    var map = {};
    map.putIfAbsent('postcodeLocalities', () => postcodeLocalities);
    map.putIfAbsent('addressComponents', () => addressComponents);
    map.putIfAbsent('formattedAddress', () => formattedAddress);
    map.putIfAbsent('partialMatch', () => partialMatch);
    map.putIfAbsent('geometry', () => geometry);
    map.putIfAbsent('placeId', () => placeId);
    map.putIfAbsent('types', () => types);
    return map;
  }

  Map<String, dynamic> toJson() {
    return {
      'postcodeLocalities': postcodeLocalities,
      'addressComponents': addressComponents,
      'formattedAddress': formattedAddress,
      'partialMatch': partialMatch,
      'geometry': geometry,
      'placeId': placeId,
      'types': types,
    };
  }

  List<AddressComponent>? addressComponents;
  List<String>? postcodeLocalities;
  String? formattedAddress;
  List<String>? types;
  Geometry? geometry;
  bool? partialMatch;
  String? placeId;
}

class Geometry {}

class AddressComponent {}

class GeocodingResult {
  List<AddressComponent> get addressComponents => [];
  List<String> get postcodeLocalities => [];
  Geometry get geometry => Geometry();
  String get formattedAddress => '';
  bool get partialMatch => false;
  List<String> get types => [];
  String get placeId => '';
}
