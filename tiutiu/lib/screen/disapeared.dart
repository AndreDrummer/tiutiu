import 'package:flutter/material.dart';

class Disapeared extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PETs Desaparecidos',
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black
              ),
        ),
      ),
      body: Center(
        child: Text('Vai ter uma lista de PET aqui'),
      ),
    );
  }
}
