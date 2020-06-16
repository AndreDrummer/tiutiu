class Dog {
  String id;
  String name;
  int age;  
  String breed;
  String size;
  String details;
  String owner;

  Dog({
    this.id,
    this.name,
    this.age,    
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
    dogMap["breed"] = breed;
    dogMap["size"] = size;
    dogMap["details"] = details;
    dogMap["owner"] = owner;

    return dogMap;
  }

  // Dog.fromSnapshot(DocumentSnapshot snpashot) {

  // }
}
