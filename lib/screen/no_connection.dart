import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiutiu/core/constants/images_assets.dart';

class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: AutoSizeText('Sem conexão com a internet')),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 3),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(ImageAssets.noWifi,
                      color: Colors.red, width: 50, height: 50),
                ),
              ),
              SizedBox(height: 20),
              AutoSizeText(
                'Você não está conectado à internet.',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    'Conecte-se a uma rede para utilizar',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  AutoSizeText(
                    ' Tiu, tiu.',
                    style: GoogleFonts.miltonianTattoo(
                      textStyle: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
