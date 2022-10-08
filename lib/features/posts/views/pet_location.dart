import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
import 'package:tiutiu/Widgets/new_map.dart';
import 'package:flutter/material.dart';

class PetLocation extends StatefulWidget {
  PetLocation({
    this.editMode = false,
    this.pet,
  });

  final bool? editMode;
  final Pet? pet;

  @override
  _PetLocationState createState() => _PetLocationState();
}

class _PetLocationState extends State<PetLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // appBar: AppBar(
      //   title: AutoSizeText(
      //     kind == FirebaseEnvPath.donate ? 'localização do PET'.toUpperCase() : 'Visto pela última vez em'.toUpperCase(),
      //     style: Theme.of(context).textTheme.headline4!.copyWith(
      //           fontSize: 20,
      //           fontWeight: FontWeight.w700,
      //         ),
      //   ),
      // ),
      body: Stack(
        children: <Widget>[
          NewMap(),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: StreamBuilder<bool>(
              // stream: locationProvider.canContinue,
              builder: (context, snapshot) {
                return ButtonWide(
                  color: AppColors.primary,
                  rounded: false,
                  isToExpand: true,
                  text: PostFlowStrings.petIsHere,
                  action: snapshot.data == null || !snapshot.data!
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            Routes.petForm,
                          );
                        },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
