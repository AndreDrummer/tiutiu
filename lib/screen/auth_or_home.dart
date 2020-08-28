import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/screen/home.dart';
import 'package:loading_animations/loading_animations.dart';

class AuthOrHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Authentication>(
      builder: (context, auth, child) {
        return FutureBuilder(
          future: auth.tryAutoLoginIn(),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {              
              return Scaffold(
                backgroundColor: Colors.black87,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingBouncingGrid.square(
                        size: 100.0,
                        backgroundColor:  Theme.of(context).primaryColor,                        
                      ),
                      SizedBox(height: 30.0),
                      Text('Carregando aplicativo...', style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white
                      ))
                    ],
                  ),
                ),
              );
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
