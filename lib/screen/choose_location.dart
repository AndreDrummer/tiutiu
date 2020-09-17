import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/new_map.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/utils/routes.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  var params;

  @override
  Widget build(BuildContext context) {    

    params = ModalRoute.of(context).settings.arguments;
    var kind = params['kind'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(        
        title: Text(
          'Escolha a localização do PET',
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 18,
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
                text: 'CONTINUAR',
                action: location.location == null
                    ? null
                    : () {                      
                        Navigator.pushNamed(
                          context,
                          Routes.NOVOPET,
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
