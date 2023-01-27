import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarkAsDone extends StatelessWidget {
  const MarkAsDone({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final markAs = pet.disappeared ? 'Encontrado' : 'Adotado';

    return Obx(() {
      return Visibility(
        visible: postsController.isInMyPostsList,
        child: StreamBuilder<Pet>(
          stream: pet.reference?.snapshots().asyncMap((snapshot) {
            final map = snapshot.data() as Map<String, dynamic>;
            return Pet().fromMap(map);
          }),
          builder: (context, snapshot) {
            final pet = (snapshot.data) ?? Pet();
            final donatedOrFound = pet.donatedOrFound;

            return Column(
              children: [
                AutoSizeTexts.autoSizeText10(
                  donatedOrFound ? markAs : 'Marcar como\n$markAs',
                  textAlign: TextAlign.center,
                  color: AppColors.black,
                ),
                Switch(
                  value: pet.donatedOrFound,
                  onChanged: (value) {
                    pet.reference?.set({PetEnum.donatedOrFound.name: value}, SetOptions(merge: true));
                  },
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
