import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  final Rx<LocationPermission> _permission = LocationPermission.denied.obs;
  final RxBool _locationServiceEnabled = false.obs;
  final Rx<LatLng> _location = LatLng(0, 0).obs;
  final RxBool _canContinue = false.obs;

  bool get locationServiceEnabled => _locationServiceEnabled.value;
  LocationPermission get permission => _permission.value;
  bool get canContinue => _canContinue.value;
  LatLng get location => _location.value;

  void Function(LocationPermission) get setPermission => _permission;
  void Function(bool) get changeCanContinue => _canContinue;
  void Function(bool) get changeLocationServiceEnabled =>
      _locationServiceEnabled;
  void Function(LatLng) get changeLocation => _location;

  Future<void> permissionCheck() async {
    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    setPermission(LocationPermission.always);
  }

  Future<void> permissionRequest() async {
    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    setPermission(LocationPermission.always);
  }

  Future<void> locationServiceIsEnabled() async {
    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    // changeLocationServiceEnabled(await isLocationServiceEnabled());
  }

  Future<bool> openSeetings() async {
    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    return true;
  }

  Future<bool> openLocalSettings() async {
    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    return true;
  }

  Future<void> setLocation({LatLng? currentLocation}) async {
    var position;

    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    if (currentLocation == null) {
      // position =
      // await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      changeLocation(LatLng(position.latitude, position.longitude));
    } else {
      changeLocation(currentLocation);
    }

    return Future.value();
  }
}
