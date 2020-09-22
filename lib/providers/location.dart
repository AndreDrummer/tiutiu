import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Location with ChangeNotifier {
  LatLng _location;

  LatLng get location => _location;

  Future<void> setLocation({LatLng currentLocation}) async {
      var position;
      
    if(currentLocation == null) {    
      position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _location = LatLng(position.latitude, position.longitude);
    } else {
      _location = currentLocation;
    } 

    print("Localização atual $position");    
    notifyListeners();
    return Future.value();
  }



}