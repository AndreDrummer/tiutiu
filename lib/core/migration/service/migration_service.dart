import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/auth/service/auth_service.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:tiutiu/core/location/models/latlng.dart';
import 'package:tiutiu/core/system/model/endpoint.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';

class MigrationService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final String petAdPurpose = FirebaseEnvPath.disappeared;
  final String petAdPurpose = FirebaseEnvPath.donate;

  void migrate() async {
    // updateSomePostData();
  }

  void updateEndpointsSintaxe() async {
    try {
      debugPrint('|| Updating Endpoint name... ||');
      final a = await _pathToEndpoints('prod').get();
      final docs = a.docs;

      for (int i = 0; i < docs.length; i++) {
        final endpoint = Endpoint.fromSnapshot(docs[i]);
        // print('Endpoint ${endpoint.name}');
        // if (endpoint.name == "pathToPostDennounces") {
        debugPrint('|| Atual Endpoint $endpoint... ||');
        final newEndpoint = Endpoint(
          example: endpoint.example.replaceAll('debug', 'prod'),
          path: endpoint.path,
          type: endpoint.type,
          name: endpoint.name,
        );

        debugPrint('|| Novo Endpoint $newEndpoint... ||');
        await updateEndpoint(newEndpoint);
        // }
      }
    } catch (merda) {
      debugPrint('||  Merda $merda... ||');
    }
  }

  Future updateEndpoint(Endpoint endpoint) async {
    await _pathToEndpoint(endpoint.name).set(endpoint.toMap());
  }

  void moveEndpointsToProd() async {
    debugPrint('|| MIGRATION Starting... ||');
    _pathToEndpoints('debug').snapshots().forEach((event) {
      event.docs.forEach((e) {
        _pathToEndpoints('prod').doc(e.id).set(e.data());
      });
    });
    debugPrint('|| MIGRATION Finished! ||');
  }

  void moveSomeDocumentDataToProd() async {
    debugPrint('|| MIGRATION Starting... ||');
    final migratingDocument = 'sponsoreds';

    final data = await _pathToDocumentData('debug', migratingDocument).get();
    debugPrint('|| MDATA ${data.data()} ||');

    _pathToDocumentData('prod', migratingDocument).set(data.data() ?? {});
  }

  void migrateUsers() async {
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

  void migratePosts() async {
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
          map[PostEnum.owner.name] = tiutiuUser;
          // debugPrint('TiuTiuApp: ${map[PetEnum.owner.name]}');

          // insertAdDataInNewPath(Pet.fromMigrate(map));
        } else {
          deletePost(petAd);
        }
      } else {
        // Apagar anuncios de Maio/2022
        deletePost(petAd);
      }
    });
  }

  void updateSomePostData() async {
    final endpoint = EndpointResolver.getCollectionEndpoint(EndpointNames.pathToPosts.name);

    final list = await endpoint.get();
    // final list = await _firestore.collection(pathToPosts).get();

    list.docs.forEach((snapshot) async {
      // final pet = Pet().fromMap(snapshot.data());
      // final owner = await tiutiuUserController.getUserById(pet.ownerId!);

      snapshot.reference.set({PostEnum.shared.name: 0}, SetOptions(merge: true));
    });
  }

  void updateSomeUserData() async {
    final list = await EndpointResolver.getCollectionEndpoint(EndpointNames.pathToUsers.name).get();

    list.docs.forEach((snapshot) async {
      final user = TiutiuUser.fromMap(snapshot.data());

      snapshot.reference.set({TiutiuUserEnum.lastLogin.name: user.createdAt}, SetOptions(merge: true));
    });
  }

  Future<TiutiuUser> getUserData(DocumentReference ownerReference) async {
    final userData = await ownerReference.get();
    final tiutiuUser = TiutiuUser.fromMapMigration((userData.data() as Map<String, dynamic>));
    // debugPrint('TiuTiuApp: ${tiutiuUser.toMap()}');

    return tiutiuUser;
  }

  void insertUserDataInNewPath(TiutiuUser user) {
    _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(FirebaseEnvPath.environment)
        .doc(FirebaseEnvPath.users.toLowerCase())
        .collection(FirebaseEnvPath.users.toLowerCase())
        .doc(user.uid!)
        .set(user.toMap());
  }

  void insertPostDataInNewPath(Pet pet) {
    _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(FirebaseEnvPath.environment)
        .doc(FirebaseEnvPath.posts)
        .collection(FirebaseEnvPath.posts)
        .doc(pet.uid)
        .set(pet.toMap());
  }

  bool includedAtTheCutDate({required String createdAt, required DateTime cutdate}) {
    final dateTime = Formatters.getDateTime(createdAt);
    final included = dateTime.isAfter(cutdate);

    // debugPrint('TiuTiuApp: Included $included');

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
    return await AuthService().loginWithEmailAndPassword(email: email, password: password);
  }

  Future getPetAdState(LatLng position) async {
    final placemarkList = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    return placemarkList.first.administrativeArea;
  }

  Future getPetAdCity(LatLng position) async {
    final placemarkList = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    return placemarkList.first.subAdministrativeArea;
  }

  CollectionReference<Map<String, dynamic>> _pathToEndpoints(String environment) {
    return FirebaseFirestore.instance
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(environment)
        .doc(FirebaseEnvPath.endpoints)
        .collection(FirebaseEnvPath.endpoints);
  }

  DocumentReference<Map<String, dynamic>> _pathToDocumentData(String environment, String documentName) {
    return FirebaseFirestore.instance
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(environment)
        .doc(documentName);
  }

  DocumentReference<Map<String, dynamic>> _pathToEndpoint(String endpointName) {
    return FirebaseFirestore.instance
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection('debug')
        .doc(FirebaseEnvPath.endpoints)
        .collection(FirebaseEnvPath.endpoints)
        .doc(endpointName);
  }
}
