class PetsPhotos {
  String id;
  String petId;
  String photo;

  Map<String, dynamic> topJson() {
    return {
      'id': id,
      'petId': petId,
      'photo': photo
    };
  }

  Map<String, Object> topMap() {
    var petPhoto = {};
    petPhoto['id'] = id;
    petPhoto['petId'] = petId;
    petPhoto['photo'] = photo;

    return petPhoto;
  }

  // petsPhotos.fromSnapshot(DocumentSnapshot snapshot) {

  // }
}