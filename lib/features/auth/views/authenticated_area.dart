import 'package:tiutiu/features/auth/views/auth_hosters.dart';
import 'package:tiutiu/features/profile/views/profile.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:flutter/material.dart';

class AuthenticatedArea extends StatelessWidget {
  const AuthenticatedArea({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isRegistered = tiutiuUserController.tiutiuUser.uid != null;
    final isAuthenticated = authController.userExists;

    if (isAuthenticated && isRegistered) return child;
    if (isAuthenticated && !isRegistered)
      return Profile(
        user: tiutiuUserController.tiutiuUser,
        isCompletingProfile: true,
      );
    return AuthHosters();
  }
}
