class Dog {
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

  Dog({
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
    Map<String, Object> dogMap = Map<String, Object>();
    dogMap["id"] = id;
    dogMap["name"] = name;
    dogMap["age"] = age;        
    dogMap["breed"] = breed;
    dogMap["size"] = size;
    dogMap["details"] = details;
    dogMap["owner"] = owner;
    dogMap['latitude'] = latitude;
    dogMap['longitude'] = longitude;
    dogMap['address'] = address;

    return dogMap;
  }

  // Dog.fromSnapshot(DocumentSnapshot snpashot) {

  // }
}
