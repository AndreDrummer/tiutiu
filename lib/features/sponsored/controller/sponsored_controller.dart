import 'package:tiutiu/features/sponsored/services/sponsored_services.dart';
import 'package:tiutiu/features/sponsored/model/sponsored.dart';
import 'package:get/get.dart';

class SponsoredController extends GetxController {
  SponsoredController({required SponsoredServices sponsoredServices}) : _sponsoredServices = sponsoredServices;

  final SponsoredServices _sponsoredServices;

  final RxList<Sponsored> _sponsored = <Sponsored>[].obs;

  Stream<List<Sponsored>> sponsoredAds() {
    return _sponsoredServices.sponsoredAds().asyncMap(_sponsored);
  }
}
