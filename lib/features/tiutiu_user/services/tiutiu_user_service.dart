import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class TiutiuUserService {
  Future<TiutiuUser> getUserByID(String id) async {
    DocumentSnapshot userSnaphsot =
        await EndpointResolver.getDocumentEndpoint(EndpointNames.pathToUser.name, [id]).get();

    if (userSnaphsot.data() != null) return TiutiuUser.fromMap(userSnaphsot.data() as Map<String, dynamic>);
    return TiutiuUser();
  }

  Future<DocumentReference> getUserReferenceById(String userId) async {
    return (await EndpointResolver.getDocumentEndpoint(EndpointNames.pathToUser.name, [userId]).get()).reference;
  }

  Future<TiutiuUser> getUserByReference(DocumentReference userReference) async {
    TiutiuUser user = TiutiuUser.fromMap(
      (await userReference.get()).data() as Map<String, dynamic>,
    );

    return user;
  }

  void updateUser({required TiutiuUser userData}) {
    EndpointResolver.getDocumentEndpoint(EndpointNames.pathToUser.name, [userData.uid])
        .set(userData.toMap(), SetOptions(merge: true));
  }

  Future<String?> uploadAvatar(String userId, File file) async {
    Reference ref = FirebaseStorage.instance.ref();
    String? avatarURL;

    final avatarRef = ref.child(EndpointResolver.formattedEndpoint(EndpointNames.userAvatarStoragePath.name, [userId]));

    try {
      var uploadTask = avatarRef.putFile(file);
      await uploadTask.whenComplete(() {
        if (kDebugMode) debugPrint('TiuTiuApp: Success Upload Avatar');
      });

      avatarURL = await avatarRef.getDownloadURL();
    } on FirebaseException catch (exception) {
      crashlyticsController.reportAnError(
        message: 'Ocorreu um erro ao fazer upload do avatar: $exception.',
        exception: exception,
        stackTrace: StackTrace.current,
      );
    }

    return avatarURL;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserPostsById(String userId) {
    return EndpointResolver.getCollectionEndpoint(EndpointNames.pathToPosts.name)
        .where(PostEnum.ownerId.name, isEqualTo: userId)
        .snapshots();
  }
}
