import 'package:tiutiu/features/auth/models/firebase_auth_provider.dart';
import 'package:tiutiu/features/profile/views/edit_profile.dart';
import 'package:tiutiu/features/auth/views/auth_hosters.dart';
import 'package:tiutiu/features/system/controllers.dart';
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
        final isRegistered = tiutiuUserController.tiutiuUser.uid != null;
        // authProvider.signOut();
        if (isRegistered) {
          return child;
        } else if (snapshot.hasData) {
          final user = snapshot.requireData;
          final isAuthenticated = user != null;

          if (isAuthenticated && !isRegistered)
            return EditProfile(isCompletingProfile: true);
        }
        return authProvider.firebaseAuthUser == null
            ? AuthHosters()
            : EditProfile();
      },
    );
  }
}
