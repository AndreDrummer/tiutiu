import 'package:tiutiu/core/extensions/enum_tostring.dart';
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
            icon: OtherFunctions.getIconFromPetType(pet.type!),
            title: PetDetailsString.type,
            content: pet.type!,
          ),
          PetCaracteristics(
            icon: pet.gender == PetDetailsString.female
                ? Icons.female
                : Icons.male,
            title: PetDetailsString.sex,
            content: pet.gender!,
          ),
          PetCaracteristics(
            icon: Icons.linear_scale,
            title: PetDetailsString.breed,
            content: pet.breed!,
          ),
          PetCaracteristics(
            icon: Icons.color_lens,
            title: PetDetailsString.color,
            content: pet.color!,
          ),
          PetCaracteristics(
            icon: Icons.close_fullscreen,
            title: PetDetailsString.size,
            content: pet.size!,
          ),
          PetCaracteristics(
            title: PetDetailsString.health,
            icon: Tiutiu.healing,
            content: pet.health!,
          ),
          PetCaracteristics(
            content: '${pet.ageYear}a ${pet.ageMonth}m',
            title: PetDetailsString.age,
            icon: Tiutiu.birthday_cake,
          ),
        ] +
        List.generate(
          pet.otherCaracteristics?.length ?? 0,
          (index) => PetCaracteristics(
            title: PetDetailsString.otherCaracteristics,
            content: pet.otherCaracteristics![index],
            icon: Icons.auto_awesome,
          ),
        );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      PetCaracteristicsEnum.icon.tostring(): icon.codePoint,
      PetCaracteristicsEnum.content.tostring(): content,
      PetCaracteristicsEnum.title.tostring(): title,
    };
  }
}
