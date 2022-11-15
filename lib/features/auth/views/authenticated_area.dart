import 'package:tiutiu/core/utils/validators.dart';
import 'package:tiutiu/features/auth/models/firebase_auth_provider.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/profile/views/edit_profile.dart';
import 'package:tiutiu/features/auth/views/auth_hosters.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/widgets/load_dark_screen.dart';
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

    return StreamBuilder<User?>(
      stream: authProvider.userStream(),
      builder: (context, snapshot) {
        final isRegistered = _isAppropriatelyRegistered(tiutiuUserController.tiutiuUser);

        debugPrint('>> Is registered? $isRegistered');

        if (isRegistered) {
          return child;
        } else if (snapshot.hasData) {
          final user = snapshot.requireData;
          final isAuthenticated = user != null;

          debugPrint('>> Is authenticated? $isAuthenticated');

          if (isAuthenticated && !isRegistered) return EditProfile(isCompletingProfile: true);
          if (isAuthenticated && isRegistered) return child;
        }

        return authProvider.firebaseAuthUser == null ? AuthHosters() : LoadDarkScreen();
      },
    );
  }

  bool _isAppropriatelyRegistered(TiutiuUser user) {
    bool registered = false;

    final hasNumber = Validators.isValidPhone(user.phoneNumber);
    final hasName = user.displayName != null;
    final hasAvatar = user.avatar != null;
    final hasUid = user.uid != null;

    registered = hasNumber && hasName && hasAvatar && hasUid;

    return registered;
  }
}
