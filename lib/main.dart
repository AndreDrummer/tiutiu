import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/routes/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tiutiu/initializers.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await TiuTiuInitializer.start();

  runApp(TiuTiuApp());
}

class TiuTiuApp extends StatefulWidget {
  @override
  State<TiuTiuApp> createState() => _TiuTiuAppState();
}

class _TiuTiuAppState extends State<TiuTiuApp> {
  late StreamSubscription<ConnectivityResult> connecitivitySubscription;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    connecitivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      systemController.handleInternetConnectivityStatus(result);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, __) => GetMaterialApp(
        title: 'Tiu, tiu - App',
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0XFFF9F9F9),
          primarySwatch: AppColors.secondary,
          primaryColor: AppColors.primary,
        ),
        onGenerateRoute: RouterGenerator.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.root,
      ),
    );
  }
}
