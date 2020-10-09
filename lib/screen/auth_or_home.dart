import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/screen/home.dart';
import 'package:tiutiu/screen/local_permission.dart';
import 'package:tiutiu/screen/register.dart';
import 'package:tiutiu/utils/routes.dart';

class AuthOrHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Authentication auth = Provider.of(context);
    Location local = Provider.of(context, listen: true);

    void openSettings() {
      local.openSeetings().then((value) => Navigator.pushNamed(context, Routes.AUTH_HOME));
    }

    void askPermission() {
      local.permissionRequest().then((value) => Navigator.pushNamed(context, Routes.AUTH_HOME));
    }

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
          return FutureBuilder<LocationPermission>(
            future: local.permissionCheck(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingPage();
              } else if (snapshot.data != LocationPermission.deniedForever) {
                if (snapshot.data == LocationPermission.always ||
                    snapshot.data == LocationPermission.whileInUse) {
                  if (auth.firebaseUser != null) {
                    return auth.isRegistered ? Home() : Register();
                  }
                  return Home();
                }
              } else if (snapshot.data == LocationPermission.deniedForever) {
                
                return LocalPermissionScreen(permissionCallBack: openSettings, deniedForever: true);
              }
              return LocalPermissionScreen(permissionCallBack: askPermission);
            },
          );
        }
      },
    );
  }
}
