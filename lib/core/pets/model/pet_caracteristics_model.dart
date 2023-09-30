import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:flutter/material.dart';

enum PetCaracteristicsEnum {
  content,
  title,
  icon,
}

class PetCaracteristics {
  PetCaracteristics({
    required this.content,
    required this.title,
    required this.icon,
  });

  String content;
  IconData icon;
  String title;

  static List<PetCaracteristics> petCaracteristics(BuildContext context, Pet pet) {
    return <PetCaracteristics>[
          PetCaracteristics(
            icon: OtherFunctions.getIconFromPetType(context, pet.type),
            title: AppLocalizations.of(context)!.type,
            content: pet.type,
          ),
          PetCaracteristics(
            icon: pet.gender == AppLocalizations.of(context)!.female ? Icons.female : Icons.male,
            title: AppLocalizations.of(context)!.sex,
            content: pet.gender,
          ),
          PetCaracteristics(
            icon: Icons.linear_scale,
            title: AppLocalizations.of(context)!.breed,
            content: pet.breed,
          ),
          PetCaracteristics(
            icon: Icons.color_lens,
            title: AppLocalizations.of(context)!.color,
            content: pet.color,
          ),
          PetCaracteristics(
            icon: Icons.close_fullscreen,
            title: AppLocalizations.of(context)!.size,
            content: pet.size,
          ),
          PetCaracteristics(
            title: AppLocalizations.of(context)!.health,
            icon: FontAwesomeIcons.heartPulse,
            content: pet.health == AppLocalizations.of(context)!.chronicDisease
                ? '${pet.health}:\n${pet.chronicDiseaseInfo}'
                : pet.health,
          ),
          PetCaracteristics(
            content: '${pet.ageYear}a ${pet.ageMonth}m',
            icon: FontAwesomeIcons.cakeCandles,
            title: AppLocalizations.of(context)!.age,
          ),
        ] +
        List.generate(
          pet.otherCaracteristics.length,
          (index) => PetCaracteristics(
            title: AppLocalizations.of(context)!.caracteristics,
            content: pet.otherCaracteristics[index],
            icon: Icons.auto_awesome,
          ),
        );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      PetCaracteristicsEnum.icon.name: icon.codePoint,
      PetCaracteristicsEnum.content.name: content,
      PetCaracteristicsEnum.title.name: title,
    };
  }
}
