import 'package:tiutiu/features/sponsored/services/sponsored_services.dart';
import 'package:tiutiu/features/sponsored/model/sponsored.dart';
import 'package:get/get.dart';

class SponsoredController extends GetxController {
  SponsoredController({required SponsoredServices sponsoredServices}) : _sponsoredServices = sponsoredServices;

  final SponsoredServices _sponsoredServices;

  final RxList<Sponsored> _sponsoreds = <Sponsored>[].obs;

  List<Sponsored> get sponsoreds => _sponsoreds;

  Future<void> sponsoredAds() async {
    final querySnapshot = await _sponsoredServices.pathToSponsoredAds().get();

    _sponsoreds(querySnapshot.docs.map((sponsored) => Sponsored.fromSnapshot(sponsored)).toList());
  }
}
