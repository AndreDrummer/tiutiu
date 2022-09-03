import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt _bottomBarIndex = 0.obs;

  int get bottomBarIndex => _bottomBarIndex.value;

  bool get isAuthenticated => false;

  void set bottomBarIndex(int? index) {
    _bottomBarIndex(index ?? bottomBarIndex);
  }
}
