import 'package:tiutiu/features/auth/models/firebase_auth_provider.dart';
import 'package:tiutiu/features/auth/views/auth_hosters.dart';
import 'package:tiutiu/features/auth/views/start_screen_or_home.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiutiu/features/profile/views/settings.dart';
import 'package:tiutiu/core/widgets/load_dark_screen.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticatedArea extends StatelessWidget {
  const AuthenticatedArea({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final authProvider = FirebaseAuthProvider.instance;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(builder: (context) {
        return StreamBuilder<User?>(
          stream: authProvider.userStream(),
          builder: (context, snapshot) {
            return Obx(() {
              final bool isRegistered = tiutiuUserController.isAppropriatelyRegistered;

              debugPrint('>> Is registered? ${tiutiuUserController.isAppropriatelyRegistered}');

              if (isRegistered) {
                return child;
              } else if (snapshot.hasData) {
                final user = snapshot.requireData;
                final isAuthenticated = user != null;

                debugPrint('>> Is authenticated? $isAuthenticated');

                if (isAuthenticated && !isRegistered) return Settings(isEditingProfile: false);
                if (isAuthenticated && isRegistered) return child;
              }

              return authProvider.firebaseAuthUser == null
                  ? StartScreenOrSomeScreen(somescreen: AuthHosters())
                  : LoadDarkScreen();
            });
          },
        );
      }),
    );
  }
}
