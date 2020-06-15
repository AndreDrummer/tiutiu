class AdoptedDonatedDisappeared {
  String ownerId;
  String dogId;

  toJson() {
    return {
      'ownerId': ownerId,
      'dogId': dogId
    };
  }

  Map<String, Object> toMap() {
    Map<String, Object> dogAdoptedMap = Map<String, Object>();
    dogAdoptedMap['ownerId'] = ownerId;
    dogAdoptedMap['dogId'] = dogId;

    return dogAdoptedMap;
  }
}