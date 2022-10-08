import 'package:tiutiu/features/posts/views/pet_location.dart';
import 'package:tiutiu/features/posts/widgets/steper.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/column_button_bar.dart';
import 'package:flutter/material.dart';

class PostFlow extends StatelessWidget {
  const PostFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Steper(),
              Expanded(
                child: _screens.elementAt(postsController.flowIndex),
              ),
            ],
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: ColumnButtonBar(),
          ),
        ],
      ),
    );
  }
}

final _screens = [
  PetLocation(),
];
