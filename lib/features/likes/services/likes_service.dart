import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikesService {
  CollectionReference<Map<String, dynamic>> likedsCollection() {
    return EndpointResolver.getCollectionEndpoint(
      EndpointNames.pathToLikes.name,
      [tiutiuUserController.tiutiuUser.uid],
    );
  }
}
