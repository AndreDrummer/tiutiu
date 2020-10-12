import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/screen/home.dart';
import 'package:tiutiu/screen/no_connection.dart';
import 'package:tiutiu/screen/register.dart';

class AuthOrHome extends StatefulWidget {
  @override
  _AuthOrHomeState createState() => _AuthOrHomeState();
}

class _AuthOrHomeState extends State<AuthOrHome> {
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  bool isConnected;

  @override
  void initState() {
    isConnected = true;
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateStatus);
    super.initState();
  }

  void _updateStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.mobile) {
      print("3G/4G");
      setState(() {
        isConnected = true;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      String wifiName = await _connectivity.getWifiName();
      String wifiSsid = await _connectivity.getWifiBSSID();
      String wifiIp = await _connectivity.getWifiIP();
      print("Wi-Fi\n$wifiName\n$wifiSsid\n$wifiIp");
      setState(() {
        isConnected = true;
      });
    } else {
      print('Nao conectado');
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Authentication auth = Provider.of(context);

    return !isConnected ? NoConnection() : FutureBuilder(
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
                      border: Border.all(
                        style: BorderStyle.solid,
                      ),
                    ),
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
          if (auth.firebaseUser != null) {
            return auth.isRegistered ? Home() : Register();
          }
          return Home();
        }
      },
    );
  }
}
