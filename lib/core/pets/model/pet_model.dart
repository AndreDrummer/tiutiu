import 'package:tiutiu/core/system/model/system.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

enum PetEnum {
  otherCaracteristics,
  chronicDiseaseInfo,
  lastSeenDetails,
  donatedOrFound,
  disappeared,
  ageMonth,
  ageYear,
  reward,
  gender,
  health,
  color,
  breed,
  size,
}

class Pet extends Post {
  Pet({
    this.otherCaracteristics = const [],
    List dennounceMotives = const [],
    String country = defaultCountry,
    DocumentReference? reference,
    this.chronicDiseaseInfo = '',
    String describedAddress = '',
    this.donatedOrFound = false,
    this.lastSeenDetails = '',
    String city = 'Acrelândia',
    this.disappeared = false,
    String description = '',
    int timesDennounced = 0,
    List photos = const [],
    String state = 'Acre',
    String? createdAt,
    double? longitude,
    this.ageMonth = 0,
    String type = '-',
    this.gender = '-',
    TiutiuUser? owner,
    this.health = '-',
    this.ageYear = 0,
    double? latitude,
    this.color = '-',
    this.breed = '',
    this.size = '-',
    String? ownerId,
    this.reward = '',
    int likes = 0,
    int saved = 0,
    int sharedTimes = 0,
    int views = 0,
    dynamic video,
    String? name,
    String? uid,
  }) : super(
          describedAddress: describedAddress,
          dennounceMotives: dennounceMotives,
          timesDennounced: timesDennounced,
          sharedTimes: sharedTimes,
          description: description,
          hidden: donatedOrFound,
          longitude: longitude,
          reference: reference,
          done: donatedOrFound,
          createdAt: createdAt,
          latitude: latitude,
          ownerId: ownerId,
          country: country,
          photos: photos,
          state: state,
          views: views,
          owner: owner,
          video: video,
          saved: saved,
          likes: likes,
          city: city,
          type: type,
          name: name,
          uid: uid,
        );

  @override
  Pet fromMap(Map<String, dynamic> map) {
    return Pet(
      dennounceMotives: map[PostEnum.dennounceMotives.name] ?? super.dennounceMotives,
      timesDennounced: map[PostEnum.timesDennounced.name] ?? super.timesDennounced,
      createdAt: map[PostEnum.createdAt.name] ?? DateTime.now().toIso8601String(),
      uid: map[PostEnum.uid.name] != null ? map[PostEnum.uid.name] : Uuid().v4(),
      otherCaracteristics: map[PetEnum.otherCaracteristics.name] ?? [],
      chronicDiseaseInfo: map[PetEnum.chronicDiseaseInfo.name] ?? '',
      describedAddress: map[PostEnum.describedAddress.name] ?? '',
      donatedOrFound: map[PetEnum.donatedOrFound.name] ?? false,
      lastSeenDetails: map[PetEnum.lastSeenDetails.name] ?? '',
      reference: getReference(map[PostEnum.reference.name]),
      disappeared: map[PetEnum.disappeared.name] ?? false,
      country: map[PostEnum.country.name] ?? defaultCountry,
      owner: TiutiuUser.fromMap(map[PostEnum.owner.name]),
      description: map[PostEnum.description.name] ?? '',
      sharedTimes: map[PostEnum.sharedTimes.name] ?? 0,
      city: map[PostEnum.city.name] ?? 'Acrelândia',
      state: map[PostEnum.state.name] ?? 'Acre',
      ageMonth: map[PetEnum.ageMonth.name] ?? 0,
      health: map[PetEnum.health.name] ?? '-',
      gender: map[PetEnum.gender.name] ?? '-',
      longitude: map[PostEnum.longitude.name],
      ageYear: map[PetEnum.ageYear.name] ?? 0,
      saved: map[PostEnum.saved.name] ?? 0,
      color: map[PetEnum.color.name] ?? '-',
      breed: map[PetEnum.breed.name] ?? '-',
      reward: map[PetEnum.reward.name] ?? '',
      latitude: map[PostEnum.latitude.name],
      views: map[PostEnum.views.name] ?? 0,
      size: map[PetEnum.size.name] ?? '-',
      type: map[PostEnum.type.name] ?? '-',
      likes: map[PostEnum.likes.name] ?? 0,
      ownerId: map[PostEnum.ownerId.name],
      photos: map[PostEnum.photos.name],
      video: map[PostEnum.video.name],
      name: map[PostEnum.name.name],
    );
  }

