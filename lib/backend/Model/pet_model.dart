import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/utils/constantes.dart';

class Pet {
  Pet({
    this.otherCaracteristics,
    this.whoAdoptedReference,
    this.donated = false,
    this.storageHashKey,
    this.ownerReference,
    this.found = false,
    this.petReference,
    this.longitude,
    this.ownerName,
    this.createdAt,
    this.latitude,
    this.ownerId,
    this.details,
    this.photos,
    this.health,
    this.color,
    this.views,
    this.avatar,
    this.type,
    this.meses,
    this.breed,
    this.size,
    this.name,
    this.sex,
    this.kind,
    this.ano,
    this.id,
  });

  static Pet fromSnapshot(DocumentSnapshot snapshot) {
    return Pet(
      id: snapshot.id,
      donated: (snapshot.data() as Map<String, dynamic>)['donated'],
      views: (snapshot.data() as Map<String, dynamic>)['views'],
      found: (snapshot.data() as Map<String, dynamic>)['found'],
      kind: (snapshot.data() as Map<String, dynamic>)['kind'],
      storageHashKey:
          (snapshot.data() as Map<String, dynamic>)['storageHashKey'],
      name: (snapshot.data() as Map<String, dynamic>)['name'],
      sex: (snapshot.data() as Map<String, dynamic>)['sex'],
      color: (snapshot.data() as Map<String, dynamic>)['color'],
      type: (snapshot.data() as Map<String, dynamic>)['type'],
      avatar: (snapshot.data() as Map<String, dynamic>)['avatar'],
      health: (snapshot.data() as Map<String, dynamic>)['health'],
      ano: (snapshot.data() as Map<String, dynamic>)['ano'],
      meses: (snapshot.data() as Map<String, dynamic>)['meses'],
      breed: (snapshot.data() as Map<String, dynamic>)['breed'],
      createdAt: (snapshot.data() as Map<String, dynamic>)['createdAt'] ??
          Constantes.APP_BIRTHDAY,
      size: (snapshot.data() as Map<String, dynamic>)['size'],
      details: (snapshot.data() as Map<String, dynamic>)['details'],
      photos: (snapshot.data() as Map<String, dynamic>)['photos'] as List,
      latitude: (snapshot.data() as Map<String, dynamic>)['latitude'],
      longitude: (snapshot.data() as Map<String, dynamic>)['longitude'],
      otherCaracteristics:
          (snapshot.data() as Map<String, dynamic>)['otherCaracteristics'],
      ownerReference:
          (snapshot.data() as Map<String, dynamic>)['ownerReference'],
      ownerId: (snapshot.data() as Map<String, dynamic>)['ownerId'],
      ownerName: (snapshot.data() as Map<String, dynamic>)['ownerName'],
      whoAdoptedReference:
          (snapshot.data() as Map<String, dynamic>)['whoAdoptedReference'],
      petReference: snapshot.reference,
    );
  }

  Pet fromMap(Map<String, dynamic> map) {
    return Pet(
      whoAdoptedReference: map['whoAdoptedReference'],
      otherCaracteristics: map['otherCaracteristics'],
      storageHashKey: map['storageHashKey'],
      ownerReference: map['ownerReference'],
      petReference: map['petReference'],
      photos: map['photos'] as List,
      longitude: map['longitude'],
      createdAt: map['createdAt'],
      ownerName: map['ownerName'],
      latitude: map['latitude'],
      donated: map['donated'],
      details: map['details'],
      ownerId: map['ownerId'],
      avatar: map['avatar'],
      health: map['health'],
      views: map['views'],
      found: map['found'],
      breed: map['breed'],
      meses: map['meses'],
      color: map['color'],
      name: map['name'],
      type: map['type'],
      kind: map['kind'],
      size: map['size'],
      sex: map['sex'],
      ano: map['ano'],
      id: map['id'],
    );
  }

  DocumentReference? whoAdoptedReference;
  DocumentReference? ownerReference;
  DocumentReference? petReference;
  List? otherCaracteristics;
  String? storageHashKey;
  String? createdAt;
  String? ownerName;
  double? longitude;
  double? latitude;
  String? ownerId;
  String? details;
  String? avatar;
  String? health;
  String? color;
  String? breed;
  bool donated;
  String? size;
  String? type;
  String? kind;
  List? photos;
  String? name;
  bool found;
  String? sex;
  String? id;
  int? views;
  int? meses;
  int? ano;

  Map<String, dynamic> toJson() {
    return {
      'whoAdoptedReference': whoAdoptedReference,
      'otherCaracteristics': otherCaracteristics,
      'storageHashKey': storageHashKey,
      'ownerReference': ownerReference,
      'petReference': petReference,
      'longitude': longitude,
      'ownerName': ownerName,
      'createdAt': createdAt,
      'latitude': latitude,
      'ownerId': ownerId,
      'details': details,
      'donated': donated,
      'avatar': avatar,
      'health': health,
      'photos': photos,
      'breed': breed,
      'found': found,
      'views': views,
      'color': color,
      'meses': meses,
      'name': name,
      'size': size,
      'kind': kind,
      'type': type,
      'sex': sex,
      'ano': ano,
      'id': id,
    };
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> petMap = {};

    petMap['otherCaracteristics'] = otherCaracteristics;
    petMap['ownerReference'] = ownerReference;
    petMap['storageHashKey'] = storageHashKey;
    petMap['petReference'] = petReference;
    petMap['createdAt'] = createdAt;
    petMap['ownerName'] = ownerName;
    petMap['longitude'] = longitude;
    petMap['latitude'] = latitude;
    petMap['ownerId'] = ownerId;
    petMap['details'] = details;
    petMap['donated'] = donated;
    petMap['avatar'] = avatar;
    petMap['health'] = health;
    petMap['photos'] = photos;
    petMap['color'] = color;
    petMap['views'] = views;
    petMap['found'] = found;
    petMap['meses'] = meses;
    petMap['breed'] = breed;
    petMap['size'] = size;
    petMap['type'] = type;
    petMap['name'] = name;
    petMap['kind'] = kind;
    petMap['sex'] = sex;
    petMap['ano'] = ano;
    petMap['id'] = id;

    return petMap;
  }
}
