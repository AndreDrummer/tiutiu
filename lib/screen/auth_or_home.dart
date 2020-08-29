import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/screen/home.dart';

class AuthOrHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Authentication auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLoginIn(),
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        } else if (snapshot.hasError) {
          return Center(child: Text('Ocorreu um erro! ${snapshot.error}'));
        } else {
          print('Esta logado? ${auth.firebaseUser != null}');
          return auth.firebaseUser != null ? Home() : AuthScreen();
        }
      },
    );
  }
}
