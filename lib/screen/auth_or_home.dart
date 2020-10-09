import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/screen/home.dart';
import 'package:tiutiu/screen/local_permission.dart';
import 'package:tiutiu/screen/register.dart';

class AuthOrHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Authentication auth = Provider.of(context);
    Location local = Provider.of(context, listen: true);

    return FutureBuilder(
      future: auth.tryAutoLoginIn(),
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Ocorreu um erro!'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(style: BorderStyle.solid)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/pata.jpg'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${snapshot.error}',
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  FlatButton.icon(
                    onPressed: () {
                      auth.signOut();
                    },
                    icon: Icon(Icons.exit_to_app),
                    label: Text('Deslogar'),
                  )
                ],
              ),
            ),
          );
        } else {
          if (local.location == null) {
            return LocalPermissionScreen(
              permissionCallBack: () {
                local.setLocation();                
              },
            );
          }
          if (auth.firebaseUser != null) {
            return auth.isRegistered ? Home() : Register();
          }
          return Home();
        }
      },
    );
  }
}
