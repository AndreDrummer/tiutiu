import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostCaracteristics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final caracs = DummyData.otherCaracteristicsList;

    return Obx(
      () => _otherCaracteristicsGrid(caracs),
    );
  }
}

SizedBox _otherCaracteristicsGrid(List<String> caracs) {
  return SizedBox(
    height: Get.height / 2,
    child: GridView.count(
      childAspectRatio: 3,
      crossAxisSpacing: 2.0.h,
      mainAxisSpacing: 8.0.h,
      crossAxisCount: 2,
      children: caracs.map((carac) {
        return Center(
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: AutoSizeTexts.autoSizeText12(carac),
            onChanged: (_) {
              postsController.updatePost(PetEnum.otherCaracteristics.name, carac);
            },
            value: (postsController.post as Pet).otherCaracteristics.contains(carac),
          ),
        );
      }).toList(),
    ),
  );
}
