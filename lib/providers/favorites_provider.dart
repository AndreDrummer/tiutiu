import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/auth2.dart';

class FavoritesProvider with ChangeNotifier {

  FavoritesProvider([this.auth]);
  final Authentication auth;

  final _favoritesListReference = BehaviorSubject<List<QueryDocumentSnapshot>>();
  final _favoritesPETSList = BehaviorSubject<List<Pet>>();
  final _favoritesPETSIDList = BehaviorSubject<List<String>>.seeded([]);

  
  Stream<List<QueryDocumentSnapshot>> get favoritesListReference => _favoritesListReference.stream;
  void Function(List<QueryDocumentSnapshot>) get changefavoritesListReference => _favoritesListReference.sink.add;
  List<QueryDocumentSnapshot> get getFavoritesListReference => _favoritesListReference.value;

  Stream<List<Pet>> get favoritesPETSList => _favoritesPETSList.stream;
  void Function(List<Pet>) get changeFavoritesPETSList => _favoritesPETSList.sink.add;
  List<Pet> get getFavoritesPETSList => _favoritesPETSList.value;

  Stream<List<String>> get favoritesPETSIDList => _favoritesPETSIDList.stream;
  void Function(List<String>) get changeFavoritesPETSIDList => _favoritesPETSIDList.sink.add;
  List<String> get getFavoritesPETSIDList => _favoritesPETSIDList.value;

  Future<void> loadFavoritesReference() async {        
    CollectionReference dataBaseCollection = FirebaseFirestore.instance.collection('Users');
    final favoritesListReference = await dataBaseCollection.doc(auth.firebaseUser.uid).collection('Pets').doc('favorites').collection('favorites').get();    
    changefavoritesListReference(favoritesListReference.docs);
    loadPETsFavorites();
    notifyListeners();
  }

  Future<void> loadPETsFavorites() async {    
    List<Pet> petFavoritesList = [];
    List<String> petFavoritesID = [];
    
    print("HEY ${getFavoritesListReference.length}");

    for(int  i = 0; i < getFavoritesListReference.length; i++) {                  
      petFavoritesList.add(Pet.fromSnapshot(await (getFavoritesListReference[i].data()['id'] as DocumentReference).get()));
      petFavoritesID.add(Pet.fromSnapshot(await (getFavoritesListReference[i].data()['id'] as DocumentReference).get()).id);      
    }
    
    changeFavoritesPETSList(petFavoritesList);
    changeFavoritesPETSIDList(petFavoritesID);
    notifyListeners();
  }

  bool handleFavorite(String id) {
    if(getFavoritesPETSIDList.contains(id)) {
      var tempList = getFavoritesPETSIDList;
      tempList.remove(id);
      print('removeu');
      changeFavoritesPETSIDList([]);

    }
    notifyListeners();
    return getFavoritesPETSIDList.contains(id);
  }

}