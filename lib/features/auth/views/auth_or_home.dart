import 'package:tiutiu/features/auth/views/auth_error.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/features/home/views/home.dart';
import 'package:tiutiu/screen/no_connection.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthOrHome extends StatefulWidget {
  @override
  _AuthOrHomeState createState() => _AuthOrHomeState();
}

class _AuthOrHomeState extends State<AuthOrHome> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !system.internetConnected
          ? NoConnection()
          : FutureBuilder(
              future: authController.tryAutoLoginIn(),
              builder: (_, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingPage();
                } else if (snapshot.hasError) {
                  return AuthErrorPage();
                } else {
                  return Home();
                }
              },
            ),
    );
  }
}
