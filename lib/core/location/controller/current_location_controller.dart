import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/location/models/latlng.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:io';

class CurrentLocationController extends GetxController {
  final Rx<PermissionStatus> _permissionStatus = PermissionStatus.denied.obs;
  final Rx<Placemark> _currentPlacemark = Placemark().obs;
  final Rx<LatLng> _currentLocation = LatLng(0, 0).obs;
  final RxBool _isPermissionGranted = false.obs;
  final RxBool _canContinue = false.obs;

  PermissionStatus get permissionStatus => _permissionStatus.value;
  bool get isPermissionGranted => _isPermissionGranted.value;
  Placemark get currentPlacemark => _currentPlacemark.value;
  LatLng get location => _currentLocation.value;
  bool get canContinue => _canContinue.value;

  void set currentPlacemark(Placemark placemark) {
    _currentPlacemark(placemark);
  }

  Future<void> setPermission(PermissionStatus value) async {
    _permissionStatus(value);
    await LocalStorage.setValueUnderLocalStorageKey(
      key: LocalStorageKey.userLocationDecision,
      value: value.name,
    );
    await systemController.updateAccessToLocationWasDenied();
  }

  void set location(LatLng value) {
    _currentLocation(value);
  }

  void setPermissionGranted(bool value) {
    _isPermissionGranted(value);
  }

  void set canContinue(bool value) {
    _canContinue(value);
  }

  PermissionStatus? _getPermissionStatusFromString(
      String? permissionStatusString) {
    if (permissionStatusString != null)
      return PermissionStatus.values
          .where((permission) => permission.name == permissionStatusString)
          .first;
    return null;
  }

  Future<PermissionStatus?> getLastLocationPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final cachedPermissionString =
          await LocalStorage.getValueUnderLocalStorageKey(
        LocalStorageKey.userLocationDecision,
      );

      final PermissionStatus? cachedPermissionStatus =
          _getPermissionStatusFromString(cachedPermissionString);

      if (cachedPermissionStatus == null) return cachedPermissionStatus;

      setPermission(await Permission.location.status);
      setPermissionGranted(permissionStatus == PermissionStatus.granted);

      return permissionStatus;
    } else {
      return PermissionStatus.provisional;
    }
  }

  Future<void> checkPermission() async {
    setPermission(await Permission.location.request());

    setPermissionGranted(permissionStatus == PermissionStatus.granted);
  }

  Future<void> updatePermission() async {
    setPermission(await Permission.location.request());
    setUserLocation();

    if (kDebugMode)
      debugPrint('TiuTiuApp: local access permission $permissionStatus');
  }

  Future<void> openDeviceSettings() async =>
      await Geolocator.openLocationSettings();

  Future<void> setUserLocation({LatLng? currentLocation}) async {
    if (isPermissionGranted) {
      if (currentLocation == null) {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
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
          stackTrace: StackTrace.current,
          exception: e,
        );
        final storagePlacemark =
            await LocalStorage.getValueUnderLocalStorageKey(
                LocalStorageKey.lastKnowLocation);
        if (storagePlacemark != null) {
          placemark = Placemark.fromMap(storagePlacemark);
          if (kDebugMode)
            debugPrint(
                'TiuTiuApp: A storaged placemark is being used instead.');
        }
      }

      currentPlacemark = placemark;

      await systemController.updateAccessToLocationWasDenied();
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
