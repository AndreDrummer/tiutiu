import './user_model.dart';

class Dog {
  String id;
  String name;
  int age;
  List<String> photos;
  String breed;
  String size;
  String details;
  User owner;

  Dog({
    this.id,
    this.name,
    this.age,
    this.photos,
    this.breed,
    this.size,
    this.details,
    this.owner,
  });

  toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'avatar': photos,
      'breed': breed,
      'size': size,
      'details': details,
      'owner': owner
    };
  }

  Map<String, Object> toMap() {
    Map<String, Object> dogMap = Map<String, Object>();
    dogMap["id"] = id;
    dogMap["name"] = name;
    dogMap["age"] = age;
    dogMap["photos"] = photos;
    dogMap["breed"] = breed;
    dogMap["size"] = size;
    dogMap["details"] = details;
    dogMap["owner"] = owner;

    return dogMap;
  }

  // Dog.fromSnapshot(DocumentSnapshot snpashot) {

  // }
}
