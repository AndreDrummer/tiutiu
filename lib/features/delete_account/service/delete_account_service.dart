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
      await deleteUserPosts(userId);
      await _postService.deleteUserAvatar(userId);
      onFinishing();
      final userDataReference = await _tiutiuUserService.getUserReferenceById(userId);

      await userDataReference.set(deleteAccountData.toMap());
      await authController.user?.delete();
      await authController.user?.reload();
      await authController.signOut();
    } on Exception catch (exception) {
      crashlyticsController.reportAnError(
        message: 'Erro when tryna to delete user with id $userId: $exception',
        exception: exception,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<void> deleteUserPosts(String userId) async {
    final List<Post> userPosts = postsController.loggedUserPosts();
    if (kDebugMode) debugPrint('TiuTiuApp: Delete ${userPosts.length} user posts');

    for (int i = 0; i < userPosts.length; i++) {
      if (kDebugMode) debugPrint('TiuTiuApp: Deleting user post ${userPosts[i].uid}');
      await _postService.deletePost(userPosts[i]);
    }
  }
}
