import 'package:tiutiu/core/location/views/localization_service_access_permission_request.dart';
import 'package:tiutiu/core/extensions/service_location_status.dart';
import 'package:tiutiu/features/auth/views/authenticated_area.dart';
import 'package:tiutiu/features/posts/views/select_post_type.dart';
import 'package:tiutiu/features/auth/views/validated_area.dart';
import 'package:tiutiu/features/auth/views/verify_email.dart';
import 'package:tiutiu/features/auth/views/verify_phone.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class InitPostFlow extends StatelessWidget {
  const InitPostFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AuthenticatedArea(
        child: ValidatedArea(
          isValid: tiutiuUserController.tiutiuUser.emailVerified && tiutiuUserController.tiutiuUser.phoneVerified,
          validChild: currentLocationController.isPermissionGranted
              ? SelectPostType()
              : LocalizationServiceAccessPermissionAccess(
                  gpsIsActive: currentLocationController.gpsStatus.isActive,
                  showSpyButton: false,
                ),
          fallbackChild: !tiutiuUserController.tiutiuUser.emailVerified ? VerifyEmail() : VerifyPhone(),
        ),
      ),
    );
  }
}
