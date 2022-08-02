class PetsPhotos {
  String? petId;
  String? photo;
  String? id;

  Map<String, dynamic> topJson() {
    return {
      'petId': petId,
      'photo': photo,
      'id': id,
    };
  }

  Map<String, dynamic> topMap() {
    var petPhoto = <String, dynamic>{};
    petPhoto['petId'] = petId;
    petPhoto['photo'] = photo;
    petPhoto['id'] = id;

    return petPhoto;
  }
}
