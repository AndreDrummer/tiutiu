import 'package:tiutiu/core/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        TopBar(),
        // FiltersType(),
        // Obx(() => FilterResultCount(postsCount: postsController.postsCount)),
      ],
    );
  }
}
