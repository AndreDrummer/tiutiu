import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PostService extends GetxService {
  Future<List<Map<String, dynamic>>> loadPosts() async {
    final posts = await FirebaseFirestore.instance.collection(pathToPosts).get();

    return posts.docs.map((post) => post.data()).toList();
  }

  Future<void> uploadVideo({
    required Function(String?) onVideoUploaded,
    required Post post,
  }) async {
    try {
      final videosStoragePath = userPostsStoragePath(
        fileType: FileType.video.name,
        userId: post.ownerId!,
        postId: post.uid!,
      );

      final videoUrlDownload = await OtherFunctions.getVideoUrlDownload(
        storagePath: videosStoragePath,
        videoPath: post.video,
      );

      onVideoUploaded(videoUrlDownload);
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to get video url download: $exception');
    }
  }

  Future<void> uploadImages({
    required Function(List) onImagesUploaded,
    required Post post,
  }) async {
    try {
      final imagesStoragePath = userPostsStoragePath(
        fileType: FileType.images.name,
        userId: post.ownerId!,
        postId: post.uid!,
      );

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

  Stream<List<Post>> getMyPosts(String myUserId) {
    return FirebaseFirestore.instance
        .collection(pathToPosts)
        .where(PostEnum.ownerId.name, isEqualTo: myUserId)
        .snapshots()
        .asyncMap((snapshot) {
      return snapshot.docs.map((post) => Pet.fromSnapshot(post)).toList();
    });
  }
}
