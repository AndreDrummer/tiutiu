import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

class Location with ChangeNotifier {  
  final _permission = BehaviorSubject<LocationPermission>();
  final _location = BehaviorSubject<LatLng>();  

  Stream<LatLng> get location => _location.stream;
  Stream<LocationPermission> get permission => _permission.stream;
  
  void Function(LocationPermission) get changePermission => _permission.sink.add;
  void Function(LatLng) get changeLocation => _location.sink.add;

  LocationPermission get getPermission => _permission.stream.value;
  LatLng get getLocation => _location.stream.value;

  Future<void> permissionCheck() async {
    final permission = await checkPermission();    
    changePermission(permission);
  }

  Future<void > permissionRequest() async {
    final permission = await requestPermission();
    changePermission(permission);    
  }

  Future<bool> openSeetings() async {
    return await openAppSettings();
  }

  Future<void> setLocation({LatLng currentLocation}) async {
      var position;
      
    if(currentLocation == null) {    
      position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      changeLocation(LatLng(position.latitude, position.longitude));
    } else {
      changeLocation(currentLocation);
    } 
     
    notifyListeners();
    return Future.value();
  }



}