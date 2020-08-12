import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/mapa.dart';
import 'package:tiutiu/Widgets/button.dart';
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final statusBar = AppBar().preferredSize.height;

    params = ModalRoute.of(context).settings.arguments;
    var kind = params['kind'];

    return Scaffold(      
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: statusBar - 30),
            Align(
              alignment: Alignment(-0.99, 1),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Image.asset('assets/pin-dog.jpg'),
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Escolha a localização do PET',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: FittedBox(
                  child: Text(
                      'Arraste e/ou dê zoom no mapa para escolher a localização do seu PET.',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                          )),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: width * 0.96,
              height: height / 2,
              child: Mapa(),
            ),
            SizedBox(height: 10),
            Container(
              width: width * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<Location>(
                  builder: (_, location, child) => ButtonWide(
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
