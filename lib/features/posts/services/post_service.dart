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

  Future<void> increasePostViews(String postId, int currentViews) async {
    await FirebaseFirestore.instance.doc(pathToPost(postId)).set({'views': ++currentViews}, SetOptions(merge: true));
  }

  Stream<int> postViews(String postId) {
    return FirebaseFirestore.instance
        .doc(pathToPost(postId))
        .snapshots()
        .asyncMap((snp) => snp.get(PostEnum.views.name));
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

  Future<void> uploadImages({
    required Function(List) onImagesUploaded,
    List<String> imagesToDelete = const [],
    required Post post,
  }) async {
    try {
      final imagesStoragePath = storagePathToImages(post);

      if (imagesToDelete.isNotEmpty) {
        debugPrint('>> Deleting images removed...');
        final FirebaseStorage _storage = FirebaseStorage.instance;
        for (int index = 0; index < imagesToDelete.length; index++) {
          debugPrint('>> Deleting ${OtherFunctions.getPhotoName(imagesToDelete[index])}');
          await _storage.refFromURL(imagesToDelete[index]).delete().onError((error, stackTrace) => null);
        }

        debugPrint('>> Images deleted!');
      }

      debugPrint('>> Uploading images...');
      final imagesUrlDownloadList = await OtherFunctions.getImageListUrlDownload(
        storagePath: imagesStoragePath,
        imagesPathList: post.photos,
      );

      onImagesUploaded(imagesUrlDownloadList);
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to get images url download list: $exception');
      rethrow;
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

      if (post.video != null) {
        await deletePostVideo(videosStoragePath, post.uid!);
      }
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
    String currentImage = 'null';
    try {
      final imagesStoragePath = storagePathToImages(post);
      final imagesQqty = post.photos.length;

      for (int i = 0; i < imagesQqty; i++) {
        currentImage = OtherFunctions.getPhotoName(post.photos.elementAt(i));
        await FirebaseStorage.instance.ref(imagesStoragePath).child(currentImage).delete();
      }
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to $currentImage of post with id ${post.uid}: $exception');
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

  Future<void> deleteUserAvatar(String userId) async {
    try {
      debugPrint('>> Deleting user avatar...');
      await FirebaseStorage.instance.ref().child(userAvatarStoragePath(userId)).delete();
    } on Exception catch (exception) {
      debugPrint('Erro when deleting user avatar: $exception');
    }
  }

  String storagePathToImages(Post post) => postsStoragePath(
        fileType: FileType.images.name,
        userId: post.ownerId!,
        postId: post.uid!,
      );

  String storagePathToVideo(Post post) => postsStoragePath(
        fileType: FileType.video.name,
        userId: post.ownerId!,
        postId: post.uid!,
      );
}
