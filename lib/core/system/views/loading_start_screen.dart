import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/system/app_bootstrap.dart';
import 'package:flutter/material.dart';

class LoadingStartScreen extends StatefulWidget {
  const LoadingStartScreen({super.key});

  @override
  State<LoadingStartScreen> createState() => _LoadingStartScreenState();
}

class _LoadingStartScreenState extends State<LoadingStartScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: systemController.loadApp(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
          case ConnectionState.none:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            return Center(
              child: AppBootstrap(),
            );
        }
      },
    );
  }
}
