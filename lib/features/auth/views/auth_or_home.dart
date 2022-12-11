import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/features/auth/views/start_screen.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/features/home/views/home.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthOrHome extends StatefulWidget {
  @override
  _AuthOrHomeState createState() => _AuthOrHomeState();
}

class _AuthOrHomeState extends State<AuthOrHome> {
  @override
  Widget build(BuildContext context) {
    debugPrint('>> Loading AuthOrHome... >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    return FutureBuilder(
      future: authController.tryAutoLoginIn(),
      builder: (_, AsyncSnapshot snapshot) {
        return AsyncHandler(
          errorMessage: AppStrings.authError,
          onErrorCallback: () async {
            await authController.signOut().then((_) {
              Get.offAllNamed(Routes.home);
            });
          },
          snapshot: snapshot,
          buildWidget: (_) {
            return FutureBuilder(
              future: LocalStorage.getBooleanKey(
                key: LocalStorageKey.firstOpen,
              ),
              builder: (_, AsyncSnapshot<bool> snapshot) {
                return AsyncHandler<bool>(
                  snapshot: snapshot,
                  buildWidget: (firstOpen) {
                    LocalStorage.setBooleanUnderKey(
                      key: LocalStorageKey.firstOpen,
                      value: false,
                    );

                    return firstOpen ? StartScreen() : Home();
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
