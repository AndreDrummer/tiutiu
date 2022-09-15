import 'package:geolocator/geolocator.dart';

class MathFunctions {
  static double distanceMatrix({
    required double longX,
    required double longY,
    required double latX,
    required double latY,
  }) {
    final distance = Geolocator.distanceBetween(
      latX,
      longX,
      latY,
      longY,
    );

    return distance;
  }

  static String time(double distance) {
    double t = ((distance / 1000) / 45) * 60;

    return t.toStringAsFixed(2);
  }
}
