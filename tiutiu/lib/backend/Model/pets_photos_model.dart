class PetsPhotos {
  String id;
  String petId;
  String photo;

  topJson() {
    return {
      'id': id,
      'petId': petId,
      'photo': photo
    };
  }

  Map<String, Object> topMap() {
    Map<String, Object> petPhoto = Map<String, Object>();
    petPhoto['id'] = id;
    petPhoto['petId'] = petId;
    petPhoto['photo'] = photo;

    return petPhoto;
  }

  // petsPhotos.fromSnapshot(DocumentSnapshot snapshot) {

  // }
}