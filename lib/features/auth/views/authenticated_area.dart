import 'package:flutter/material.dart';
import 'package:tiutiu/features/auth/views/auth_hosters.dart';
import 'package:tiutiu/features/system/controllers.dart';

class AuthenticatedArea extends StatelessWidget {
  const AuthenticatedArea({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = authController.userExists;

    return isAuthenticated ? child : AuthHosters();
  }
}
