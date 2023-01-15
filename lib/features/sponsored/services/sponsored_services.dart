import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SponsoredServices {
  CollectionReference<Map<String, dynamic>> pathToSponsoredAds() {
    return EndpointResolver.getCollectionEndpoint(EndpointNames.pathToSponsoredAds.name);
  }
}
