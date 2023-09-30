import 'package:tiutiu/core/system/views/loading_start_screen.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/auth/views/which_screen.dart';
import 'package:tiutiu/features/auth/views/start_screen.dart';
import 'package:tiutiu/features/posts/views/post_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/widgets/connection_handler.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/features/home/views/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthOrHome extends StatefulWidget {
  @override
  _AuthOrHomeState createState() => _AuthOrHomeState();
}

class _AuthOrHomeState extends State<AuthOrHome> {
  late Widget initialScreen;

  void setInitialScreen() {
    if (kDebugMode) debugPrint('TiuTiuApp: Set Initial Screen...');
    if (kDebugMode) debugPrint('TiuTiuApp: Dynamic DeepLink ${systemController.initialFDLink}');
    if (systemController.initialFDLink.isNotEmptyNeighterNull() && postsController.post.uid != null) {
      initialScreen = PostDetails();
    } else {
      initialScreen = ConnectionScreenHandler(child: Home());
    }
  }

  @override
  void initState() {
    setInitialScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) debugPrint('TiuTiuApp: Loading AuthOrHome... >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    return FutureBuilder(
      future: authController.tryAutoLoginIn(),
      builder: (_, AsyncSnapshot snapshot) {
        return AsyncHandler(
          errorMessage: AppLocalizations.of(context)!.authError,
          loadingWidget: SplashScreenLoading(),
          onErrorCallback: () async {
            await authController.signOut().then((_) {
              Get.offAllNamed(Routes.home);
            });
          },
          buildWidget: (_) => WhichScreen(screen: StartScreen(), eigtherScreen: initialScreen),
          snapshot: snapshot,
        );
      },
    );
  }
}
