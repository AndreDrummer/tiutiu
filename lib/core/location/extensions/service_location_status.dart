enum GPSStatus {
  active,
  deactivated,
}

extension LocationServiceStatusExtension on GPSStatus {
  bool get isActive => this == GPSStatus.active;
}
