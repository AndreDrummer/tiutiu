import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/system/model/endpoint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseAdministration {
  void updateEndpointsSintaxe() async {
    try {
      debugPrint('|| Updating Endpoint name... ||');
      final a = await _pathToEndpoints('prod').get();
      final docs = a.docs;

      for (int i = 0; i < docs.length; i++) {
        final endpoint = Endpoint.fromSnapshot(docs[i]);
        // print('Endpoint ${endpoint.name}');
        // if (endpoint.name == "pathToPostDennounces") {
        debugPrint('|| Atual Endpoint $endpoint... ||');
        final newEndpoint = Endpoint(
          example: endpoint.example.replaceAll('debug', 'prod'),
          path: endpoint.path,
          type: endpoint.type,
          name: endpoint.name,
        );

        debugPrint('|| Novo Endpoint $newEndpoint... ||');
        await updateEndpoint(newEndpoint);
        // }
      }
    } catch (merda) {
      debugPrint('||  Merda $merda... ||');
    }
  }

  Future updateEndpoint(Endpoint endpoint) async {
    await _pathToEndpoint(endpoint.name).set(endpoint.toMap());
  }

  void moveEndpointsToProd() async {
    debugPrint('|| MIGRATION Starting... ||');
    _pathToEndpoints('debug').snapshots().forEach((event) {
      event.docs.forEach((e) {
        _pathToEndpoints('prod').doc(e.id).set(e.data());
      });
    });
    debugPrint('|| MIGRATION Finished! ||');
  }

  void moveSomeDocumentDataToProd() async {
    debugPrint('|| MIGRATION Starting... ||');
    final migratingDocument = 'adminRemoteConfigs';

    final data = await _pathToDocumentData('debug', migratingDocument).get();
    debugPrint('|| MDATA ${data.data()} ||');

    _pathToDocumentData('prod', migratingDocument).set(data.data() ?? {});
  }

  CollectionReference<Map<String, dynamic>> _pathToEndpoints(String environment) {
    return FirebaseFirestore.instance
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(environment)
        .doc(FirebaseEnvPath.endpoints)
        .collection(FirebaseEnvPath.endpoints);
  }

  DocumentReference<Map<String, dynamic>> _pathToDocumentData(String environment, String documentName) {
    return FirebaseFirestore.instance
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(environment)
        .doc(documentName);
  }

  DocumentReference<Map<String, dynamic>> _pathToEndpoint(String endpointName) {
    return FirebaseFirestore.instance
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection('debug')
        .doc(FirebaseEnvPath.endpoints)
        .collection(FirebaseEnvPath.endpoints)
        .doc(endpointName);
  }
}
