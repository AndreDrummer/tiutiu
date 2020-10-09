import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/button.dart';

class LocalPermissionScreen extends StatelessWidget {
  LocalPermissionScreen({this.permissionCallBack, this.deniedForever = false});

  final Function permissionCallBack;
  final bool deniedForever;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permissão para acessar sua localização'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Background(image: 'assets/google-places.png'),
              Positioned(
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.asset('assets/google-maps-pin.png'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Tiu,tiu',
                        style: GoogleFonts.miltonianTattoo(
                          textStyle: TextStyle(
                            letterSpacing: 12,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'precisa ter acesso total a sua localização para funcionar corretamente!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 3.2),
                      ButtonWide(
                        action: () {
                          permissionCallBack();
                        },
                        text: deniedForever ? 'IR P/ CONFIGURAÇÕES' : 'CONCEDER ACESSO',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
