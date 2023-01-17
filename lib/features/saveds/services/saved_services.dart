import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedServices {
  CollectionReference<Map<String, dynamic>> savesCollection() {
    return EndpointResolver.getCollectionEndpoint(
      EndpointNames.pathToSaveds.name,
      [tiutiuUserController.tiutiuUser.uid],
    );
  }
}
