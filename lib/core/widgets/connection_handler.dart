import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiutiu/core/views/no_connection_screen.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConnectionScreenHandler extends StatelessWidget {
  const ConnectionScreenHandler({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return systemController.properties.internetConnected ? child : NoConnectionScreen();
    });
  }
}
