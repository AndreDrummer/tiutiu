import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiutiu/core/utils/routes/router.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(TiuTiuApp());
}

class TiuTiuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, __) => GetMaterialApp(
        title: 'Tiu, tiu - App',
        theme: ThemeData(
          primaryColor: Colors.green,
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: Color(0XFFF9F9F9),
        ),
        onGenerateRoute: RouterGenerator.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.root,
      ),
    );
  }
}
