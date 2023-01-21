import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

enum AdoptionFormEnum {
  allowContactWithYourReferences,
  availableForBackgroundCheck,
  thereIsOtherAnimalsInHouse,
  alreadyHadAnimalsLikeThat,
  haveMoneyEnoughToCare,
  haveTimeFreeToCare,
  referencesContacts,
  liveInAnApartment,
  interestedBreed,
  howManyChildren,
  howManyAnimals,
  interestedType,
  maritalStatus,
  haveChildren,
  liveInHouse,
  profission,
  fullName,
  haveYard,
  address,
  reason,
  phone,
  email,
  age,
  uid,
}

class AdoptionForm {
  AdoptionForm({
    this.allowContactWithYourReferences = false,
    this.availableForBackgroundCheck = false,
    this.thereIsOtherAnimalsInHouse = false,
    this.alreadyHadAnimalsLikeThat = false,
    this.haveMoneyEnoughToCare = false,
    this.haveTimeFreeToCare = false,
    this.liveInAnApartment = false,
    this.haveChildren = false,
    this.liveInHouse = false,
    this.referencesContacts,
    this.interestedBreed,
    this.haveYard = false,
    this.howManyChildren,
    this.howManyAnimals,
    this.interestedType,
    this.maritalStatus,
    this.profission,
    this.age = '0',
    this.fullName,
    this.address,
    this.reason,
    this.phone,
    this.email,
    this.uid,
  });

  factory AdoptionForm.fromSnapshot(DocumentSnapshot snapshot) {
    return AdoptionForm(
      allowContactWithYourReferences: snapshot.get(AdoptionFormEnum.allowContactWithYourReferences.name),
      availableForBackgroundCheck: snapshot.get(AdoptionFormEnum.availableForBackgroundCheck.name),
      thereIsOtherAnimalsInHouse: snapshot.get(AdoptionFormEnum.thereIsOtherAnimalsInHouse.name),
      alreadyHadAnimalsLikeThat: snapshot.get(AdoptionFormEnum.alreadyHadAnimalsLikeThat.name),
      haveMoneyEnoughToCare: snapshot.get(AdoptionFormEnum.haveMoneyEnoughToCare.name),
      referencesContacts: snapshot.get(AdoptionFormEnum.referencesContacts.name),
      haveTimeFreeToCare: snapshot.get(AdoptionFormEnum.haveTimeFreeToCare.name),
      liveInAnApartment: snapshot.get(AdoptionFormEnum.liveInAnApartment.name),
      howManyChildren: snapshot.get(AdoptionFormEnum.howManyChildren.name),
      interestedBreed: snapshot.get(AdoptionFormEnum.interestedBreed.name),
      interestedType: snapshot.get(AdoptionFormEnum.interestedType.name),
      howManyAnimals: snapshot.get(AdoptionFormEnum.howManyAnimals.name),
      maritalStatus: snapshot.get(AdoptionFormEnum.maritalStatus.name),
      haveChildren: snapshot.get(AdoptionFormEnum.haveChildren.name),
      liveInHouse: snapshot.get(AdoptionFormEnum.liveInHouse.name),
      uid: snapshot.get(AdoptionFormEnum.uid.name) ?? Uuid().v4(),
      profission: snapshot.get(AdoptionFormEnum.profission.name),
      fullName: snapshot.get(AdoptionFormEnum.fullName.name),
      haveYard: snapshot.get(AdoptionFormEnum.haveYard.name),
      address: snapshot.get(AdoptionFormEnum.address.name),
      reason: snapshot.get(AdoptionFormEnum.reason.name),
      email: snapshot.get(AdoptionFormEnum.email.name),
      phone: snapshot.get(AdoptionFormEnum.phone.name),
      age: snapshot.get(AdoptionFormEnum.age.name),
    );
  }