  Pet copyWith({
    DocumentReference? reference,
    String? chronicDiseaseInfo,
    List? otherCaracteristics,
    String? describedAddress,
    String? lastSeenDetails,
    List? dennounceMotives,
    int? timesDennounced,
    bool? donatedOrFound,
    String? description,
    bool? disappeared,
    String? createdAt,
    TiutiuUser? owner,
    double? longitude,
    double? latitude,
    int? sharedTimes,
    String? ownerId,
    String? country,
    String? health,
    String? reward,
    String? gender,
    int? ageMonth,
    String? color,
    String? state,
    String? video,
    String? breed,
    String? size,
    String? city,
    List? photos,
    int? ageYear,
    String? type,
    String? name,
    String? uid,
    int? likes,
    int? views,
    int? saved,
  }) {
    return Pet(
      otherCaracteristics: otherCaracteristics ?? this.otherCaracteristics,
      chronicDiseaseInfo: chronicDiseaseInfo ?? this.chronicDiseaseInfo,
      describedAddress: describedAddress ?? this.describedAddress,
      dennounceMotives: dennounceMotives ?? this.dennounceMotives,
      lastSeenDetails: lastSeenDetails ?? this.lastSeenDetails,
      timesDennounced: timesDennounced ?? this.timesDennounced,
      donatedOrFound: donatedOrFound ?? this.donatedOrFound,
      disappeared: disappeared ?? this.disappeared,
      description: description ?? this.description,
      sharedTimes: sharedTimes ?? this.sharedTimes,
      createdAt: createdAt ?? this.createdAt,
      reference: reference ?? this.reference,
      longitude: longitude ?? this.longitude,
      ageMonth: ageMonth ?? this.ageMonth,
      latitude: latitude ?? this.latitude,
      ownerId: ownerId ?? this.ownerId,
      country: country ?? this.country,
      ageYear: ageYear ?? this.ageYear,
      gender: gender ?? this.gender,
      photos: photos ?? this.photos,
      reward: reward ?? this.reward,
      health: health ?? this.health,
      owner: owner ?? this.owner,
      state: state ?? this.state,
      saved: saved ?? this.saved,
      color: color ?? this.color,
      breed: breed ?? this.breed,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      video: video ?? this.video,
      city: city ?? this.city,
      name: name ?? this.name,
      size: size ?? this.size,
      type: type ?? this.type,
      uid: uid ?? this.uid,
    );
  }

  String chronicDiseaseInfo;
  List otherCaracteristics;
  String lastSeenDetails;
  bool donatedOrFound;
  bool disappeared;
  String gender;
  String health;
  String reward;
  int ageMonth;
  String breed;
  String color;
  String size;
  int ageYear;

  @override
  Map<String, dynamic> toMap({bool convertFileToVideoPath = false}) {
    return {
      PostEnum.photos.name: convertFileToVideoPath ? photos.map((e) => e.path).toList() : photos,
      PostEnum.reference.name: reference != null ? reference.toString() : null,
      PostEnum.video.name: convertFileToVideoPath ? video.path : video,
      PetEnum.otherCaracteristics.name: otherCaracteristics,
      PetEnum.chronicDiseaseInfo.name: chronicDiseaseInfo,
      PostEnum.owner.name: _adequatedMap(owner?.toMap()),
      PostEnum.describedAddress.name: describedAddress,
      PostEnum.dennounceMotives.name: dennounceMotives,
      PostEnum.timesDennounced.name: timesDennounced,
      PetEnum.lastSeenDetails.name: lastSeenDetails,
      PetEnum.donatedOrFound.name: donatedOrFound,
      PostEnum.sharedTimes.name: sharedTimes,
      PostEnum.description.name: description,
      PetEnum.disappeared.name: disappeared,
      PostEnum.longitude.name: longitude,
      PostEnum.createdAt.name: createdAt,
      PostEnum.latitude.name: latitude,
      PetEnum.ageMonth.name: ageMonth,
      PostEnum.ownerId.name: ownerId,
      PostEnum.country.name: country,
      PetEnum.ageYear.name: ageYear,
      PetEnum.health.name: health,
      PetEnum.gender.name: gender,
      PetEnum.reward.name: reward,
      PostEnum.state.name: state,
      PostEnum.views.name: views,
      PostEnum.saved.name: saved,
      PostEnum.likes.name: likes,
      PetEnum.color.name: color,
      PetEnum.breed.name: breed,
      PostEnum.type.name: type,
      PostEnum.name.name: name,
      PostEnum.city.name: city,
      PetEnum.size.name: size,
      PostEnum.uid.name: uid,
    };
  }

