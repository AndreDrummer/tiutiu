import 'package:get/get.dart';

class PostsController extends GetxController {
  final RxInt _flowIndex = 0.obs;

  int get flowIndex => _flowIndex.value;

  void set flowIndex(int index) => _flowIndex(index);
}
