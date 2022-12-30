import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDennounceScreen extends StatelessWidget {
  const PostDennounceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: DefaultBasicAppBar(
          text: postDennounceController.postBeingDennounced.dennouncedPost?.name ?? '',
        ),
      ),
    );
  }
}
