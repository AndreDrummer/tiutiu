import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:flutter/foundation.dart';
import 'package:tiutiu/features/dennounce/model/user_dennounce.dart';

class DennounceServices {
  Future<bool> uploadPostDennounceData(PostDennounce postDennounce) async {
    bool success = false;

    try {
      await EndpointResolver.getDocumentEndpoint(EndpointNames.pathToPostDennounce.name, [postDennounce.uid])
          .set(postDennounce.toMap());
      debugPrint('TiuTiuApp: PostDennounce Data uploaded Successfully ${postDennounce.uid}');
      success = true;
    } on Exception catch (exception) {
      debugPrint('TiuTiuApp: Erro when tryna to send PostDennounce data to Firestore: $exception');
    }

    return success;
  }

  Future<bool> uploadUserDennounceData(UserDennounce userDennounce) async {
    bool success = false;

    try {
      await EndpointResolver.getDocumentEndpoint(EndpointNames.pathToUserDennounce.name, [userDennounce.uid])
          .set(userDennounce.toMap());
      debugPrint('TiuTiuApp: UserDennounce Data uploaded Successfully ${userDennounce.uid}');
      success = true;
    } on Exception catch (exception) {
      debugPrint('TiuTiuApp: Erro when tryna to send UserDennounce data to Firestore: $exception');
    }

    return success;
  }
}
