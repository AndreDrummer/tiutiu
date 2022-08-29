import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tiutiu/features/location/extensions/service_location_status.dart';

class CurrentLocationController extends GetxController {
  final Rx<LocationPermission> _permission = LocationPermission.denied.obs;
  final Rx<GPSStatus> _gpsStatus = GPSStatus.deactivated.obs;
  final Rx<LatLng> _currentLocation = LatLng(0, 0).obs;
  final RxBool _canContinue = false.obs;

  LocationPermission get permission => _permission.value;
  LatLng get location => _currentLocation.value;
  GPSStatus get gpsStatus => _gpsStatus.value;
  bool get canContinue => _canContinue.value;

  void set permission(LocationPermission value) {
    _permission(value);
  }

  void set locationServiceEnabled(GPSStatus status) {
    _gpsStatus(status);
  }

  void set location(LatLng value) {
    _currentLocation(value);
  }

  void set canContinue(bool value) {
    _canContinue(value);
  }

  Future<void> updateGPSStatus() async {
    final isLocationServiceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (isLocationServiceEnabled) {
      _gpsStatus(GPSStatus.active);
    } else {
      _gpsStatus(GPSStatus.deactivated);
    }
  }

  Future<void> checkPermission() async {
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {}
  }

  Future<void> updatePermission() async {
    permission = await Geolocator.requestPermission();
  }

  Future<void> handleLocationPermission() async {
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    } else {
      updatePermission();
    }
  }

  Future<void> openDeviceSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> setUserLocation({LatLng? currentLocation}) async {
    var position;

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
