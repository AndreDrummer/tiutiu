import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:uuid/uuid.dart';

enum AdoptionFormEnum {
  allowContactWithYourReferences,
  availableForBackgroundCheck,
  thereIsOtherAnimalsInHouse,
  alreadyHadAnimalsLikeThat,
  haveMoneyEnoughToCare,
  haveTimeFreeToCare,
  referenceContact1,
  referenceContact2,
  referenceContact3,
  liveInAnApartment,
  interestedBreed,
  howManyChildren,
  interestedType,
  maritalStatus,
  haveChildren,
  houseType,
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
    this.alreadyHadAnimalsLikeThat = false,
    this.thereIsOtherAnimalsInHouse = '',
    this.haveMoneyEnoughToCare = false,
    this.haveTimeFreeToCare = false,
    this.liveInAnApartment = false,
    this.maritalStatus = '-',
    this.interestedBreed = '-',
    this.interestedType = '-',
    this.referenceContact2,
    this.referenceContact3,
    this.referenceContact1,
    this.haveYard = false,
    this.haveChildren,
    this.profission,
    this.houseType,
    this.age = '-',
    this.fullName,
    this.address,
    this.reason,
    this.phone,
    this.email,
    this.uid,
  });

  factory AdoptionForm.fromMap(Map<String, dynamic> map) {
    return AdoptionForm(
      allowContactWithYourReferences: map[AdoptionFormEnum.allowContactWithYourReferences.name],
      availableForBackgroundCheck: map[AdoptionFormEnum.availableForBackgroundCheck.name],
      thereIsOtherAnimalsInHouse: map[AdoptionFormEnum.thereIsOtherAnimalsInHouse.name],
      alreadyHadAnimalsLikeThat: map[AdoptionFormEnum.alreadyHadAnimalsLikeThat.name],
      haveMoneyEnoughToCare: map[AdoptionFormEnum.haveMoneyEnoughToCare.name],
      haveTimeFreeToCare: map[AdoptionFormEnum.haveTimeFreeToCare.name],
      liveInAnApartment: map[AdoptionFormEnum.liveInAnApartment.name],
      referenceContact1: map[AdoptionFormEnum.referenceContact1.name],
      referenceContact2: map[AdoptionFormEnum.referenceContact2.name],
      referenceContact3: map[AdoptionFormEnum.referenceContact3.name],
      interestedBreed: map[AdoptionFormEnum.interestedBreed.name],
      interestedType: map[AdoptionFormEnum.interestedType.name],
      maritalStatus: map[AdoptionFormEnum.maritalStatus.name],
      haveChildren: map[AdoptionFormEnum.haveChildren.name],
      uid: map[AdoptionFormEnum.uid.name] ?? Uuid().v4(),
      profission: map[AdoptionFormEnum.profission.name],
      houseType: map[AdoptionFormEnum.houseType.name],
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
    String? thereIsOtherAnimalsInHouse,
    bool? availableForBackgroundCheck,
    bool? alreadyHadAnimalsLikeThat,
    bool? haveMoneyEnoughToCare,
    String? referenceContact1,
    String? referenceContact2,
    String? referenceContact3,
    bool? haveTimeFreeToCare,
    String? interestedBreed,
    String? interestedType,
    bool? liveInAnApartment,
    String? maritalStatus,
    int? howManyChildren,
    String? haveChildren,
    String? profission,
    String? houseType,
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
      haveTimeFreeToCare: haveTimeFreeToCare ?? this.haveTimeFreeToCare,
      liveInAnApartment: liveInAnApartment ?? this.liveInAnApartment,
      referenceContact1: referenceContact1 ?? this.referenceContact1,
      referenceContact2: referenceContact2 ?? this.referenceContact2,
      referenceContact3: referenceContact3 ?? this.referenceContact3,
      interestedBreed: interestedBreed ?? this.interestedBreed,
      interestedType: interestedType ?? this.interestedType,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      haveChildren: haveChildren ?? this.haveChildren,
      profission: profission ?? this.profission,
      houseType: houseType ?? this.houseType,
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
      AdoptionFormEnum.haveTimeFreeToCare.name: haveTimeFreeToCare,
      AdoptionFormEnum.liveInAnApartment.name: liveInAnApartment,
      AdoptionFormEnum.referenceContact1.name: referenceContact1,
      AdoptionFormEnum.referenceContact2.name: referenceContact2,
      AdoptionFormEnum.referenceContact3.name: referenceContact3,
      AdoptionFormEnum.interestedBreed.name: interestedBreed,
      AdoptionFormEnum.interestedType.name: interestedType,
      AdoptionFormEnum.maritalStatus.name: maritalStatus,
      AdoptionFormEnum.haveChildren.name: haveChildren,
      AdoptionFormEnum.uid.name: uid ?? Uuid().v4(),
      AdoptionFormEnum.profission.name: profission,
      AdoptionFormEnum.houseType.name: houseType,
      AdoptionFormEnum.fullName.name: fullName,
      AdoptionFormEnum.haveYard.name: haveYard,
      AdoptionFormEnum.address.name: address,
      AdoptionFormEnum.reason.name: reason,
      AdoptionFormEnum.phone.name: phone,
      AdoptionFormEnum.email.name: email,
      AdoptionFormEnum.age.name: age,
    };
  }

  @override
  String toString() =>
      '==================================\nGerado com ❤️ por Anja Solutions\nAcesse: https://anjasolutions.com/tiutiu\n==================================\n\n\n*FORMULÁRIO DE ADOÇÃO*\n\n*Informações pessoais*\n\nNome completo: ${fullName.isNotEmptyNeighterNull() ? fullName : 'Não Informado'}\n\nEndereço:\nR: ${address.isNotEmptyNeighterNull() ? address : 'Não Informado'}\n\nTelefone: ${phone.isNotEmptyNeighterNull() ? phone : 'Não Informado'}\n\nEmail: ${email.isNotEmptyNeighterNull() ? email : 'Não Informado'}\n\nIdade: ${age.isNotEmptyNeighterNull() ? age : 'Não Informado'}\n\nEstado Civil: ${maritalStatus.isNotEmptyNeighterNull() ? maritalStatus : 'Não Informado'}\n\nProfissão: ${profission.isNotEmptyNeighterNull() ? profission : 'Não Informado'}\n\n*Informações sobre o animal*\n\nQual tipo de animal você está interessado em adotar?\nR: ${interestedType.isNotEmptyNeighterNull() ? interestedType : 'Não Informado'}\n\nDe qual ${interestedType == AppLocalizations.of(Get.context!)!.bird ? 'espécie' : 'raça'}?\nR: ${interestedBreed.isNotEmptyNeighterNull() ? interestedBreed : 'Não Informado'}\n\nPor que você quer adotar esse animal em particular?\nR: ${reason.isNotEmptyNeighterNull() ? reason : 'Não Informado'}\n\nVocê tem experiência com animais desse tipo?\nR: ${alreadyHadAnimalsLikeThat.isNotEmptyNeighterNull() ? alreadyHadAnimalsLikeThat : 'Não Informado'}\n\n*Informações sobre sua residência*\n\nQual é o seu tipo de imóvel? (casa, apartamento)\nR: ${houseType.isNotEmptyNeighterNull() ? houseType : 'Não Informado'}\n\nVocê tem quintal?\nR: ${haveYard ? 'Sim' : 'Não'}\n\nVocê tem crianças? Se sim, quantas e idades\nR: ${haveChildren.isNotEmptyNeighterNull() ? haveChildren : 'Não Informado'}\n\nVocê tem outros animais em casa? Se sim, quais e quantos\nR: ${thereIsOtherAnimalsInHouse.isNotEmptyNeighterNull() ? thereIsOtherAnimalsInHouse : 'Não Informado'}\n\n*Informações sobre seu tempo e recursos financeiros*\n\nVocê tem tempo suficiente para cuidar de um animal?\nR: ${haveTimeFreeToCare ? 'Sim' : 'Não'}\n\nVocê tem recursos financeiros para cuidar de um animal? (ração, vacinação, consultas veterinárias)\nR: ${haveMoneyEnoughToCare ? 'Sim' : 'Não'}\n\n*Informações sobre verificação de antecedentes*\n\nAceita passar por uma verificação de antecedentes?\nR: ${availableForBackgroundCheck ? 'Sim' : 'Não'}\n\nPermite entrar em contato com contato  de referências?\nR: ${allowContactWithYourReferences ? 'Sim' : 'Não'}\n\n';

  String toStringEmpty() =>
      '==================================\nGerado com ❤️ por Anja Solutions\nAcesse: https://anjasolutions.com/tiutiu\n==================================\n\n\n*FORMULÁRIO DE ADOÇÃO*\n\n*Informações pessoais*\n\nNome completo:\nR:\n\nEndereço:\nR:\n\nTelefone:\nR:\n\nEmail:\nR:\n\nIdade:\nR:\n\nEstado Civil:\nR:\n\nProfissão:\nR:\n\n*Informações sobre o animal*\n\nQual tipo de animal você está interessado em adotar?\nR:\n\nDe qual raça?\nR:\n\nPor que você quer adotar esse animal em particular?\nR:\n\nVocê tem experiência com animais desse tipo?\nR:\n\n*Informações sobre sua residência*\n\nQual é o seu tipo de imóvel? (casa, apartamento)\nR:\n\nVocê tem quintal?\nR:\n\nVocê tem crianças? Se sim, quantas e idades\nR:\n\nVocê tem outros animais em casa? Se sim, quais e quantos\nR:\n\n*Informações sobre seu tempo e recursos financeiros*\n\nVocê tem tempo suficiente para cuidar de um animal?\nR:\n\nVocê tem recursos financeiros para cuidar de um animal? (ração, vacinação, consultas veterinárias)\nR:\n\n*Informações sobre verificação de antecedentes*\n\nAceita passar por uma verificação de antecedentes?\nR:\n\nPermite entrar em contato com contato  de referências?\nR:\n\n';

  String toPDFPart1() =>
      'FORMULÁRIO DE ADOÇÃO\nGerado por Anja Solutions\nAcesse: https://anjasolutions.com/tiutiu\n\n\n\n\n1. Informações pessoais\n\nNome completo: ${fullName.isNotEmptyNeighterNull() ? fullName : 'Não Informado'}\n\nEndereço:\nR: ${address.isNotEmptyNeighterNull() ? address : 'Não Informado'}\n\nTelefone: ${phone.isNotEmptyNeighterNull() ? phone : 'Não Informado'}\n\nEmail: ${email.isNotEmptyNeighterNull() ? email : 'Não Informado'}\n\nIdade: ${age.isNotEmptyNeighterNull() ? age : 'Não Informado'}\n\nEstado Civil: ${maritalStatus.isNotEmptyNeighterNull() ? maritalStatus : 'Não Informado'}\n\nProfissão: ${profission.isNotEmptyNeighterNull() ? profission : 'Não Informado'}\n\nInformações sobre o animal\n\nQual tipo de animal você está interessado em adotar?\nR: ${interestedType.isNotEmptyNeighterNull() ? interestedType : 'Não Informado'}\n\nDe qual ${interestedType == AppLocalizations.of(Get.context!)!.bird ? 'espécie' : 'raça'}?\nR: ${interestedBreed.isNotEmptyNeighterNull() ? interestedBreed : 'Não Informado'}\n\nPor que você quer adotar esse animal em particular?\nR: ${reason.isNotEmptyNeighterNull() ? reason : 'Não Informado'}\n\nVocê tem experiência com animais desse tipo?\nR: ${alreadyHadAnimalsLikeThat.isNotEmptyNeighterNull() ? alreadyHadAnimalsLikeThat : 'Não Informado'}\n\nInformações sobre sua residência\n\nQual é o seu tipo de imóvel? (casa, apartamento)\nR: ${houseType.isNotEmptyNeighterNull() ? houseType : 'Não Informado'}\n\nVocê tem quintal?\nR: ${haveYard ? 'Sim' : 'Não'}\n\nVocê tem crianças? Se sim, quantas e idades\nR: ${haveChildren.isNotEmptyNeighterNull() ? haveChildren : 'Não Informado'}\n\nVocê tem outros animais em casa? Se sim, quais e quantos\nR: ${thereIsOtherAnimalsInHouse.isNotEmptyNeighterNull() ? thereIsOtherAnimalsInHouse : 'Não Informado'}\n\n';

  String toPDFPart2() =>
      'FORMULÁRIO DE ADOÇÃO\nGerado por Anja Solutions\nAcesse: https://anjasolutions.com/tiutiu\n\n\n\n\n4. Informações sobre seu tempo e recursos financeiros\n\nVocê tem tempo suficiente para cuidar de um animal?\nR: ${haveTimeFreeToCare ? 'Sim' : 'Não'}\n\nVocê tem recursos financeiros para cuidar de um animal? (ração, vacinação, consultas veterinárias)\nR: ${haveMoneyEnoughToCare ? 'Sim' : 'Não'}\n\nInformações sobre verificação de antecedentes\n\nAceita passar por uma verificação de antecedentes?\nR: ${availableForBackgroundCheck ? 'Sim' : 'Não'}\n\nPermite entrar em contato com contato  de referências?\nR: ${allowContactWithYourReferences ? 'Sim' : 'Não'}\n\n';

  String toPDFPart1Empty() =>
      'FORMULÁRIO DE ADOÇÃO\nGerado por Anja Solutions\nAcesse: https://anjasolutions.com/tiutiu\n\n\n\n\n1. Informações pessoais\n\nNome completo\nR:\n\nEndereço:\nR:\n\nTelefone:\nR:\n\nEmail:\nR:\n\nIdade:\nR:\n\nEstado Civil:\nR:\n\nProfissão:\nR:\n\n\n2. Informações sobre o animal\n\nQual tipo de animal você está interessado em adotar?\nR:\n\nDe qual raça?\nR:\n\nPor que você quer adotar esse animal em particular?\nR:\n\nVocê tem experiência com animais desse tipo?\nR:\n\n\n3. Informações sobre sua residência\n\nQual é o seu tipo de imóvel? (casa, apartamento)\nR:\n\nVocê tem quintal?\nR:\n\nVocê tem crianças? Se sim, quantas e idades\nR:\n\nVocê tem outros animais em casa? Se sim, quais e quantos\nR:\n\n\n';

  String toPDFPart2Empty() =>
      'FORMULÁRIO DE ADOÇÃO\nGerado por Anja Solutions\nAcesse: https://anjasolutions.com/tiutiu\n\n\n\n\n4. Informações sobre seu tempo e recursos financeiros\n\nVocê tem tempo suficiente para cuidar de um animal?\nR:\n\nVocê tem recursos financeiros para cuidar de um animal? (ração, vacinação, consultas veterinárias)\nR:\n\n\n5. Informações sobre verificação de antecedentes\n\nAceita passar por uma verificação de antecedentes?\nR:\n\nPermite entrar em contato com contato  de referências?\nR:\n\n';

  bool allowContactWithYourReferences;
  String thereIsOtherAnimalsInHouse;
  bool availableForBackgroundCheck;
  bool alreadyHadAnimalsLikeThat;
  bool haveMoneyEnoughToCare;
  String? referenceContact1;
  String? referenceContact2;
  String? referenceContact3;
  bool haveTimeFreeToCare;
  bool liveInAnApartment;
  String interestedBreed;
  String interestedType;
  String? haveChildren;
  String maritalStatus;
  String? profission;
  String? houseType;
  String? fullName;
  String? address;
  String? reason;
  bool haveYard;
  String? phone;
  String? email;
  String? uid;
  String age;
}
