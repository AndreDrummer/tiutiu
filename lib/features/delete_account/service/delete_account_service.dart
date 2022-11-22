import 'package:tiutiu/features/tiutiu_user/services/tiutiu_user_service.dart';
import 'package:tiutiu/features/delete_account/model/delete_account.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/foundation.dart';

class DeleteAccountService {
  DeleteAccountService({
    required PostService postService,
    required TiutiuUserService tiutiuUserService,
  })  : _postService = postService,
        _tiutiuUserService = tiutiuUserService;

  TiutiuUserService _tiutiuUserService;
  PostService _postService;

  Future<void> deleteAccountForever({
    required Function() onPostsDeletionStarts,
    required DeleteAccount deleteAccountData,
    required Function() onFinishing,
    required String userId,
  }) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      onPostsDeletionStarts();
      // await Future.delayed(Duration(seconds: 2));
      await deleteUserPosts(userId);
      onFinishing();
      // await Future.delayed(Duration(seconds: 2));
      final userDataReference = await _tiutiuUserService.getUserReferenceById(userId);

      await userDataReference.set(deleteAccountData.toMap());
      await authController.user?.delete();
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to delete user with id $userId: $exception');
    }
  }

  Future<void> deleteUserPosts(String userId) async {
    final List<Post> userPosts = await _postService.getMyPosts(userId);

    userPosts.forEach((post) async {
      await _postService.deletePost(post);
    });
  }
}
