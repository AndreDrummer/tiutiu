import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

enum LocationServiceStatus {
  active,
  deactivated,
}

class CurrentLocationController extends GetxController {
  final Rx<LocationPermission> _permission = LocationPermission.denied.obs;
  final Rx<LatLng> _currentLocation = LatLng(0, 0).obs;
  final Rx<LocationServiceStatus> _locationServiceStatus =
      LocationServiceStatus.deactivated.obs;
  final RxBool _canContinue = false.obs;

  LocationServiceStatus get locationServiceStatus =>
      _locationServiceStatus.value;
  LocationPermission get permission => _permission.value;
  bool get canContinue => _canContinue.value;
  LatLng get location => _currentLocation.value;

  void set permission(LocationPermission value) {
    _permission(value);
  }

  void set locationServiceEnabled(LocationServiceStatus status) {
    _locationServiceStatus(status);
  }

  void set location(LatLng value) {
    _currentLocation(value);
  }

  void set canContinue(bool value) {
    _canContinue(value);
  }

  Future<void> updateLocationServiceStatus() async {
    final isLocationServiceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (isLocationServiceEnabled) {
      _locationServiceStatus(LocationServiceStatus.active);
      // TODO: set user current location.
    } else {
      _locationServiceStatus(LocationServiceStatus.deactivated);
    }
    print(locationServiceStatus);
  }

  Future<void> handleLocationPermission() async {
    if (locationServiceStatus == LocationServiceStatus.deactivated) {
      await Geolocator.openLocationSettings();
    } else if (permission == LocationPermission.denied) {
      await Geolocator.openAppSettings();
    }

    await Geolocator.openLocationSettings();
  }

  Future<void> permissionCheck() async {
    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    permission = LocationPermission.always;
  }

  Future<void> permissionRequest() async {
    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    permission = LocationPermission.always;
  }

  Future<void> locationServiceIsEnabled() async {
    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    // changeLocationServiceEnabled(await isLocationServiceEnabled());
  }

  Future<bool> openAppLocalSettingPermissions() async {
    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    return true;
  }

  Future<bool> openDeviceLocalSettings() async {
    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    return true;
  }

  Future<void> setLocation({LatLng? currentLocation}) async {
    var position;

    // TODO: Ver depois como solicitar essa permissão de localização para o usuário!
    if (currentLocation == null) {
      // position =
      // await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      location = LatLng(position.latitude, position.longitude);
    } else {
      location = currentLocation;
    }

    return Future.value();
  }
}
