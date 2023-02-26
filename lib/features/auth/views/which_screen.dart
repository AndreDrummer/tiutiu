import 'package:tiutiu/core/system/views/loading_start_screen.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:flutter/material.dart';

class WhichScreen extends StatefulWidget {
  const WhichScreen({
    Key? key,
    required this.eigtherScreen,
    required this.screen,
    this.condition,
  }) : super(key: key);

  final Widget eigtherScreen;
  final bool? condition;
  final Widget screen;

  @override
  State<WhichScreen> createState() => _WhichScreenState();
}

class _WhichScreenState extends State<WhichScreen> {
  late bool condition;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalStorage.getBooleanUnderKey(key: LocalStorageKey.firstOpen),
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

            condition = widget.condition ?? (firstOpen || !hasAcceptedTerms);

            return condition ? widget.screen : widget.eigtherScreen;
          },
        );
      },
    );
  }
}
