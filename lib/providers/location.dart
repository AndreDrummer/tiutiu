import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location with ChangeNotifier {
  LatLng _location;

  LatLng get location => _location;

  Future<void> setLocation({LatLng currentLocation}) async {

    if(currentLocation == null) {
      var position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _location = LatLng(position.latitude, position.longitude);
    } else {
      _location = currentLocation;
    } 

    notifyListeners();
  }



}