import 'package:get/get.dart';

class FullscreenController extends GetxController {
  final RxDouble _zoom = 1.2.obs;

  void set zoom(double value) {
    _zoom(value);
  }

  double get zoom => _zoom.value;
}
