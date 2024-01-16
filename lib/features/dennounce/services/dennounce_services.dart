import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:flutter/foundation.dart';
import 'package:tiutiu/features/dennounce/model/user_dennounce.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';

class DennounceServices {
  Future<bool> uploadPostDennounceData(PostDennounce postDennounce) async {
    bool success = false;

    try {
      await EndpointResolver.getDocumentEndpoint(EndpointNames.pathToPostDennounce.name, [postDennounce.uid])
          .set(postDennounce.toMap());
      if (kDebugMode) debugPrint('TiuTiuApp: PostDennounce Data uploaded Successfully ${postDennounce.uid}');
      success = true;
    } on Exception catch (exception) {
      crashlyticsController.reportAnError(
        message: 'Erro when tryna to send PostDennounce data to Firestore: $exception',
        exception: exception,
        stackTrace: StackTrace.current,
      );
    }

    return success;
  }

  Future<void> increaseUserDennounces(String userId) async {
    await EndpointResolver.getDocumentEndpoint(EndpointNames.pathToUser.name, [userId]).set({
      TiutiuUserEnum.timesDennounced.name: FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Future<bool> uploadUserDennounceData(UserDennounce userDennounce) async {
    bool success = false;

    try {
      await EndpointResolver.getDocumentEndpoint(EndpointNames.pathToUserDennounce.name, [userDennounce.uid])
          .set(userDennounce.toMap());
      if (kDebugMode) debugPrint('TiuTiuApp: UserDennounce Data uploaded Successfully ${userDennounce.uid}');
      success = true;
    } on Exception catch (exception) {
      crashlyticsController.reportAnError(
        message: ' Erro when tryna to send UserDennounce data to Firestore: $exception',
        exception: exception,
        stackTrace: StackTrace.current,
      );
    }

    return success;
  }
}
