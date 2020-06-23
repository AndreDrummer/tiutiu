class Pet {
  String id;
  String name;
  int age;  
  String breed;
  String size;
  String details;
  String owner;
  double latitude;
  double longitude;
  String address;

  Pet({
    this.id,
    this.name,
    this.age,    
    this.breed,
    this.size,
    this.details,
    this.owner,
    this.latitude,
    this.longitude,
    this.address
  });

  toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,      
      'breed': breed,
      'size': size,
      'details': details,
      'owner': owner,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  Map<String, Object> toMap() {
    Map<String, Object> petMap = Map<String, Object>();
    petMap["id"] = id;
    petMap["name"] = name;
    petMap["age"] = age;        
    petMap["breed"] = breed;
    petMap["size"] = size;
    petMap["details"] = details;
    petMap["owner"] = owner;
    petMap['latitude'] = latitude;
    petMap['longitude'] = longitude;
    petMap['address'] = address;

    return petMap;
  }

  // Pet.fromSnapshot(DocumentSnapshot snpashot) {

  // }
}
