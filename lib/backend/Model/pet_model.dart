import 'package:cloud_firestore/cloud_firestore.dart';

const String appBirthday = '2020-10-28T18:54:56.905834';
class Pet {
  Pet({
    this.id,
    this.donated,
    this.found,
    this.storageHashKey,
    this.name,
    this.sex,
    this.color,    
    this.ownerReference,    
    this.ownerId,    
    this.petReference,    
    this.otherCaracteristics,
    this.type,
    this.createdAt,
    this.views,
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
    this.whoAdoptedReference,    
    this.kind
  });

  Pet.fromSnapshot(DocumentSnapshot snapshot) {    
    id = snapshot.id;
    donated = snapshot.data()['donated'];
    views = snapshot.data()['views'];
    found = snapshot.data()['found'];
    kind = snapshot.data()['kind'];
    storageHashKey = snapshot.data()['storageHashKey'];
    name = snapshot.data()['name'];
    sex = snapshot.data()['sex'];
    color = snapshot.data()['color'];
    type = snapshot.data()['type'];    
    avatar = snapshot.data()['avatar'];
    health = snapshot.data()['health'];
    ano = snapshot.data()['ano'];
    meses = snapshot.data()['meses'];
    breed = snapshot.data()['breed'];
    createdAt = snapshot.data()['createdAt'] ?? appBirthday;
    size = snapshot.data()['size'];
    details = snapshot.data()['details'];
    photos = snapshot.data()['photos'] as List;
    latitude = snapshot.data()['latitude'];
    longitude = snapshot.data()['longitude'];
    otherCaracteristics = snapshot.data()['otherCaracteristics'];    
    ownerReference = snapshot.data()['ownerReference'];
    ownerId = snapshot.data()['ownerId'];
    whoAdoptedReference = snapshot.data()['whoAdoptedReference'];
    petReference = snapshot.reference;
  }

  Pet.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    donated = map['donated'];
    views = map['views'];
    found = map['found'];
    kind = map['kind'];
    name = map['name'];
    storageHashKey = map['storageHashKey'];
    color = map['color'];
    type = map['type'];    
    avatar = map['avatar'];
    sex = map['sex'];
    health = map['health'];
    otherCaracteristics = map['otherCaracteristics'];
    ano = map['ano'];
    meses = map['meses'];
    breed = map['breed'];
    createdAt = map['createdAt'];
    size = map['size'];
    details = map['details'];
    photos = map['photos'] as List;
    latitude = map['latitude'];
    longitude = map['longitude'];    
    ownerReference = map['ownerReference'];
    ownerId = map['ownerId'];
    petReference = map['petReference'];
    whoAdoptedReference = map['whoAdoptedReference'];
  }

  String id;
  int views;
  String name;
  String storageHashKey;
  bool donated;
  bool found;
  String sex;
  String kind;
  String color;
  String type;
  DocumentReference ownerReference;
  String ownerId;
  DocumentReference petReference;
  DocumentReference whoAdoptedReference;
  String avatar;
  String health;
  String createdAt;
  int ano;  
  int meses;
  String breed;
  List otherCaracteristics;
  String size;
  String details;
  List photos;  
  double latitude;
  double longitude;  

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'donated': donated,
      'found': found,
      'views': views,
      'name': name,
      'storageHashKey': storageHashKey,
      'kind': kind,
      'color': color,
      'avatar': avatar,
      'sex': sex,
      'health': health,
      'ano': ano,
      'meses': meses,
      'createdAt': createdAt,
      'breed': breed,
      'photos': photos,
      'size': size,
      'otherCaracteristics': otherCaracteristics,
      'details': details,            
      'latitude': latitude,
      'longitude': longitude,      
      'type': type,
      'ownerReference': ownerReference,      
      'ownerId': ownerId,      
      'petReference': petReference,
      'whoAdoptedReference': whoAdoptedReference
    };
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> petMap = {};
    petMap['id'] = id;
    petMap['name'] = name;
    petMap['donated'] = donated;
    petMap['found'] = found;
    petMap['kind'] = kind;
    petMap['storageHashKey'] = storageHashKey;
    petMap['avatar'] = avatar;
    petMap['sex'] = sex;
    petMap['views'] = views;
    petMap['health'] = health;
    petMap['createdAt'] = createdAt;
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
    petMap['ownerId'] = ownerId;
    petMap['petReference'] = petReference;

    return petMap;
  }
}
