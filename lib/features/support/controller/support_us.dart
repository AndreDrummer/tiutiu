import 'package:tiutiu/features/support/models/support_us.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SupportUsController extends GetxController {
  final Rx<SupportUsData> _supportUsData = SupportUsData().obs;

  SupportUsData get supportUsData => _supportUsData.value;

  Future<SupportUsData> getSupportUsData() async {
    try {
      final snapshot = await EndpointResolver.getDocumentEndpoint(EndpointNames.pathToSupportUsData.name).get();

      final data = SupportUsData.fromSnapshot(snapshot);
      _supportUsData(data);

      return supportUsData;
    } on FirebaseException catch (exception) {
      crashlyticsController.reportAnError(
        message: 'Error occured when trying get Support Us Data: ${exception.message}',
        exception: exception,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }
}
