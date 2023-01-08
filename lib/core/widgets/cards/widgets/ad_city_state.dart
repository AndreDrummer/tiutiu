import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

class AdCityState extends StatelessWidget {
  const AdCityState({
    super.key,
    required this.state,
    required this.city,
  });

  final String state;
  final String city;

  @override
  Widget build(BuildContext context) {
    final rightSide = homeController.cardVisibilityKind == CardVisibilityKind.card;
    final statesInitials = StatesAndCities.stateAndCities.stateInitials;
    final statesName = StatesAndCities.stateAndCities.stateNames;

    String UF = statesInitials.elementAt(statesName.indexOf(state));

    return Container(
      margin: EdgeInsets.only(bottom: rightSide ? 8.0.h : 0.0),
      alignment: rightSide ? Alignment.centerRight : null,
      width: rightSide ? 200.0.w : null,
      child: AutoSizeTexts.autoSizeText10(
        textOverflow: TextOverflow.fade,
        fontWeight: FontWeight.w700,
        color: Colors.grey,
        '$city - $UF',
      ),
    );
  }
}
