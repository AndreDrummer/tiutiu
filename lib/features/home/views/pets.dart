import 'package:tiutiu/features/pets/widgets/filter_count_order_by.dart';
import 'package:tiutiu/features/home/widgets/filters_type.dart';
import 'package:tiutiu/features/pets/views/pets_list.dart';
import 'package:tiutiu/Widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Pets extends StatelessWidget {
  Pets({
    Key? key,
    this.disappeared = false,
  }) : super(key: key);

  final bool disappeared;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TopBar(),
        FiltersType(),
        FilterResultCount(),
        Container(
          height: Get.height - (Get.height / 3),
          child: PetsList(disappeared: disappeared),
        ),
      ],
    );
  }
}