  factory AdoptionForm.fromMap(Map<String, dynamic> map) {
    return AdoptionForm(
      allowContactWithYourReferences: map[AdoptionFormEnum.allowContactWithYourReferences.name],
      availableForBackgroundCheck: map[AdoptionFormEnum.availableForBackgroundCheck.name],
      thereIsOtherAnimalsInHouse: map[AdoptionFormEnum.thereIsOtherAnimalsInHouse.name],
      alreadyHadAnimalsLikeThat: map[AdoptionFormEnum.alreadyHadAnimalsLikeThat.name],
      haveMoneyEnoughToCare: map[AdoptionFormEnum.haveMoneyEnoughToCare.name],
      referencesContacts: map[AdoptionFormEnum.referencesContacts.name],
      haveTimeFreeToCare: map[AdoptionFormEnum.haveTimeFreeToCare.name],
      liveInAnApartment: map[AdoptionFormEnum.liveInAnApartment.name],
      howManyChildren: map[AdoptionFormEnum.howManyChildren.name],
      interestedBreed: map[AdoptionFormEnum.interestedBreed.name],
      interestedType: map[AdoptionFormEnum.interestedType.name],
      howManyAnimals: map[AdoptionFormEnum.howManyAnimals.name],
      maritalStatus: map[AdoptionFormEnum.maritalStatus.name],
      haveChildren: map[AdoptionFormEnum.haveChildren.name],
      liveInHouse: map[AdoptionFormEnum.liveInHouse.name],
      uid: map[AdoptionFormEnum.uid.name] ?? Uuid().v4(),
      profission: map[AdoptionFormEnum.profission.name],
      fullName: map[AdoptionFormEnum.fullName.name],
      haveYard: map[AdoptionFormEnum.haveYard.name],
      address: map[AdoptionFormEnum.address.name],
      reason: map[AdoptionFormEnum.reason.name],
      phone: map[AdoptionFormEnum.phone.name],
      email: map[AdoptionFormEnum.email.name],
      age: map[AdoptionFormEnum.age.name],
    );
  }
  AdoptionForm copyWith({
    bool? allowContactWithYourReferences,
    bool? availableForBackgroundCheck,
    bool? thereIsOtherAnimalsInHouse,
    bool? alreadyHadAnimalsLikeThat,
    bool? haveMoneyEnoughToCare,
    List? referencesContacts,
    bool? haveTimeFreeToCare,
    String? interestedBreed,
    String? interestedType,
    bool? liveInAnApartment,
    String? maritalStatus,
    int? howManyChildren,
    int? howManyAnimals,
    String? profission,
    bool? haveChildren,
    bool? liveInHouse,
    String? fullName,
    String? address,
    String? reason,
    bool? haveYard,
    String? phone,
    String? email,
    String? age,
    String? uid,
  }) {
    return AdoptionForm(
      allowContactWithYourReferences: allowContactWithYourReferences ?? this.allowContactWithYourReferences,
      availableForBackgroundCheck: availableForBackgroundCheck ?? this.availableForBackgroundCheck,
      thereIsOtherAnimalsInHouse: thereIsOtherAnimalsInHouse ?? this.thereIsOtherAnimalsInHouse,
      alreadyHadAnimalsLikeThat: alreadyHadAnimalsLikeThat ?? this.alreadyHadAnimalsLikeThat,
      haveMoneyEnoughToCare: haveMoneyEnoughToCare ?? this.haveMoneyEnoughToCare,
      referencesContacts: referencesContacts ?? this.referencesContacts,
      haveTimeFreeToCare: haveTimeFreeToCare ?? this.haveTimeFreeToCare,
      liveInAnApartment: liveInAnApartment ?? this.liveInAnApartment,
      interestedBreed: interestedBreed ?? this.interestedBreed,
      howManyChildren: howManyChildren ?? this.howManyChildren,
      howManyAnimals: howManyAnimals ?? this.howManyAnimals,
      interestedType: interestedType ?? this.interestedType,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      haveChildren: haveChildren ?? this.haveChildren,
      liveInHouse: liveInHouse ?? this.liveInHouse,
      profission: profission ?? this.profission,
      haveYard: haveYard ?? this.haveYard,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      reason: reason ?? this.reason,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      age: age ?? this.age,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AdoptionFormEnum.allowContactWithYourReferences.name: allowContactWithYourReferences,
      AdoptionFormEnum.availableForBackgroundCheck.name: availableForBackgroundCheck,
      AdoptionFormEnum.thereIsOtherAnimalsInHouse.name: thereIsOtherAnimalsInHouse,
      AdoptionFormEnum.alreadyHadAnimalsLikeThat.name: alreadyHadAnimalsLikeThat,
      AdoptionFormEnum.haveMoneyEnoughToCare.name: haveMoneyEnoughToCare,
      AdoptionFormEnum.referencesContacts.name: referencesContacts,
      AdoptionFormEnum.haveTimeFreeToCare.name: haveTimeFreeToCare,
      AdoptionFormEnum.liveInAnApartment.name: liveInAnApartment,
      AdoptionFormEnum.howManyChildren.name: howManyChildren,
      AdoptionFormEnum.interestedBreed.name: interestedBreed,
      AdoptionFormEnum.interestedType.name: interestedType,
      AdoptionFormEnum.howManyAnimals.name: howManyAnimals,
      AdoptionFormEnum.maritalStatus.name: maritalStatus,
      AdoptionFormEnum.haveChildren.name: haveChildren,
      AdoptionFormEnum.uid.name: uid ?? Uuid().v4(),
      AdoptionFormEnum.liveInHouse.name: liveInHouse,
      AdoptionFormEnum.profission.name: profission,
      AdoptionFormEnum.fullName.name: fullName,
      AdoptionFormEnum.haveYard.name: haveYard,
      AdoptionFormEnum.address.name: address,
      AdoptionFormEnum.reason.name: reason,
      AdoptionFormEnum.phone.name: phone,
      AdoptionFormEnum.email.name: email,
      AdoptionFormEnum.age.name: age,
    };
  }

  bool allowContactWithYourReferences;
  bool availableForBackgroundCheck;
  bool thereIsOtherAnimalsInHouse;
  bool alreadyHadAnimalsLikeThat;
  bool haveMoneyEnoughToCare;
  List? referencesContacts;
  bool haveTimeFreeToCare;
  String? interestedBreed;
  String? interestedType;
  bool liveInAnApartment;
  String? maritalStatus;
  int? howManyChildren;
  int? howManyAnimals;
  String? profission;
  bool haveChildren;
  bool liveInHouse;
  String? fullName;
  String? address;
  String? reason;
  bool haveYard;
  String? phone;
  String? email;
  String? age;
  String? uid;
}
