class AdoptedDonatedDisappeared {
  String? ownerId;
  String? petId;
  String? id;

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'petId': petId,
      'id': id,
    };
  }

  Map<String, dynamic> toMap() {
    var petAdoptedMap = <String, dynamic>{};

    petAdoptedMap['ownerId'] = ownerId;
    petAdoptedMap['petId'] = petId;
    petAdoptedMap['id'] = id;

    return petAdoptedMap;
  }
}
