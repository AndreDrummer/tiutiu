import 'package:tiutiu/features/auth/views/which_screen.dart';
import 'package:tiutiu/features/more/views/edit_profile.dart';
import 'package:tiutiu/features/auth/views/start_screen.dart';
import 'package:tiutiu/features/auth/views/auth_hosters.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/views/load_dark_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthenticatedArea extends StatelessWidget {
  const AuthenticatedArea({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(builder: (context) {
        return Obx(() {
          final bool isRegistered = tiutiuUserController.isAppropriatelyRegistered;
          final user = authController.user;

          if (kDebugMode) debugPrint('TiuTiuApp: Is registered? ${tiutiuUserController.isAppropriatelyRegistered}');

          if (isRegistered) {
            return child;
          } else {
            final isAuthenticated = user != null;

            if (kDebugMode) debugPrint('TiuTiuApp: Is authenticated? $isAuthenticated');

            if (isAuthenticated && !isRegistered) return EditProfile(isEditingProfile: false);
            if (isAuthenticated && isRegistered) return child;
          }

          return user == null ? WhichScreen(screen: StartScreen(), eigtherScreen: AuthHosters()) : LoadDarkScreen();
        });
      }),
    );
  }
}
