import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/add_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostImages extends StatelessWidget {
  const PostImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AddImage(
        hasError: postsController.post.photos.isEmpty && !postsController.formIsValid,
        onRemovePictureOnIndex: postsController.removePictureOnIndex,
        onAddPictureOnIndex: postsController.addPictureOnIndex,
        addedImagesQty: postsController.post.photos.length,
        images: postsController.post.photos,
        maxImagesQty: 6,
      ),
    );
  }
}
