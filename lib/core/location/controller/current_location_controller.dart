import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/location/models/latlng.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:io';

class CurrentLocationController extends GetxController {
  final Rx<LocationPermission> _permission = LocationPermission.unableToDetermine.obs;
  final Rx<Placemark> _currentPlacemark = Placemark().obs;
  final Rx<LatLng> _currentLocation = LatLng(0, 0).obs;
  final RxBool _isPermissionGranted = false.obs;
  final RxBool _canContinue = false.obs;

  bool get isPermissionGranted => _isPermissionGranted.value;
  Placemark get currentPlacemark => _currentPlacemark.value;
  LocationPermission get permission => _permission.value;
  LatLng get location => _currentLocation.value;
  bool get canContinue => _canContinue.value;

  void set currentPlacemark(Placemark placemark) {
    _currentPlacemark(placemark);
  }

  void set permission(LocationPermission value) {
    _permission(value);
  }

  void set location(LatLng value) {
    _currentLocation(value);
  }

  void set isPermissionGranted(bool value) {
    _isPermissionGranted(value);
  }

  void set canContinue(bool value) {
    _canContinue(value);
  }

  Future<void> checkPermission() async {
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      isPermissionGranted = true;
    }
  }

  Future<void> updatePermission() async {
    permission = await Geolocator.requestPermission();
    setUserLocation();

    if (kDebugMode) debugPrint('TiuTiuApp: local access permission $permission');
  }

  Future<void> openDeviceSettings() async => await Geolocator.openLocationSettings();

  Future<void> setUserLocation({LatLng? currentLocation}) async {
    await checkPermission();
    if (isPermissionGranted) {
      if (currentLocation == null) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        location = LatLng(position.latitude, position.longitude);
      } else {
        location = currentLocation;
      }

      Placemark placemark = Placemark();

      try {
        final placemarkList = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        placemark = placemarkList.first;

        LocalStorage.setValueUnderLocalStorageKey(
          key: LocalStorageKey.lastKnowLocation,
          value: placemark.toJson(),
        );
      } catch (e) {
        crashlyticsController.reportAnError(
          message: 'An failure occured when trying set up current placemark.\n',
          exception: e,
        );
        final storagePlacemark = await LocalStorage.getValueUnderLocalStorageKey(LocalStorageKey.lastKnowLocation);
        if (storagePlacemark != null) {
          placemark = Placemark.fromMap(storagePlacemark);
          if (kDebugMode) debugPrint('TiuTiuApp: A storaged placemark is being used instead.');
        }
      }

      currentPlacemark = placemark;
    }
  }

  bool hasAValidPlacemark() {
    bool isValid = false;

    isValid = currentPlacemark.subAdministrativeArea.isNotEmptyNeighterNull() &&
        currentPlacemark.administrativeArea.isNotEmptyNeighterNull();

    if (Platform.isAndroid) {
      return isValid;
    } else {
      return isValid && currentPlacemark.locality.isNotEmptyNeighterNull();
    }
  }
}
