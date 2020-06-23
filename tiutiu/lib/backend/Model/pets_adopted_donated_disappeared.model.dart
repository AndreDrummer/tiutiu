class AdoptedDonatedDisappeared {
  String id;
  String ownerId;
  String petId;

  toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'petId': petId
    };
  }

  Map<String, Object> toMap() {
    Map<String, Object> petAdoptedMap = Map<String, Object>();
    petAdoptedMap['id'] = id;
    petAdoptedMap['ownerId'] = ownerId;
    petAdoptedMap['petId'] = petId;

    return petAdoptedMap;
  }
}