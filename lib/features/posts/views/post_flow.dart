import 'package:tiutiu/features/posts/views/pet_location.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:flutter/material.dart';

class PostFlow extends StatelessWidget {
  const PostFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(postsController.flowIndex),
    );
  }
}

final _screens = [
  PetLocation(),
];