  Map<String, dynamic>? _adequatedMap(Map<String, dynamic>? map) {
    if ((map?.containsKey(PostEnum.reference.name) ?? false) && map?[PostEnum.reference.name] != null) {
      map![PostEnum.reference.name] = (map[PostEnum.reference.name] as DocumentReference).path;
    }

    return map;
  }

  DocumentReference? getReference(dynamic ref) {
    if (ref != null) {
      if (ref is String) {
        return FirebaseFirestore.instance.doc(ref);
      } else {
        return ref;
      }
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return 'Pet(otherCaracteristics: $otherCaracteristics, saved: $saved, sharedTimes: $sharedTimes, chronicDiseaseInfo: $chronicDiseaseInfo, lastSeenDetails: $lastSeenDetails, donatedOrFound: $donatedOrFound, createdAt: $createdAt, likes: $likes, owner: $owner, longitude: $longitude, disappeared: $disappeared, latitude: $latitude, ownerId: $ownerId, timesDennounced: $timesDennounced, description: $description, gender: $gender, health: $health, color: $color, ageMonth: $ageMonth, breed: $breed, ageYear: $ageYear, size: $size, state: $state, photos: $photos, name: $name, type: $type, city: $city, country: $country, uid: $uid, views: $views, video: $video, reward: $reward, reference: $reference,dennounceMotives: $dennounceMotives)';
  }

  @override
  bool operator ==(covariant Pet other) {
    if (identical(this, other)) return true;

    return other.otherCaracteristics == otherCaracteristics &&
        other.chronicDiseaseInfo == chronicDiseaseInfo &&
        other.describedAddress == describedAddress &&
        other.dennounceMotives == dennounceMotives &&
        other.lastSeenDetails == lastSeenDetails &&
        other.timesDennounced == timesDennounced &&
        other.donatedOrFound == donatedOrFound &&
        other.disappeared == disappeared &&
        other.sharedTimes == sharedTimes &&
        other.description == description &&
        other.longitude == longitude &&
        other.createdAt == createdAt &&
        other.reference == reference &&
        other.latitude == latitude &&
        other.ageMonth == ageMonth &&
        other.ownerId == ownerId &&
        other.ageYear == ageYear &&
        other.country == country &&
        other.gender == gender &&
        other.reward == reward &&
        other.health == health &&
        other.photos == photos &&
        other.saved == saved &&
        other.owner == owner &&
        other.video == video &&
        other.color == color &&
        other.breed == breed &&
        other.views == views &&
        other.state == state &&
        other.likes == likes &&
        other.name == name &&
        other.size == size &&
        other.type == type &&
        other.city == city &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return otherCaracteristics.hashCode ^
        chronicDiseaseInfo.hashCode ^
        describedAddress.hashCode ^
        dennounceMotives.hashCode ^
        timesDennounced.hashCode ^
        lastSeenDetails.hashCode ^
        donatedOrFound.hashCode ^
        description.hashCode ^
        disappeared.hashCode ^
        sharedTimes.hashCode ^
        createdAt.hashCode ^
        reference.hashCode ^
        longitude.hashCode ^
        latitude.hashCode ^
        ageMonth.hashCode ^
        ownerId.hashCode ^
        ageYear.hashCode ^
        gender.hashCode ^
        saved.hashCode ^
        photos.hashCode ^
        health.hashCode ^
        owner.hashCode ^
        video.hashCode ^
        likes.hashCode ^
        color.hashCode ^
        breed.hashCode ^
        views.hashCode ^
        state.hashCode ^
        size.hashCode ^
        name.hashCode ^
        type.hashCode ^
        city.hashCode ^
        uid.hashCode;
  }
}
