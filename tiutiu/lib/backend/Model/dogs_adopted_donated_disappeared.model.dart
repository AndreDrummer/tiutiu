class AdoptedDonatedDisappeared {
  String id;
  String ownerId;
  String dogId;

  toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'dogId': dogId
    };
  }

  Map<String, Object> toMap() {
    Map<String, Object> dogAdoptedMap = Map<String, Object>();
    dogAdoptedMap['id'] = id;
    dogAdoptedMap['ownerId'] = ownerId;
    dogAdoptedMap['dogId'] = dogId;

    return dogAdoptedMap;
  }
}