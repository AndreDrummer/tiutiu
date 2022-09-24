import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/Widgets/new_map.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:flutter/material.dart';

class ChooseLocation extends StatefulWidget {
  ChooseLocation({
    this.editMode = false,
    this.pet,
  });

  final bool? editMode;
  final Pet? pet;

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  // AdsProvider adsProvider;

  @override
  Widget build(BuildContext context) {
    // Location locationProvider = Provider.of<Location>(context);
    var params =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var kind = widget.editMode! ? widget.pet!.kind : params['kind'];

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
            child: StreamBuilder<bool>(
              // stream: locationProvider.canContinue,
              builder: (context, snapshot) {
                return ButtonWide(
                  color: snapshot.data != null && snapshot.data!
                      ? AppColors.secondary
                      : Colors.grey,
                  rounded: false,
                  isToExpand: true,
                  text: kind == FirebaseEnvPath.donate
                      ? 'O PET ESTÁ NESTA REGIÃO'
                      : 'VISTO POR ÚLTIMO AQUI',
                  action: snapshot.data == null || !snapshot.data!
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            Routes.pet_form,
                            arguments: {'kind': kind},
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
