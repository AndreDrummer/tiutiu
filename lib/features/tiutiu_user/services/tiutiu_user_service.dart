import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class TiutiuUserService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<TiutiuUser> getUserByID(String id) async {
    DocumentSnapshot userSnaphsot = await _firestore.collection(newPathToUser).doc(id).get();

    if (userSnaphsot.data() != null) return TiutiuUser.fromMap(userSnaphsot.data() as Map<String, dynamic>);
    return TiutiuUser();
  }

  Future<DocumentReference> getUserReference(String userId) async {
    return (await _firestore.collection(newPathToUser).doc(userId).get()).reference;
  }

  Future<TiutiuUser> getUserByReference(DocumentReference userReference) async {
    TiutiuUser user = TiutiuUser.fromMap(
      (await userReference.get()).data() as Map<String, dynamic>,
    );

    return user;
  }

  void updateUser({required TiutiuUser userData}) {
    _firestore.collection(newPathToUser).doc(userData.uid).set(userData.toMap(), SetOptions(merge: true));
  }

  Future<String?> uploadAvatar(String userId, File file) async {
    Reference ref = FirebaseStorage.instance.ref();
    String? avatarURL;

    final avatarRef = ref.child(userProfileStoragePath(userId));

    try {
      var uploadTask = avatarRef.putFile(file);
      await uploadTask.whenComplete(() {
        debugPrint('Success Upload Avatar');
      });

      avatarURL = await avatarRef.getDownloadURL();
    } on FirebaseException catch (error) {
      debugPrint('Ocorreu um erro ao fazer upload do avatar: $error.');
    }

    return avatarURL;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserPostsById(String uid) {
    return _firestore.collection(pathToPosts).where(PostEnum.ownerId.name, isEqualTo: uid).snapshots();
  }
}
