import 'package:tiutiu/core/remote_config/model/admin_remote_config.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminRemoteConfigServices {
  Stream<AdminRemoteConfig> getAdminRemoteConfig(AdminRemoteConfig currentConfig) {
    try {
      return EndpointResolver.getDocumentEndpoint(EndpointNames.pathToAdminRemoteConfigs.name)
          .snapshots()
          .asyncMap(currentConfig.fromSnapshot);
    } on FirebaseException catch (exception) {
      debugPrint('TiuTiuApp: Error occured when trying get System Properties: ${exception.message}');
      rethrow;
    }
  }
}
