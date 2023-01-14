import 'package:tiutiu/features/sponsored/model/sponsored.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';

class SponsoredServices {
  Stream<List<Sponsored>> sponsoredAds() {
    return EndpointResolver.getCollectionEndpoint(EndpointNames.pathToSponsoredAds.name)
        .snapshots()
        .asyncMap((querySnapshot) {
      return querySnapshot.docs
          .map((documentSnapshot) => Sponsored(
                imagePath: documentSnapshot.get(SponsoredEnum.imagePath.name),
                title: documentSnapshot.get(SponsoredEnum.title.name),
                link: documentSnapshot.get(SponsoredEnum.link.name),
              ))
          .toList();
    });
  }
}
