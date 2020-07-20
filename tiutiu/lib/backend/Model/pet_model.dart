import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {  
  String name;
  String health;
  int ano;  
  int meses;  
  String breed;
  String size;
  String details;
  Map<String, String> photos;
  String owner;
  double latitude;
  double longitude;
  String address;

  Pet({    
    this.name,
    this.health,
    this.ano,    
    this.meses,    
    this.breed,
    this.size,
    this.details,
    this.photos,
    this.owner,
    this.latitude,
    this.longitude,
    this.address
  });

  toJson() {
    return {      
      'name': name,
      'health': health,
      'ano': ano,      
      'meses': meses,      
      'breed': breed,
      'photos': photos,
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
    petMap["name"] = name;
    petMap["health"] = health;
    petMap["ano"] = ano;        
    petMap["meses"] = meses;        
    petMap["breed"] = breed;
    petMap["size"] = size;
    petMap["details"] = details;
    petMap["photos"] = photos;
    petMap["owner"] = owner;
    petMap['latitude'] = latitude;
    petMap['longitude'] = longitude;
    petMap['address'] = address;

    return petMap;
  }

  Pet.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot.data["name"];
    health = snapshot.data["health"];
    ano = snapshot.data["ano"];
    meses = snapshot.data["meses"];
    breed = snapshot.data["breed"];
    size = snapshot.data["size"];
    details = snapshot.data["details"];
    photos = snapshot.data["photos"];
    owner = snapshot.data["owner"];
    latitude = snapshot.data['latitude'];
    longitude = snapshot.data['longitude'];
    address = snapshot.data['address'];
  }
}
