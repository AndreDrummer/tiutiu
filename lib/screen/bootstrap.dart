import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/screen/auth_or_home.dart';
import 'package:tiutiu/screen/local_permission.dart';

class Bootstrap extends StatefulWidget {
  @override
  _BootstrapState createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  Location local;

  @override
  void initState() {
    // Ads.closeAllAds();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    local = Provider.of<Location>(context);
    local.permissionCheck();
    local.locationServiceIsEnabled();    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: local.locationServiceEnabled,
      builder: (ctx, snapshot) { 
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        }
        print('GPS ${snapshot.data}');
        if (!snapshot.data) {
          return LocalPermissionScreen(
            permissionCallBack: local.openLocalSettings,
            serviceEnabled: snapshot.data,
          );
        }      
        return StreamBuilder<LocationPermission>(
          stream: local.permission,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage();
            } else if (snapshot.data == LocationPermission.deniedForever) {
              return LocalPermissionScreen(permissionCallBack: local.openSeetings, deniedForever: true);
            } else if (snapshot.data == LocationPermission.denied) {
              return LocalPermissionScreen(permissionCallBack: local.permissionRequest,
              );
            }
            local.getLocation == null ? local.setLocation() : () {};
            return AuthOrHome();
          },
        );
      },
    );
  }
}
