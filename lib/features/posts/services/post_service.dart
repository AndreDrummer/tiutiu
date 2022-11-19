import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PostService extends GetxService {
  Future<List<Map<String, dynamic>>> loadPosts() async {
    final posts = await FirebaseFirestore.instance.collection(pathToPosts).get();

    return posts.docs.map((post) => post.data()).toList();
  }

  Future<void> uploadVideo({required Function(String?) onVideoUploaded, required Post post}) async {
    try {
      final videosStoragePath = storagePathToVideo(post);

      final videoUrlDownload = await OtherFunctions.getVideoUrlDownload(
        storagePath: videosStoragePath,
        videoPath: post.video,
      );

      onVideoUploaded(videoUrlDownload);
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to get video url download: $exception');
    }
  }

  Future<void> uploadImages({required Function(List) onImagesUploaded, required Post post}) async {
    try {
      final imagesStoragePath = storagePathToImages(post);

      final imagesUrlDownloadList = await OtherFunctions.getImageListUrlDownload(
        storagePath: imagesStoragePath,
        imagesPathList: post.photos,
      );

      onImagesUploaded(imagesUrlDownloadList);
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to get images url download list: $exception');
    }
  }

  Future<bool> uploadPostData(Post post) async {
    bool success = false;

    try {
      await FirebaseFirestore.instance.collection(pathToPosts).doc(post.uid!).set(post.toMap());
      debugPrint('>> Posted Successfully ${post.uid}');
      success = true;
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to send data to Firestore: $exception');
    }

    return success;
  }

  Future<bool> deletePost(Post post) async {
    bool success = false;

    try {
      final videosStoragePath = storagePathToVideo(post);

      await deletePostVideo(videosStoragePath, post.uid!);
      await deletePostImages(post);

      await FirebaseFirestore.instance.collection(pathToPosts).doc(post.uid).delete();
      debugPrint('>> Post deleted Successfully ${post.uid}');
      success = true;
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to delete post with id ${post.uid}: $exception');
    }

    return success;
  }

  Future<void> deletePostVideo(String videoPath, String postId) async {
    try {
      await FirebaseStorage.instance.ref(videoPath).delete();
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to delete video of post with id $postId: $exception');
    }
  }

  Future<void> deletePostImages(Post post) async {
    int currentImage = 0;
    try {
      final imagesStoragePath = storagePathToImages(post);
      final imagesQqty = post.photos.length;

      for (currentImage = 0; currentImage < imagesQqty; currentImage++) {
        await FirebaseStorage.instance.ref(imagesStoragePath).child('image$currentImage').delete();
      }
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to image$currentImage of post with id ${post.uid}: $exception');
    }
  }

  Future<List<Post>> getMyPosts(String myUserId) async {
    try {
      final posts = await FirebaseFirestore.instance
          .collection(pathToPosts)
          .where(PostEnum.ownerId.name, isEqualTo: myUserId)
          .get();

      return posts.docs.map((post) => Pet.fromSnapshot(post)).toList();
    } on Exception catch (exception) {
      debugPrint('Erro when tryna get my posts: $exception');
      return List.empty();
    }
  }

  String storagePathToImages(Post post) => userPostsStoragePath(
        fileType: FileType.images.name,
        userId: post.ownerId!,
        postId: post.uid!,
      );

  String storagePathToVideo(Post post) => userPostsStoragePath(
        fileType: FileType.video.name,
        userId: post.ownerId!,
        postId: post.uid!,
      );
}
