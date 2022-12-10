import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/no_connection.dart';

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
        replacement: NoConnection(),
        visible: systemController.properties.internetConnected,
        child: isValid ? validChild : fallbackChild,
      ),
    );
  }
}
