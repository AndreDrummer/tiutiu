import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:flutter/material.dart';

class PetLocation extends StatelessWidget {
  PetLocation({
    this.editMode = false,
    this.pet,
  });

  final bool? editMode;
  final Pet? pet;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: Text('Body'),
      ),
    );
  }
}
