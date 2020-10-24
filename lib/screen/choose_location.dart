import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/new_map.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/screen/pet_form.dart';
import 'package:tiutiu/utils/routes.dart';

class ChooseLocation extends StatefulWidget {
  ChooseLocation({
    this.editMode = false,
    this.pet,
  });

  final bool editMode;
  final Pet pet;

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  AdsProvider adsProvider;

   @override
  void didChangeDependencies() {   
    adsProvider = Provider.of<AdsProvider>(context); 
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var params =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    var kind = widget.editMode ? '' : params['kind'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Escolha a localização do PET',
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          NewMap(),
          Positioned(
            bottom: 0.0,
            child: Consumer<Location>(
              builder: (_, location, child) => ButtonWide(
                rounded: false,
                isToExpand: true,
                text: 'O PET ESTÁ AQUI',
                action: location.getLocation == null
                    ? null
                    : () {
                        widget.editMode
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PetForm(
                                      editMode: true,
                                      pet: widget.pet,
                                    );
                                  },
                                ),
                              )
                            : Navigator.pushNamed(
                                context,
                                Routes.PET_FORM,
                                arguments: {'kind': kind},
                              );
                      },
              ),
            ),
          )
        ],
      ),
    );
  }
}
