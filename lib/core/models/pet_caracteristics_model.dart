import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/Custom/icons.dart';
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

  static List<PetCaracteristics> petCaracteristics(Pet pet) {
    return <PetCaracteristics>[
          PetCaracteristics(
            icon: OtherFunctions.getIconFromPetType(pet.type),
            title: AppStrings.type,
            content: pet.type,
          ),
          PetCaracteristics(
            icon: pet.gender == PetDetailsStrings.female
                ? Icons.female
                : Icons.male,
            title: PetDetailsStrings.sex,
            content: pet.gender,
          ),
          PetCaracteristics(
            icon: Icons.linear_scale,
            title: PetDetailsStrings.breed,
            content: pet.breed,
          ),
          PetCaracteristics(
            icon: Icons.color_lens,
            title: PetDetailsStrings.color,
            content: pet.color,
          ),
          PetCaracteristics(
            icon: Icons.close_fullscreen,
            title: PetDetailsStrings.size,
            content: pet.size,
          ),
          PetCaracteristics(
            title: PetDetailsStrings.health,
            icon: Tiutiu.healing,
            content: pet.health,
          ),
          PetCaracteristics(
            content: '${pet.ageYear}a ${pet.ageMonth}m',
            title: PetDetailsStrings.age,
            icon: Tiutiu.birthday_cake,
          ),
        ] +
        List.generate(
          pet.otherCaracteristics.length,
          (index) => PetCaracteristics(
            title: PetDetailsStrings.otherCaracteristics,
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
