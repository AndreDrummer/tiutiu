import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  Pet({
    this.id,
    this.name,
    this.color,    
    this.ownerReference,    
    this.petReference,    
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
    this.address,
  });

  Pet.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.data()['name'];
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
    address = snapshot.data()['address'];    
    ownerReference = snapshot.data()['ownerReference'];
    petReference = snapshot.reference;
  }

  String id;
  String name;
  String color;
  String type;
  DocumentReference ownerReference;
  DocumentReference petReference;
  String avatar;
  String health;
  int ano;  
  int meses;
  String breed;
  String size;
  String details;
  Map photos;  
  double latitude;
  double longitude;
  String address;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'avatar': avatar,
      'health': health,
      'ano': ano,
      'meses': meses,
      'breed': breed,
      'photos': photos,
      'size': size,
      'details': details,            
      'latitude': latitude,
      'longitude': longitude,
      'address': address,      
      'type': type,
      'ownerReference': ownerReference,      
      'petReference': petReference
    };
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> petMap = {};
    petMap['id'] = id;
    petMap['name'] = name;
    petMap['avatar'] = avatar;
    petMap['health'] = health;
    petMap['ano'] = ano;
    petMap['meses'] = meses;
    petMap['breed'] = breed;
    petMap['size'] = size;
    petMap['details'] = details;
    petMap['photos'] = photos;        
    petMap['latitude'] = latitude;
    petMap['longitude'] = longitude;
    petMap['address'] = address;  
    petMap['type'] = type;
    petMap['color'] = color;    
    petMap['ownerReference'] = ownerReference;
    petMap['petReference'] = petReference;

    return petMap;
  }
}
