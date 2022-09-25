import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/auth/services/auth_service.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiutiu/core/extensions/enum_tostring.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

class MigrationService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final String petAdPurpose = FirebaseEnvPath.disappeared;
  final String petAdPurpose = FirebaseEnvPath.donate;

  void migrate() async {
    final loggedMoreThanOneDay =
        DateTime.now().difference(DateTime(2022, 09, 21)).inDays < 1;

    if (loggedMoreThanOneDay) {
      await loginWithEmailAndPassword('andre@gmail.com', '123123');
    }

    // migrateAllUsers();
    // migrateAllPetAds();
    // updateSomePetData();
    // updateSomeUserData();
  }

  void migrateAllUsers() async {
    final list = await _firestore.collection(petAdPurpose).get();

    list.docs.forEach((petAd) async {
      if (petAd.data()['createdAt'] != null) {
        final includedAfterMay2022 = includedAtTheCutDate(
          createdAt: petAd.data()['createdAt'],
          cutdate: DateTime(2022, 05),
        );

        if (includedAfterMay2022) {
          final tiutiuUser = await getUserData(petAd.data()['ownerReference']);
          insertUserDataInNewPath(tiutiuUser);
        }
      }
    });
  }

  void migrateAllPetAds() async {
    final list = await _firestore.collection(petAdPurpose).get();

    list.docs.forEach((petAd) async {
      if (petAd.data()['donated'] == true) {
        deletePost(petAd);
      }
      if (petAd.data()['createdAt'] != null) {
        final includedAfterMay2022 = includedAtTheCutDate(
          createdAt: petAd.data()['createdAt'],
          cutdate: DateTime(2022, 05),
        );

        if (includedAfterMay2022) {
          final map = petAd.data();
          final tiutiuUser = await getUserData(petAd.data()['ownerReference']);
          map[PetEnum.owner.tostring()] = tiutiuUser;
          // debugPrint('>> ${map[PetEnum.owner.tostring()]}');

          insertAdDataInNewPath(Pet.fromMigrate(map));
        } else {
          deletePost(petAd);
        }
      } else {
        // Apagar anuncios de Maio/2022
        deletePost(petAd);
      }
    });
  }

  void updateSomePetData() async {
    final list = await _firestore.collection(newPathToAds).get();

    list.docs.forEach((snapshot) async {
      final pet = Pet.fromMap(snapshot.data());
      final owner = await tiutiuUserController.getUserById(pet.ownerId!);
      // debugPrint('${owner.toMap()}');

      snapshot.reference.set(
          {PetEnum.owner.tostring(): owner.toMap()}, SetOptions(merge: true));
    });
  }

  void updateSomeUserData() async {
    final list = await _firestore.collection(newPathToUser).get();

    list.docs.forEach((snapshot) async {
      final user = TiutiuUser.fromMap(snapshot.data());

      snapshot.reference.set(
          {TiutiuUserEnum.lastLogin.tostring(): user.createdAt},
          SetOptions(merge: true));
    });
  }

  Future<TiutiuUser> getUserData(DocumentReference ownerReference) async {
    final userData = await ownerReference.get();
    final tiutiuUser =
        TiutiuUser.fromMapMigration((userData.data() as Map<String, dynamic>));
    // debugPrint('>> ${tiutiuUser.toMap()}');

    return tiutiuUser;
  }

  void insertUserDataInNewPath(TiutiuUser user) {
    _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc('env')
        .collection(FirebaseEnvPath.env)
        .doc(FirebaseEnvPath.userss)
        .collection(FirebaseEnvPath.userss)
        .doc(user.uid!)
        .set(user.toMap());
  }

  void insertAdDataInNewPath(Pet pet) {
    _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc('env')
        .collection(FirebaseEnvPath.env)
        .doc(FirebaseEnvPath.posts)
        .collection(FirebaseEnvPath.posts)
        .doc(pet.uid)
        .set(pet.toMap());
  }

  bool includedAtTheCutDate({
    required String createdAt,
    required DateTime cutdate,
  }) {
    final dateTime = Formatter.getDateTime(createdAt);
    final included = dateTime.isAfter(cutdate);

    // debugPrint('>> Included $included');

    return included;
  }

  void deletePost(QueryDocumentSnapshot<Map<String, dynamic>> petAd) {
    deletePetAd(
      storageHashKey: petAd.data()['storageHashKey'],
      petPhotos: petAd.data()['photos'] ?? [],
      petReference: petAd.reference,
    );
  }

  void deletePetAd({
    required DocumentReference petReference,
    required String storageHashKey,
    required List petPhotos,
  }) async {
    petPhotos.forEach((url) async {
      await FirebaseStorage.instance.refFromURL(url).delete();
    });

    petReference.delete();
  }

  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    User? _firebaseUser;
    UserCredential result = await AuthService()
        .firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    _firebaseUser = result.user;
    return _firebaseUser != null;
  }

  Future getPetAdState(LatLng position) async {
    final placemarkList = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    print(placemarkList);

    return placemarkList.first.administrativeArea;
  }

  Future getPetAdCity(LatLng position) async {
    final placemarkList = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    return placemarkList.first.subAdministrativeArea;
  }
}
