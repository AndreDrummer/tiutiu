import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/system/model/endpoint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SystemService {
  Stream<List<Endpoint>> getAppEndpoints() {
    try {
      return _pathToEndpoints().snapshots().asyncMap((querySnapshots) {
        return querySnapshots.docs.map((snapshot) => Endpoint.fromSnapshot(snapshot)).toList();
      });
    } on FirebaseException catch (exception) {
      debugPrint('Error occured when trying get app endpoints: ${exception.message}');
      rethrow;
    }
  }
}

CollectionReference<Map<String, dynamic>> _pathToEndpoints() {
  return FirebaseFirestore.instance
      .collection(FirebaseEnvPath.projectName)
      .doc(FirebaseEnvPath.env)
      .collection(FirebaseEnvPath.environment)
      .doc(FirebaseEnvPath.endpoints)
      .collection(FirebaseEnvPath.endpoints);
}
