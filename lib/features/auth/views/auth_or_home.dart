import 'package:tiutiu/features/auth/views/start_screen_or_home.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/features/home/views/home.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiutiu/features/posts/views/post_detail.dart';

class AuthOrHome extends StatefulWidget {
  @override
  _AuthOrHomeState createState() => _AuthOrHomeState();
}

class _AuthOrHomeState extends State<AuthOrHome> {
  late Widget initialScreen;

  void setInitialScreen() {
    debugPrint('TiuTiuApp: Set Initial Screen...');
    debugPrint('TiuTiuApp: Dynamic DeepLink ${appController.initialFDLink}');
    if (appController.initialFDLink.isNotEmptyNeighterNull() && postsController.post.uid != null) {
      initialScreen = PostDetails();
    } else {
      initialScreen = Home();
    }
  }

  @override
  void initState() {
    setInitialScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('TiuTiuApp: Loading AuthOrHome... >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    return FutureBuilder(
      future: authController.tryAutoLoginIn(),
      builder: (_, AsyncSnapshot snapshot) {
        return AsyncHandler(
          errorMessage: AppStrings.authError,
          onErrorCallback: () async {
            await authController.signOut().then((_) {
              Get.offAllNamed(Routes.home);
            });
          },
          buildWidget: (_) => StartScreenOrSomeScreen(somescreen: initialScreen),
          snapshot: snapshot,
        );
      },
    );
  }
}
