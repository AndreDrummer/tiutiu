import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/refine_search.dart';
import 'package:tiutiu/screen/auth_or_home.dart';
import 'package:tiutiu/screen/local_permission.dart';
import 'package:tiutiu/utils/other_functions.dart';

class Bootstrap extends StatefulWidget {
  @override
  _BootstrapState createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  Location local;
  RefineSearchProvider refineSearchProvider;

  @override
  void initState() {    
    super.initState();
  }

  @override
  void didChangeDependencies() {
    local = Provider.of<Location>(context);
    refineSearchProvider = Provider.of<RefineSearchProvider>(context);
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
            if (local.getLocation == null) {
              local.setLocation();                
            }
            return FutureBuilder<Object>(
              future: OtherFunctions.getUserLocalState(local.getLocation),
              builder: (context, snapshot) {
                refineSearchProvider.changeStateOfResultSearch(snapshot.data);
                return AuthOrHome();
              }
            );
          },
        );
      },
    );
  }
}
