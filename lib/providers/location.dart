import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Location with ChangeNotifier {
  LatLng _location;

  LatLng get location => _location;

  Future<LocationPermission > permissionCheck() async {
    final permission = await checkPermission();
    print("PER $permission");
    return permission;
  }

  Future<LocationPermission > permissionRequest() async {
    final permission = await requestPermission();
    print("PER $permission");
    return permission;
  }

  Future<bool> openSeetings() async {
    return await openAppSettings();
  }

  Future<void> setLocation({LatLng currentLocation}) async {
      var position;
      
    if(currentLocation == null) {    
      position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _location = LatLng(position.latitude, position.longitude);
    } else {
      _location = currentLocation;
    } 
     
    notifyListeners();
    return Future.value();
  }



}