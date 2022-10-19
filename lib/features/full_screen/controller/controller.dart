import 'package:get/get.dart';
import 'package:tiutiu/features/full_screen/views/fullscreen_images.dart';

class FullscreenController extends GetxController {
  final RxDouble _zoom = 1.1.obs;

  void set zoom(double value) {
    _zoom(value);
  }

  double get zoom => _zoom.value;

  void openFullScreenMode(List photos) {
    Get.to(() => FullScreenImage(photos: photos));
  }
}
