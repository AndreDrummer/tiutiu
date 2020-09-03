import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
   Pet({    
    this.name,
    this.ownerPhoneNumber,
    this.ownerPhotoURL,
    this.type,
    this.avatar,
    this.health,
    this.ano,    
    this.meses,    
    this.breed,
    this.size,
    this.details,
    this.photos,    
    this.ownerName,
    this.ownerId,
    this.latitude,
    this.longitude,
    this.address
  });

  Pet.fromSnapshot(DocumentSnapshot snapshot) {  
    
    name = snapshot.data()['name'];
    type = snapshot.data()['type'];
    ownerPhotoURL = snapshot.data()['ownerPhotoURL'];
    ownerPhoneNumber = snapshot.data()['ownerPhoneNumber'];
    avatar = snapshot.data()['avatar'];
    health = snapshot.data()['health'];
    ano = snapshot.data()['ano'];
    meses = snapshot.data()['meses'];
    breed = snapshot.data()['breed'];
    size = snapshot.data()['size'];
    details = snapshot.data()['details'];
    photos = snapshot.data()['photos'] as Map<String, dynamic>;
    ownerId = snapshot.data()['ownerId'];    
    ownerName = snapshot.data()['ownerName'];
    latitude = snapshot.data()['latitude'];
    longitude = snapshot.data()['longitude'];
    address = snapshot.data()['address'];
  }

  String name;
  String type;
  String ownerPhotoURL;
  String ownerPhoneNumber;
  String avatar;
  String health;
  int ano;  
  int meses;  
  String breed;
  String size;
  String details;
  Map photos;  
  String ownerName;
  String ownerId;
  double latitude;
  double longitude;
  String address;

  Map<String, dynamic> toJson() {
    return {      
      'name': name,
      'avatar': avatar,
      'health': health,
      'ano': ano,      
      'meses': meses,      
      'breed': breed,
      'photos': photos,
      'size': size,
      'details': details,
      'ownerId': ownerId,      
      'ownerName': ownerName,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

   Map<String, dynamic> toMap() {
    Map<String, dynamic> petMap = {};    
    petMap['name'] = name;
    petMap['avatar'] = avatar;
    petMap['health'] = health;
    petMap['ano'] = ano;        
    petMap['meses'] = meses;        
    petMap['breed'] = breed;
    petMap['size'] = size;
    petMap['details'] = details;
    petMap['photos'] = photos;
    petMap['ownerId'] = ownerId;    
    petMap['ownerName'] = ownerName;
    petMap['latitude'] = latitude;
    petMap['longitude'] = longitude;
    petMap['address'] = address;

    return petMap;
  }
}
