import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';
import 'package:tiutiu/providers/auth2.dart';
import '../Model/user_model.dart';

class UserController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentReference> getReferenceById(String id) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await firebaseFirestore.collection('Users').doc('$id').get();
    return documentSnapshot.reference;
  }

  Future<User> getUserByID(String id) async {
    User user;
    await firestore.collection('User').doc(id).snapshots().first.then((value) {
      user = User(
        id: value.data()['id'],
        name: value.data()['name'],
        photoURL: value.data()['photoURL'],
        email: value.data()['email'],
        password: value.data()['password'],
        phoneNumber: value.data()['phoneNumber'],
        landline: value.data()['landline'],
      );
    });

    return user;
  }

  Future<User> getUserDataByReference(DocumentReference userReference) async {
    User user = User.fromSnapshot(await userReference.get());

    return user;
  }

  Future<void> favorite(DocumentReference userReference, DocumentReference petReference, bool add) async {
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
    DocumentReference interestedReference,
    String interestedName,
    String interestedNotificationToken,
    String ownerNotificationToken,
    DocumentReference petReference,
    DocumentReference ownerReference,
    int userPosition,
  }) async {
    var user = await ownerReference.get();
    var pet = await petReference.get();

    var data = {
      'notificationType': 'confirmAdoption',
      'ownerNotificationToken': ownerNotificationToken,
      'interestedNotificationToken': interestedNotificationToken,
      'confirmed': false,
      'petReference': petReference,
      'petName': pet.data()['name'],
      'ownerReference': ownerReference,      
      'ownerName': user.data()['displayName'],
      'interestedName': interestedName,
      'interestedReference': interestedReference
    };

    // print("DATA $data");

    // QuerySnapshot request = await firestore        
    //     .collection('Adoptions requested')
    //     .where('petReference', isEqualTo: petReference)
    //     .get();

    // request.docs.first.reference.set({'accept': true}, SetOptions(merge: true));

    await firestore.collection('Adopted').doc().set(data);

    final interestedRef = await petReference.collection('adoptInteresteds').get();
    List interestedUsers = interestedRef.docs;

    for (int i = 0; i < interestedUsers.length; i++) {
      print("${interestedUsers[i].data()['position']} == $userPosition");
      if (interestedUsers[i].data()['position'] == userPosition) {
        var data = interestedUsers[i].data();
        data['sinalized'] = true;
        petReference.collection('adoptInteresteds').doc(interestedUsers[i].id).set(data);
        break;
      }
    }
  }

  Future<void> confirmDonate(DocumentReference petReference, DocumentReference userThatAdoptedReference) async {
    await petReference.set({'donated': true, 'whoAdoptedReference': userThatAdoptedReference}, SetOptions(merge: true));
    final pathToPetAdopted = await firestore.collection('Adopted').where('interestedReference', isEqualTo: userThatAdoptedReference).get();
    pathToPetAdopted.docs.first.reference.set({
      'confirmed': true,
      'notificationType': 'adoptionConfirmed',
    }, SetOptions(merge: true));
  }

  Future<void> denyDonate(DocumentReference petReference, DocumentReference userThatAdoptedReference) async {
    final interestedRef = await petReference.collection('adoptInteresteds').get();
    List interestedUsers = interestedRef.docs;
    for (int i = 0; i < interestedUsers.length; i++) {
      if (interestedUsers[i].data()['userReference'] == userThatAdoptedReference) {
        var data = interestedUsers[i].data();
        data['gaveup'] = true;
        data.putIfAbsent('notificationType', () => 'adoptionDeny');
        petReference.collection('adoptInteresteds').doc(interestedUsers[i].id).set(data);
        break;
      }
    }

    final pathToPetAdopted = await firestore.collection('Adopted').where('interestedReference', isEqualTo: userThatAdoptedReference).get();
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

  Future<void> createNotification(String userId, Map<String, dynamic> data) async {
    await firestore
        .collection('Users')
        .doc(userId)
        .collection('Notifications')
        .doc()
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

  Future<int> loadNotificationsCount(String userId) async {
    return firestore
      .collection('Users')
      .doc(userId)
      .collection('Notifications')
      .where('open', isEqualTo: false)
      .snapshots().length;        
  }

  Stream<QuerySnapshot> loadMyPostedPetsToDonate({String userId}) {
    PetController petController = PetController();
    return petController.getPetsByUser('Donate', userId);
   }

  Stream<QuerySnapshot> loadMyPostedPetsDisappeared({String userId}) {
    PetController petController = PetController();
    return petController.getPetsByUser('Disappeared', userId);
  }

  Stream<QuerySnapshot> loadMyAdoptedPets({String userId}) {
    PetController petController = PetController();
    return petController.getPetsByUser('Adopted', userId);
  }

  Stream<QuerySnapshot> loadMyDonatedPets(DocumentReference userReference) {    
    return firestore        
      .collection('Donate')
      .where("donated", isEqualTo: true)        
      .where("ownerReference", isEqualTo: userReference)
      .snapshots();
  }

  Future<void> deleteUserData(DocumentReference userReference) async {
    QuerySnapshot notifications = await userReference.collection('Notifications').get();
    QuerySnapshot petsFavorited = await userReference.collection('Favorites').get();
    
    QuerySnapshot petsDonated = await FirebaseFirestore.instance.collection('Donate')
    .where('ownerReference', isEqualTo: userReference).get();
    QuerySnapshot petsDisappeared = await FirebaseFirestore.instance.collection('Disappeared')
    .where('ownerReference', isEqualTo: userReference).get();
    QuerySnapshot petsAdopted = await FirebaseFirestore.instance.collection('Adopteds')
    .where('interestedReference', isEqualTo: userReference).get();
    
    for(int i = 0; i < notifications.docs.length; i++) {
      await notifications.docs[i].reference.delete();
    }

    for(int i = 0; i < petsDonated.docs.length; i++) {
      await petsDonated.docs[i].reference.delete();
    }

    for(int i = 0; i < petsDisappeared.docs.length; i++) {
      await petsDisappeared.docs[i].reference.delete();
    }

    for(int i = 0; i < petsFavorited.docs.length; i++) {
      await petsFavorited.docs[i].reference.delete();
    }

    for(int i = 0; i < petsAdopted.docs.length; i++) {
      await petsAdopted.docs[i].reference.delete();
    }
    
    await userReference.delete();

    print('Dados de usuário deletados!');
  }

  Future<void> deleteUserAccount(Authentication auth, DocumentReference userReference) async {
    await deleteUserData(userReference);
    await auth.firebaseUser.delete();    
    await auth.signOut();
  }
}
