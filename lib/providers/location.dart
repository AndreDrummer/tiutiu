import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location with ChangeNotifier {
  LatLng _location;

  LatLng get location => _location;

  void setLocation(LatLng currentLocation) {

    _location = currentLocation;

    notifyListeners();
  }
}