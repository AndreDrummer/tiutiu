import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/screen/auth_or_home.dart';
import 'package:tiutiu/screen/local_permission.dart';

class Bootstrap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Location local = Provider.of(context);    

    return FutureBuilder<LocationPermission>(
      future: local.permissionCheck(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        } else if (snapshot.data == LocationPermission.deniedForever) {
          return LocalPermissionScreen(permissionCallBack: local.openSeetings, deniedForever: true);
        } else if (snapshot.data == LocationPermission.denied) {
          return LocalPermissionScreen(permissionCallBack: local.permissionRequest);
        }
        return AuthOrHome();
      },
    );
  }
}
