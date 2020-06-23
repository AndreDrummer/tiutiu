import 'package:flutter/material.dart';

class PetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PETs na redondeza'),        
      ),
      body: Center(
        child: Text('Vai ter uma listta de PET aqui'),
      ),
    );
  }
}