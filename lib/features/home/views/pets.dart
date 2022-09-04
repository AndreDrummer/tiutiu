import 'package:tiutiu/features/pets/widgets/filter_count_order_by.dart';
import 'package:tiutiu/features/home/widgets/filters_type.dart';
import 'package:tiutiu/features/pets/views/pets_list.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Pets extends StatelessWidget {
  Pets({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(),
        FiltersType(),
        Obx(
          () => FilterResultCount(
            count: petsController.petsCount,
          ),
        ),
        Container(
          height: Get.height - (Get.height / 3),
          child: PetsList(),
        ),
      ],
    );
  }
}
