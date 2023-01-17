import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/views/load_dark_screen.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class LoadingBlur extends StatelessWidget {
  const LoadingBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadDarkScreen(
        message: postsController.uploadingPostText,
        visible: postsController.isLoading,
      ),
    );
  }
}
