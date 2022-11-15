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
    final statesInitials = StatesAndCities().stateInitials;
    final statesName = StatesAndCities().stateNames;

    String UF = statesInitials.elementAt(statesName.indexOf(state));

    return Container(
      width: rightSide ? 200.0.w : null,
      margin: EdgeInsets.only(bottom: 8.0.h),
      child: Row(
        children: [
          if (rightSide) Spacer(),
          Icon(Icons.pin_drop, size: 12.0.h, color: Colors.grey[400]),
          AutoSizeTexts.autoSizeText10(
            textOverflow: TextOverflow.fade,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
            '$city - $UF',
          ),
        ],
      ),
    );
  }
}
