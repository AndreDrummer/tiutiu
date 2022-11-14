import 'dart:io';

class Dimensions {
  static double getDimensByPlatform({required double iosDimen, required double androidDimen}) {
    if (Platform.isIOS) return iosDimen;
    return androidDimen;
  }
}
