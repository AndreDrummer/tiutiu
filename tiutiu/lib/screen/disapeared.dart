import 'package:flutter/material.dart';

class Disapeared extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PETs Desaparecidos',
          style: Theme.of(context).textTheme.headline4,),        
      ),
      body: Center(
        child: Text('Vai ter uma lista de PET aqui'),
      ),
    );
  }
}