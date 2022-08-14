import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/extensions/enum_tostring.dart';
import 'package:tiutiu/utils/constantes.dart';

enum PetEnum {
  otherCaracteristics,
  whoAdoptedReference,
  storageHashKey,
  ownerReference,
  petReference,
  longitude,
  ownerName,
  createdAt,
  latitude,
  ownerId,
  details,
  donated,
  photos,
  avatar,
  found,
  health,
  color,
  views,
  meses,
  breed,
  type,
  size,
  name,
  kind,
  ano,
  sex,
  id,
}

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
      createdAt: (snapshot.data()
              as Map<String, dynamic>)[PetEnum.createdAt.tostring()] ??
          Constantes.APP_BIRTHDAY,
      whoAdoptedReference: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.whoAdoptedReference.tostring()],
      otherCaracteristics: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.otherCaracteristics.tostring()],
      ownerReference: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.ownerReference.tostring()],
      storageHashKey: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.storageHashKey.tostring()],
      photos: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.photos.tostring()] as List,
      longitude: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.longitude.tostring()],
      ownerName: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.ownerName.tostring()],
      latitude: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.latitude.tostring()],
      donated:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.donated.tostring()],
      details:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.details.tostring()],
      ownerId:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.ownerId.tostring()],
      avatar:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.avatar.tostring()],
      health:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.health.tostring()],
      views:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.views.tostring()],
      found:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.found.tostring()],
      meses:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.meses.tostring()],
      breed:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.breed.tostring()],
      color:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.color.tostring()],
      kind: (snapshot.data() as Map<String, dynamic>)[PetEnum.kind.tostring()],
      name: (snapshot.data() as Map<String, dynamic>)[PetEnum.name.tostring()],
      type: (snapshot.data() as Map<String, dynamic>)[PetEnum.type.tostring()],
      size: (snapshot.data() as Map<String, dynamic>)[PetEnum.size.tostring()],
      sex: (snapshot.data() as Map<String, dynamic>)[PetEnum.sex.tostring()],
      ano: (snapshot.data() as Map<String, dynamic>)[PetEnum.ano.tostring()],
      petReference: snapshot.reference,
      id: snapshot.id,
    );
  }

  Pet fromMap(Map<String, dynamic> map) {
    return Pet(
      whoAdoptedReference: map[PetEnum.whoAdoptedReference.tostring()],
      otherCaracteristics: map[PetEnum.otherCaracteristics.tostring()],
      storageHashKey: map[PetEnum.storageHashKey.tostring()],
      ownerReference: map[PetEnum.ownerReference.tostring()],
      petReference: map[PetEnum.petReference.tostring()],
      photos: map[PetEnum.photos.tostring()] as List,
      longitude: map[PetEnum.longitude.tostring()],
      createdAt: map[PetEnum.createdAt.tostring()],
      ownerName: map[PetEnum.ownerName.tostring()],
      latitude: map[PetEnum.latitude.tostring()],
      donated: map[PetEnum.donated.tostring()],
      details: map[PetEnum.details.tostring()],
      ownerId: map[PetEnum.ownerId.tostring()],
      avatar: map[PetEnum.avatar.tostring()],
      health: map[PetEnum.health.tostring()],
      views: map[PetEnum.views.tostring()],
      found: map[PetEnum.found.tostring()],
      breed: map[PetEnum.breed.tostring()],
      meses: map[PetEnum.meses.tostring()],
      color: map[PetEnum.color.tostring()],
      name: map[PetEnum.name.tostring()],
      type: map[PetEnum.type.tostring()],
      kind: map[PetEnum.kind.tostring()],
      size: map[PetEnum.size.tostring()],
      sex: map[PetEnum.sex.tostring()],
      ano: map[PetEnum.ano.tostring()],
      id: map[PetEnum.id.tostring()],
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

  Map<String, dynamic> toMap() {
    return {
      PetEnum.whoAdoptedReference.tostring(): whoAdoptedReference,
      PetEnum.otherCaracteristics.tostring(): otherCaracteristics,
      PetEnum.ownerReference.tostring(): ownerReference,
      PetEnum.storageHashKey.tostring(): storageHashKey,
      PetEnum.petReference.tostring(): petReference,
      PetEnum.createdAt.tostring(): createdAt,
      PetEnum.longitude.tostring(): longitude,
      PetEnum.ownerName.tostring(): ownerName,
      PetEnum.latitude.tostring(): latitude,
      PetEnum.donated.tostring(): donated,
      PetEnum.details.tostring(): details,
      PetEnum.ownerId.tostring(): ownerId,
      PetEnum.avatar.tostring(): avatar,
      PetEnum.health.tostring(): health,
      PetEnum.photos.tostring(): photos,
      PetEnum.views.tostring(): views,
      PetEnum.found.tostring(): found,
      PetEnum.meses.tostring(): meses,
      PetEnum.breed.tostring(): breed,
      PetEnum.color.tostring(): color,
      PetEnum.kind.tostring(): kind,
      PetEnum.name.tostring(): name,
      PetEnum.type.tostring(): type,
      PetEnum.size.tostring(): size,
      PetEnum.sex.tostring(): sex,
      PetEnum.ano.tostring(): ano,
      PetEnum.id.tostring(): id,
    };
  }
}
