import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/utils/constantes.dart';
import '../Model/user_model.dart';

class UserController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User> getUserByID(String id) async {
    DocumentSnapshot userSnaphsot =
        await firestore.collection('Users').doc(id).get();

    return User.fromSnapshot(userSnaphsot);
  }

  Future<User> getUserDataByReference(DocumentReference userReference) async {
    User user = User.fromSnapshot(await userReference.get());

    return user;
  }

  Stream<DocumentSnapshot> getUserSnapshot(DocumentReference userReference) {
    return userReference.snapshots();
  }

  Future<void> favorite(DocumentReference userReference,
      DocumentReference petReference, bool add) async {
    final favorites = userReference.collection('Favorites');

    if (add) {
      favorites.doc().set({'id': petReference});
    } else {
      var petToRemoveFromFavorites;

      await favorites.where("id", isEqualTo: petReference).get().then((value) {
        petToRemoveFromFavorites = value.docs.first.id;
      });

      favorites.doc(petToRemoveFromFavorites).delete();
    }
  }

  Future<void> donatePetToSomeone({
    required DocumentReference interestedReference,
    required String interestedNotificationToken,
    required DocumentReference ownerReference,
    required String ownerNotificationToken,
    required String interestedName,
    required String interestedID,
    required int userPosition,
    required Pet pet,
  }) async {
    var user = await ownerReference.get();

    // Deleta notificação antiga
    final pathToPetAdopted = await firestore
        .collection(Constantes.ADOPTED)
        .where('interestedReference', isEqualTo: interestedReference)
        .get();
    if (pathToPetAdopted.docs.isNotEmpty)
      pathToPetAdopted.docs.first.reference.delete();

    Map<String, dynamic> data = {
      'notificationType': 'confirmAdoption',
      'ownerNotificationToken': ownerNotificationToken,
      'interestedNotificationToken': interestedNotificationToken,
      'confirmed': false,
      'petReference': pet.petReference,
      'ownerReference': pet.ownerReference,
      'ownerName': (user.data() as Map<String, dynamic>)['displayName'],
      'interestedName': interestedName,
      'interestedReference': interestedReference,
      'ownerID': pet.ownerId,
      'interestedID': interestedID,
    };

    var petData = pet.toMap();
    petData.remove('photos');
    petData.remove('ownerId');

    data.addAll(petData);

    await firestore.collection(Constantes.ADOPTED).doc().set(data);

    final interestedRef =
        await pet.petReference!.collection('adoptInteresteds').get();
    List interestedUsers = interestedRef.docs;

    for (int i = 0; i < interestedUsers.length; i++) {
      if (interestedUsers[i].data()['interestedID'] == interestedID) {
        Map<String, dynamic> data = interestedUsers[i].data();

        if (data['lastNotificationSend'] == null) {
          data.putIfAbsent(
              'lastNotificationSend', () => DateTime.now().toIso8601String());
        } else {
          data['lastNotificationSend'] = DateTime.now().toIso8601String();
        }

        data['sinalized'] = true;
        pet.petReference!
            .collection('adoptInteresteds')
            .doc(interestedUsers[i].id)
            .set(data);
        break;
      }
    }
  }

  Future<void> confirmDonate(DocumentReference petReference,
      DocumentReference userThatAdoptedReference) async {
    final interestedRef =
        await petReference.collection('adoptInteresteds').get();
    List interestedUsers = interestedRef.docs;

    for (int i = 0; i < interestedUsers.length; i++) {
      if (interestedUsers[i].data()['userReference'] ==
          userThatAdoptedReference) {
        var data = interestedUsers[i].data();
        data['donated'] = true;
        petReference
            .collection('adoptInteresteds')
            .doc(interestedUsers[i].id)
            .set(data);
        break;
      }
    }

    await petReference.set(
        {'donated': true, 'whoAdoptedReference': userThatAdoptedReference},
        SetOptions(merge: true));
    final pathToPetAdopted = await firestore
        .collection(Constantes.ADOPTED)
        .where('confirmed', isEqualTo: false)
        .where('petReference', isEqualTo: petReference)
        .where('interestedReference', isEqualTo: userThatAdoptedReference)
        .get();

    pathToPetAdopted.docs.first.reference.set({
      'confirmed': true,
      'notificationType': 'adoptionConfirmed',
    }, SetOptions(merge: true));
  }

  Future<void> denyDonate(DocumentReference petReference,
      DocumentReference userThatAdoptedReference) async {
    final interestedRef =
        await petReference.collection('adoptInteresteds').get();
    List interestedUsers = interestedRef.docs;

    for (int i = 0; i < interestedUsers.length; i++) {
      if (interestedUsers[i].data()['userReference'] ==
          userThatAdoptedReference) {
        var data = interestedUsers[i].data();
        data['gaveup'] = true;
        data['notificationType'] = 'adoptionDeny';
        petReference
            .collection('adoptInteresteds')
            .doc(interestedUsers[i].id)
            .set(data);
        break;
      }
    }

    final pathToPetAdopted = await firestore
        .collection(Constantes.ADOPTED)
        .where('interestedReference', isEqualTo: userThatAdoptedReference)
        .get();
    pathToPetAdopted.docs.first.reference.set(
        {'notificationType': 'adoptionDeny', 'gaveup': true},
        SetOptions(merge: true));
    if (pathToPetAdopted.docs.isNotEmpty)
      pathToPetAdopted.docs.first.reference.delete();
  }

  Future<void> insertUser(User user) async {
    await firestore.collection('Users').doc().set(user.toMap());
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> createNotification({
    required Map<String, dynamic> data,
    required String notificationId,
    required String userId,
  }) async {
    await firestore
        .collection('Users')
        .doc(userId)
        .collection('Notifications')
        .doc(notificationId)
        .set(
          data,
          SetOptions(merge: true),
        );
  }

  Stream<QuerySnapshot> loadNotifications(String userId) {
    return firestore
        .collection('Users')
        .doc(userId)
        .collection('Notifications')
        .snapshots();
  }

  Stream<QuerySnapshot> loadNotificationsCount(String userId) {
    return firestore
        .collection('Users')
        .doc(userId)
        .collection('Notifications')
        .where('open', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> loadMyPostedPetsToDonate({required String userId}) {
    PetController petController = PetController();
    return petController.getPetsByUser(Constantes.DONATE, userId);
  }

  Stream<QuerySnapshot> loadMyPostedPetsDisappeared({required String userId}) {
    PetController petController = PetController();
    return petController.getPetsByUser(Constantes.DISAPPEARED, userId);
  }

  Stream<QuerySnapshot> loadMyAdoptedPets({required String userId}) {
    PetController petController = PetController();
    return petController.getPetsByUser(Constantes.ADOPTED, userId,
        isAdopted: true);
  }

  Stream<QuerySnapshot> loadMyDonatedPets(DocumentReference userReference) {
    return firestore
        .collection(Constantes.DONATE)
        .where("donated", isEqualTo: true)
        .where("ownerReference", isEqualTo: userReference)
        .snapshots();
  }

  Future<void> deleteUserData(DocumentReference userReference) async {
    QuerySnapshot notifications =
        await userReference.collection('Notifications').get();
    QuerySnapshot petsFavorited =
        await userReference.collection('Favorites').get();

    QuerySnapshot petsDonated = await FirebaseFirestore.instance
        .collection(Constantes.DONATE)
        .where('ownerReference', isEqualTo: userReference)
        .get();
    QuerySnapshot petsDisappeared = await FirebaseFirestore.instance
        .collection(Constantes.DISAPPEARED)
        .where('ownerReference', isEqualTo: userReference)
        .get();
    QuerySnapshot petsAdopted = await FirebaseFirestore.instance
        .collection(Constantes.ADOPTED)
        .where('interestedReference', isEqualTo: userReference)
        .get();

    for (int i = 0; i < petsDonated.docs.length; i++) {
      await petsDonated.docs[i].reference.delete();
      final adoptInterestedsReference = await petsDonated.docs[i].reference
          .collection('adoptInteresteds')
          .get();

      for (QueryDocumentSnapshot doc in adoptInterestedsReference.docs) {
        doc.reference.delete();
      }
    }

    for (int i = 0; i < petsDisappeared.docs.length; i++) {
      await petsDisappeared.docs[i].reference.delete();
      final infoInterestedsReference = await petsDonated.docs[i].reference
          .collection('infoInteresteds')
          .get();

      for (QueryDocumentSnapshot doc in infoInterestedsReference.docs) {
        doc.reference.delete();
      }
    }

    for (int i = 0; i < petsFavorited.docs.length; i++) {
      await petsFavorited.docs[i].reference.delete();
    }

    for (int i = 0; i < petsAdopted.docs.length; i++) {
      await petsAdopted.docs[i].reference.delete();
    }

    for (int i = 0; i < notifications.docs.length; i++) {
      await notifications.docs[i].reference.delete();
    }

    await userReference.delete();

    print('Dados de usuário deletados!');
  }

  Future<void> deleteUserAccount({
    required DocumentReference userReference,
    required Authentication auth,
  }) async {
    await deleteUserData(userReference);
    await auth.firebaseUser?.delete();
    auth.signOut();
  }
}
