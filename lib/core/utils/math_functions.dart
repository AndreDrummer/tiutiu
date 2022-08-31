import 'package:geolocator/geolocator.dart';

class MathFunctions {
  static String? distanceMatrix({
    required double longX,
    required double longY,
    required double latX,
    required double latY,
  }) {
    return Geolocator.distanceBetween(
      latX,
      longX,
      latY,
      longY,
    ).toStringAsFixed(2);
  }

  static String time(double distance) {
    double t = ((distance / 1000) / 45) * 60;

    return t.toStringAsFixed(2);
  }
}
