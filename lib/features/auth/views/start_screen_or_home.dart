import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/system/views/loading_start_screen.dart';
import 'package:tiutiu/features/auth/views/start_screen.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:flutter/material.dart';

class StartScreenOrSomeScreen extends StatefulWidget {
  const StartScreenOrSomeScreen({
    Key? key,
    required this.somescreen,
  }) : super(key: key);

  final Widget somescreen;

  @override
  State<StartScreenOrSomeScreen> createState() => _StartScreenOrSomeScreenState();
}

class _StartScreenOrSomeScreenState extends State<StartScreenOrSomeScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalStorage.getUnderBooleanKey(key: LocalStorageKey.firstOpen),
      builder: (_, AsyncSnapshot<bool> snapshot) {
        return AsyncHandler<bool>(
          loadingWidget: SplashScreenLoading(),
          snapshot: snapshot,
          buildWidget: (firstOpen) {
            LocalStorage.setBooleanUnderKey(
              key: LocalStorageKey.firstOpen,
              value: false,
            );

            final hasAcceptedTerms = authController.userExists
                ? tiutiuUserController.tiutiuUser.hasAcceptedTerms
                : systemController.properties.hasAcceptedTerms;

            return (firstOpen || !hasAcceptedTerms) ? StartScreen() : widget.somescreen;
          },
        );
      },
    );
  }
}
