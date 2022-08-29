import 'package:tiutiu/core/extensions/enum_tostring.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum PetEnum {
  otherCaracteristics,
  donatedOrFound,
  storageHashKey,
  longitude,
  createdAt,
  latitude,
  ageMonth,
  details,
  photos,
  ageYear,
  health,
  gender,
  color,
  views,
  breed,
  type,
  owner,
  size,
  name,
  kind,
  id,
}

class Pet {
  Pet({
    this.donatedOrFound = false,
    this.otherCaracteristics,
    this.storageHashKey,
    this.longitude,
    this.createdAt,
    this.latitude,
    this.ageMonth,
    this.details,
    this.photos,
    this.ageYear,
    this.health,
    this.gender,
    this.color,
    this.views,
    this.breed,
    this.type,
    this.owner,
    this.size,
    this.name,
    this.kind,
    this.id,
  });

  static Pet fromSnapshot(DocumentSnapshot snapshot) {
    return Pet(
      otherCaracteristics: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.otherCaracteristics.tostring()],
      donatedOrFound: (snapshot.data()
              as Map<String, dynamic>)[PetEnum.donatedOrFound.tostring()] ??
          false,
      storageHashKey: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.storageHashKey.tostring()],
      longitude: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.longitude.tostring()],
      createdAt: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.createdAt.tostring()],
      latitude: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.latitude.tostring()],
      ageMonth: (snapshot.data()
          as Map<String, dynamic>)[PetEnum.ageMonth.tostring()],
      details:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.details.tostring()],
      photos:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.photos.tostring()],
      ageYear:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.ageYear.tostring()],
      health:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.health.tostring()],
      gender:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.gender.tostring()],
      color:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.color.tostring()],
      views:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.views.tostring()],
      breed:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.breed.tostring()],
      type: (snapshot.data() as Map<String, dynamic>)[PetEnum.type.tostring()],
      owner:
          (snapshot.data() as Map<String, dynamic>)[PetEnum.owner.tostring()],
      size: (snapshot.data() as Map<String, dynamic>)[PetEnum.size.tostring()],
      name: (snapshot.data() as Map<String, dynamic>)[PetEnum.name.tostring()],
      kind: (snapshot.data() as Map<String, dynamic>)[PetEnum.kind.tostring()],
      id: (snapshot.data() as Map<String, dynamic>)[PetEnum.id.tostring()],
    );
  }

  Pet fromMap(Map<String, dynamic> map) {
    return Pet(
      otherCaracteristics: map[PetEnum.otherCaracteristics.tostring()],
      donatedOrFound: map[PetEnum.donatedOrFound.tostring()],
      storageHashKey: map[PetEnum.storageHashKey.tostring()],
      longitude: map[PetEnum.longitude.tostring()],
      createdAt: map[PetEnum.createdAt.tostring()],
      latitude: map[PetEnum.latitude.tostring()],
      ageMonth: map[PetEnum.ageMonth.tostring()],
      details: map[PetEnum.details.tostring()],
      photos: map[PetEnum.photos.tostring()],
      ageYear: map[PetEnum.ageYear.tostring()],
      health: map[PetEnum.health.tostring()],
      gender: map[PetEnum.gender.tostring()],
      color: map[PetEnum.color.tostring()],
      views: map[PetEnum.views.tostring()],
      breed: map[PetEnum.breed.tostring()],
      type: map[PetEnum.type.tostring()],
      owner: map[PetEnum.owner.tostring()],
      size: map[PetEnum.size.tostring()],
      name: map[PetEnum.name.tostring()],
      kind: map[PetEnum.kind.tostring()],
      id: map[PetEnum.id.tostring()],
    );
  }

  List? otherCaracteristics;
  String? storageHashKey;
  bool donatedOrFound;
  String? createdAt;
  double? longitude;
  double? latitude;
  String? ownerId;
  String? details;
  String? avatar;
  String? gender;
  String? health;
  String? color;
  int? ageMonth;
  String? breed;
  String? owner;
  int? ageYear;
  String? size;
  String? type;
  String? kind;
  List? photos;
  String? name;
  String? id;
  int? views;

  Map<String, dynamic> toMap() {
    return {
      PetEnum.otherCaracteristics.tostring(): otherCaracteristics,
      PetEnum.donatedOrFound.tostring(): donatedOrFound,
      PetEnum.storageHashKey.tostring(): storageHashKey,
      PetEnum.longitude.tostring(): longitude,
      PetEnum.createdAt.tostring(): createdAt,
      PetEnum.latitude.tostring(): latitude,
      PetEnum.ageMonth.tostring(): ageMonth,
      PetEnum.details.tostring(): details,
      PetEnum.photos.tostring(): photos,
      PetEnum.ageYear.tostring(): ageYear,
      PetEnum.health.tostring(): health,
      PetEnum.gender.tostring(): gender,
      PetEnum.color.tostring(): color,
      PetEnum.views.tostring(): views,
      PetEnum.breed.tostring(): breed,
      PetEnum.type.tostring(): type,
      PetEnum.owner.tostring(): owner,
      PetEnum.size.tostring(): size,
      PetEnum.name.tostring(): name,
      PetEnum.kind.tostring(): kind,
      PetEnum.id.tostring(): id,
    };
  }
}
