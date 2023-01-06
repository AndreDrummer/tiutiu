import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiutiu/core/views/no_connection_screen.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/material.dart';

class ValidatedArea extends StatelessWidget {
  const ValidatedArea({
    required this.fallbackChild,
    required this.validChild,
    required this.isValid,
    super.key,
  });

  final Widget fallbackChild;
  final Widget validChild;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        replacement: NoConnectionScreen(),
        visible: appController.properties.internetConnected,
        child: isValid ? validChild : fallbackChild,
      ),
    );
  }
}
