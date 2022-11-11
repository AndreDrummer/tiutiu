import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addFavorite(Post post) {
    debugPrint('>> Add to favorites');
    _favoritesCollection().doc(post.uid).set(post.toMap());
  }

  void removeFavorite(Post post) {
    debugPrint('>> Remove from favorites');
    _favoritesCollection().doc(post.uid).delete();
  }

  Stream<List<Post>> favorites() {
    return _favoritesCollection().snapshots().asyncMap((snapshot) {
      List<Post> favoritePosts = [];
      snapshot.docs.forEach((favorite) {
        if (favorite.data().isNotEmpty) {
          favoritePosts.add(Pet().fromMap(favorite.data()));
        }
      });
      return favoritePosts;
    });
  }

  CollectionReference<Map<String, dynamic>> _favoritesCollection() {
    return _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(FirebaseEnvPath.environment)
        .doc(FirebaseEnvPath.users.toLowerCase())
        .collection(FirebaseEnvPath.users.toLowerCase())
        .doc(tiutiuUserController.tiutiuUser.uid)
        .collection(FirebaseEnvPath.favorites.toLowerCase());
  }
}
