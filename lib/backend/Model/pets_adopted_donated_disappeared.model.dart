class AdoptedDonatedDisappeared {
  String id;
  String ownerId;
  String petId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'petId': petId
    };
  }

  Map<String, Object> toMap() {
    var petAdoptedMap = {};
    petAdoptedMap['id'] = id;
    petAdoptedMap['ownerId'] = ownerId;
    petAdoptedMap['petId'] = petId;

    return petAdoptedMap;
  }
}