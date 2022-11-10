import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:get/get.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';

class FavoritesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// /tiutiu/env/debug/users/users
  void addFavorite(Post post) {}

  void removeFavorite() {}

  Stream<List<Post>> favorites() {
    return _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(FirebaseEnvPath.environment)
        .doc(FirebaseEnvPath.users.toLowerCase())
        .collection(FirebaseEnvPath.users.toLowerCase())
        .doc(tiutiuUserController.tiutiuUser.uid)
        .collection(FirebaseEnvPath.favorites.toLowerCase())
        .snapshots()
        .asyncMap((snapshot) => snapshot.docs.map((favorite) => Pet().fromMap(favorite.data())).toList());
  }
}
