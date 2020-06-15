class DogsPhotos {
  String id;
  String dogId;
  String photo;

  topJson() {
    return {
      'id': id,
      'dogId': dogId,
      'photo': photo
    };
  }

  Map<String, Object> topMap() {
    Map<String, Object> dogPhoto = Map<String, Object>();
    dogPhoto['id'] = id;
    dogPhoto['dogId'] = dogId;
    dogPhoto['photo'] = photo;

    return dogPhoto;
  }

  // DogsPhotos.fromSnapshot(DocumentSnapshot snapshot) {

  // }
}