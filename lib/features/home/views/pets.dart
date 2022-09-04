import 'package:tiutiu/features/home/widgets/filters_kind.dart';
import 'package:tiutiu/Widgets/top_bar.dart';
import 'package:flutter/material.dart';

class Pets extends StatelessWidget {
  Pets({super.key});

  final screenWidgets = [
    TopBar(),
    FiltersKind(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final widget in screenWidgets) widget,
      ],
    );
  }
}
