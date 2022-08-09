import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/new_map.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/features/location/controller/current_location_controller.dart';
import 'package:tiutiu/screen/pet_form.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // Location locationProvider = Provider.of<Location>(context);
    var params =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var kind = widget.editMode! ? widget.pet!.kind : params['kind'];

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(
      //     kind == Constantes.DONATE ? 'localização do PET'.toUpperCase() : 'Visto pela última vez em'.toUpperCase(),
      //     style: Theme.of(context).textTheme.headline1!.copyWith(
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
                      ? Colors.purple
                      : Colors.grey,
                  rounded: false,
                  isToExpand: true,
                  text: kind == Constantes.DONATE
                      ? 'O PET ESTÁ NESTA REGIÃO'
                      : 'VISTO POR ÚLTIMO AQUI',
                  action: snapshot.data == null || !snapshot.data!
                      ? null
                      : () {
                          widget.editMode!
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PetForm(
                                        editMode: true,
                                        pet: widget.pet!,
                                        localChanged: true,
                                      );
                                    },
                                  ),
                                )
                              : Navigator.pushNamed(
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
