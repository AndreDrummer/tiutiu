import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/screen/home.dart';

class AuthOrHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) { 
    return Consumer<Authentication>(
      builder: (context, auth, child) {
        return FutureBuilder(
          future: auth.tryAutoLoginIn(),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // TODO: Criar uma tela personalizada de carregamento.
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Ocorreu um erro! ${snapshot.error}'));
            } else {
              print('Esta logado? ${auth.firebaseUser != null}');
              return auth.firebaseUser != null ? Home() : AuthScreen();
            }
          },
        );
      },
    );
  }
}
