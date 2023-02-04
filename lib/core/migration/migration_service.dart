// ignore_for_file: unused_element

import 'package:tiutiu/features/tiutiu_user/services/tiutiu_user_service.dart';
import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/auth/service/auth_service.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/utils/file_cache_manager.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:tiutiu/core/location/models/latlng.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

final environmentToMigrate = 'debug';

class MigrationUI extends StatelessWidget {
  const MigrationUI({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MigrationService().migrate(),
      builder: (ctx, snapshot) {
        print('SNAPSHOT TYPE ${snapshot.data.runtimeType} ${snapshot.data.runtimeType == String}');
        if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
        if (!snapshot.hasData || snapshot.data == null) return Center(child: Text('NADA'));
        if (snapshot.hasData && snapshot.data.toString().contains('https')) {
          print('SNAPSHOT NETWORK');
          return Scaffold(
            body: Image.network(snapshot.data),
          );
        }

        print('SNAPSHOT FILE');
        return Scaffold(
          body: Image.file(File(snapshot.data)),
        );
      },
    );
  }
}

class MigrationService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String petAdPurpose = FirebaseEnvPath.donate;

  bool includedAtTheCutDate({required String createdAt, required DateTime cutdate}) {
    final dateTime = Formatters.getDateTime(createdAt);
    final included = dateTime.isAfter(cutdate);

    return included;
  }

  Future migrate() async {
    // await _loginWithEmailAndPassword('admin@example.com', '111111');

    // await StatesAndCities.stateAndCities.getUFAndCities();

    // await deleteAllExceptForThisUserId('B5dcFay3bXPkhm7elITxmL7zt3T2');
  }

  Future<String?> _migrateAllData(String userId) async {
    // await _migrateUserData(userId);
    // await _migratePostPetData(userId);

    return null;
  }

  Future<String?> _migrateUserData(String userId) async {
    // Reach the user...
    final user = await _firestore.collection('Users').doc(userId).get();

    // Get the user profile...
    final avatarURL = user.data()!['photoURL'];

    // Downloads the user profile..
    final filePath = await FileDownloader.save(fileUrl: avatarURL, type: FileType.images, filename: 'profile');

    // Upload the user avatar to the new prod path...
    final newAvatarUrl = await TiutiuUserService().uploadAvatar(userId, File(filePath));

    // Update user profile with the new avatar URL
    _firestore.collection('Users').doc(userId).set({'photoURL': newAvatarUrl}, SetOptions(merge: true));

    final newUserModel = await _getUserIntoNewModel(user.reference);
    _insertUserDataInNewPath(newUserModel);

    print('USER CATCH $newAvatarUrl');

    return null;
  }

  Future<String?> _migratePostPetData(String userId) async {
    // Reach the user to migrate...
    final allOldPetPosts = await _firestore.collection('Donate').get();

    // Iterate over all olds pets posts to get the posts belonginings to the referred userId...
    final userPosts = allOldPetPosts.docs.where((post) {
      final postData = post.data();

      // print('POST DATA ${(postData['ownerReference'] as DocumentReference).path == 'Users/$userId'}');
      return (postData['ownerReference'] as DocumentReference).path == 'Users/$userId';
    }).toList();

    print('POST DATA user posts ${userPosts.length}');

    // Iterate over each post that belongs to the referred userId...
    userPosts.forEach((post) async {
      final newModelPost = await _getPostIntoNewModel(post);
      final postReference = post.reference;
      final postStorageHashKey = post.data()['storageHashKey'];
      print('POST DATA  $postStorageHashKey');

      final allPetsPhotos =
          await FirebaseStorage.instance.ref(userId).child('petsPhotos/Donate/$postStorageHashKey').listAll();

      final newPathPetPhotosUrlDownload = [];

      // Iterate over each post photo to take the downloadURL and upload to the new path...
      final items = allPetsPhotos.items;
      for (int i = 0; i < items.length; i++) {
        final photo = items[i];
        final petPhotoUrl = await photo.getDownloadURL();

        final filePath = await FileDownloader.save(fileUrl: petPhotoUrl, type: FileType.images, filename: 'petPhoto$i');

        print('POST DATA FILE PATH $filePath');

        // Upload the file to the new post path on Storage
        final storageRef = FirebaseStorage.instance
            .ref('tiutiu/$environmentToMigrate/users')
            .child('$userId/posts/${newModelPost.uid}/images/${Uuid().v4()}');

        var uploadTask = storageRef.putFile(File(filePath));

        await uploadTask;

        final newPetPhotoUrl = await storageRef.getDownloadURL();

        print('POST DATA NEW DOWNLOAD URL $newPetPhotoUrl');

        newPathPetPhotosUrlDownload.add(newPetPhotoUrl);

        print('POST DATA NEW PHOTOS LIST $newPathPetPhotosUrlDownload');

        // Update current build about the new pet photo url
        postReference.set({'photos': newPathPetPhotosUrlDownload}, SetOptions(merge: true));

        postReference.set({'avatar': newPathPetPhotosUrlDownload.first}, SetOptions(merge: true));
      }

      // Update post location
      final location = await _updatePostStateAndCity(LatLng(newModelPost.latitude!, newModelPost.longitude!));

      // Update the new pet Model with the newPhotos URL.
      final newPost = newModelPost
          .copyWith(photos: newPathPetPhotosUrlDownload)
          .copyWith(gender: post.data()['sex'])
          .copyWith(state: location.first)
          .copyWith(city: location.last);

      // Insert the post in the new location
      _insertPostDataInNewPath(newPost);
    });

    return null;
  }

  Future<List<String>> _updatePostStateAndCity(LatLng location) async {
    late String state;
    late String city;

    final placemark = (await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    ))
        .first;

    if (placemark.isoCountryCode == 'BR') {
      if (Platform.isAndroid) {
        city = placemark.subAdministrativeArea!;
        state = placemark.administrativeArea!;
      } else if (Platform.isIOS) {
        state = StatesAndCities.stateAndCities.getStateNameFromInitial(placemark.administrativeArea!);
        city = placemark.locality!;
      }
    } else {
      state = 'Acre';
      city = 'Acrelândia';
    }

    return [state, city];
  }

  Future<TiutiuUser> _getUserIntoNewModel(DocumentReference ownerReference) async {
    final userData = await ownerReference.get();
    final tiutiuUser = TiutiuUser.fromMapMigration((userData.data() as Map<String, dynamic>));

    return tiutiuUser;
  }

  Future<Pet> _getPostIntoNewModel(QueryDocumentSnapshot<Map<String, dynamic>> postQuerySnapshot) async {
    final newPetModelMap = postQuerySnapshot.data();
    final tiutiuUser = await _getUserIntoNewModel(postQuerySnapshot.data()['ownerReference']);
    newPetModelMap[PostEnum.owner.name] = tiutiuUser.toMap();

    return Pet().fromMap(newPetModelMap);
  }

  Future<bool> _loginWithEmailAndPassword(String email, String password) async {
    return await AuthService().loginWithEmailAndPassword(email: email, password: password);
  }

  Future<void> _updateSomePostData() async {
    final endpoint = EndpointResolver.getCollectionEndpoint(EndpointNames.pathToPosts.name);

    final list = await endpoint.get();
    // final list = await _firestore.collection(pathToPosts).get();

    list.docs.forEach((snapshot) async {
      // final pet = Pet().fromMap(snapshot.data());
      // final owner = await tiutiuUserController.getUserById(pet.ownerId!);

      snapshot.reference.set({PostEnum.views.name: 0}, SetOptions(merge: true));
    });
  }

  Future<void> _updateSomeUserData() async {
    final list = await EndpointResolver.getCollectionEndpoint(EndpointNames.pathToUsers.name).get();

    list.docs.forEach((snapshot) async {
      // final user = TiutiuUser.fromMap(snapshot.data());

      snapshot.reference.set({TiutiuUserEnum.timesOpenedTheApp.name: 0}, SetOptions(merge: true));
    });
  }

  Future<void> _migrateUsers() async {
    print('>> Start Migrating Users...');
    final list = await _firestore.collection(petAdPurpose).get();

    list.docs.forEach((petAd) async {
      if (petAd.data()['createdAt'] != null) {
        final includedAfterJanuary2023 = includedAtTheCutDate(
          createdAt: petAd.data()['createdAt'],
          cutdate: DateTime(2023, 01),
        );

        if (includedAfterJanuary2023) {
          // final tiutiuUser = await _getUserIntoNewModel(petAd.data()['ownerReference']);

          // _insertUserDataInNewPath(tiutiuUser);
        } else {
          // deleteUserData
        }
      }
    });
  }

  Future<void> _migratePosts() async {
    final list = await _firestore.collection(petAdPurpose).get();

    list.docs.forEach((petAd) async {
      if (petAd.data()['donated'] == true) {
        _deletePost(petAd);
      }

      if (petAd.data()['createdAt'] != null) {
        final includedAfterJanuary2023 = includedAtTheCutDate(
          createdAt: petAd.data()['createdAt'],
          cutdate: DateTime(2023, 01, 01),
        );

        if (includedAfterJanuary2023) {
          final newPet = await _getPostIntoNewModel(petAd);

          _insertPostDataInNewPath(newPet);
        } else {
          _deletePost(petAd);
        }
      } else {
        // Apagar anuncios de Maio/2022
        _deletePost(petAd);
      }
    });
  }

  Future<void> _deletePetAd({
    required DocumentReference petReference,
    required String storageHashKey,
    required List petPhotos,
  }) async {
    petPhotos.forEach((url) async {
      await FirebaseStorage.instance.refFromURL(url).delete();
    });

    petReference.delete();
  }

  Future<void> deleteAllExceptForThisUserId(String userId) async {
    final posts = await _newPathToPosts().get();

    for (int i = 0; i < posts.docs.length; i++) {
      final doc = posts.docs[i];

      if (Pet().fromMap(doc.data()).ownerId != userId) {
        doc.reference.delete();
      }
    }

    final users = await _newPathToUsers().get();

    for (int i = 0; i < users.docs.length; i++) {
      final doc = users.docs[i];

      if (TiutiuUser.fromMap(doc.data()).uid != userId) {
        doc.reference.delete();
      }
    }
  }

  CollectionReference<Map<String, dynamic>> _newPathToUsers() {
    return _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(environmentToMigrate)
        .doc(FirebaseEnvPath.users.toLowerCase())
        .collection(FirebaseEnvPath.users.toLowerCase());
  }

  CollectionReference<Map<String, dynamic>> _newPathToPosts() {
    return _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(environmentToMigrate)
        .doc(FirebaseEnvPath.posts)
        .collection(FirebaseEnvPath.posts);
  }

  void _deletePost(QueryDocumentSnapshot<Map<String, dynamic>> petAd) {
    _deletePetAd(
      storageHashKey: petAd.data()['storageHashKey'],
      petPhotos: petAd.data()['photos'] ?? [],
      petReference: petAd.reference,
    );
  }

  void _insertUserDataInNewPath(TiutiuUser user) {
    _newPathToUsers().doc(user.uid!).set(user.toMap());
  }

  void _insertPostDataInNewPath(Pet pet) {
    _newPathToPosts().doc(pet.uid).set(pet.toMap());
  }
}
