import 'package:tiutiu/features/system/controllers.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxBool _showErrorEmptyPic = false.obs;
  final RxBool _isLoading = false.obs;

  bool get showErrorEmptyPic => _showErrorEmptyPic.value;
  bool get isLoading => _isLoading.value;

  void set showErrorEmptyPic(bool value) => _showErrorEmptyPic(value);

  Future<void> save() async {
    _isLoading(true);

    await tiutiuUserController.updateUserDataOnServer();

    _isLoading(false);
  }
}
