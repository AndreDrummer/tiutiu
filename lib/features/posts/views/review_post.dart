import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/Widgets/cards/card_ad.dart';
import 'package:flutter/material.dart';

class ReviewPost extends StatelessWidget {
  const ReviewPost({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CardAd(pet: pet),
    );
  }
}
