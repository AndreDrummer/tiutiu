import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  Pet({
    this.id,
    this.name,
    this.sex,
    this.color,    
    this.ownerReference,    
    this.petReference,    
    this.otherCaracteristics,
    this.type,
    this.avatar,
    this.health,
    this.ano,
    this.meses,
    this.breed,
    this.size,
    this.details,
    this.photos,    
    this.latitude,
    this.longitude,    
    this.kind
  });

  Pet.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    kind = snapshot.data()['kind'];
    name = snapshot.data()['name'];
    sex = snapshot.data()['sex'];
    color = snapshot.data()['color'];
    type = snapshot.data()['type'];    
    avatar = snapshot.data()['avatar'];
    health = snapshot.data()['health'];
    ano = snapshot.data()['ano'];
    meses = snapshot.data()['meses'];
    breed = snapshot.data()['breed'];
    size = snapshot.data()['size'];
    details = snapshot.data()['details'];
    photos = snapshot.data()['photos'] as Map<String, dynamic>;
    latitude = snapshot.data()['latitude'];
    longitude = snapshot.data()['longitude'];
    otherCaracteristics = snapshot.data()['otherCaracteristics'];    
    ownerReference = snapshot.data()['ownerReference'];
    petReference = snapshot.reference;
  }

  Pet.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    kind = map['kind'];
    name = map['name'];
    color = map['color'];
    type = map['type'];    
    avatar = map['avatar'];
    sex = map['sex'];
    health = map['health'];
    otherCaracteristics = map['otherCaracteristics'];
    ano = map['ano'];
    meses = map['meses'];
    breed = map['breed'];
    size = map['size'];
    details = map['details'];
    photos = map['photos'] as Map<String, dynamic>;
    latitude = map['latitude'];
    longitude = map['longitude'];    
    ownerReference = map['ownerReference'];
    petReference = map['petReference'];
  }

  String id;
  String name;
  String sex;
  String kind;
  String color;
  String type;
  DocumentReference ownerReference;
  DocumentReference petReference;
  String avatar;
  String health;
  int ano;  
  int meses;
  String breed;
  List otherCaracteristics;
  String size;
  String details;
  Map photos;  
  double latitude;
  double longitude;  

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kind': kind,
      'color': color,
      'avatar': avatar,
      'sex': sex,
      'health': health,
      'ano': ano,
      'meses': meses,
      'breed': breed,
      'photos': photos,
      'size': size,
      'otherCaracteristics': otherCaracteristics,
      'details': details,            
      'latitude': latitude,
      'longitude': longitude,      
      'type': type,
      'ownerReference': ownerReference,      
      'petReference': petReference
    };
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> petMap = {};
    petMap['id'] = id;
    petMap['name'] = name;
    petMap['kind'] = kind;
    petMap['avatar'] = avatar;
    petMap['sex'] = sex;
    petMap['health'] = health;
    petMap['ano'] = ano;
    petMap['meses'] = meses;
    petMap['breed'] = breed;
    petMap['size'] = size;
    petMap['otherCaracteristics'] = otherCaracteristics;
    petMap['details'] = details;
    petMap['photos'] = photos;        
    petMap['latitude'] = latitude;
    petMap['longitude'] = longitude;    
    petMap['type'] = type;
    petMap['color'] = color;    
    petMap['ownerReference'] = ownerReference;
    petMap['petReference'] = petReference;

    return petMap;
  }
}
