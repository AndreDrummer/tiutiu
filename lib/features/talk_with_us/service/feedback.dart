import 'package:tiutiu/features/talk_with_us/model/feedback.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FeedbackService {
  Future<bool> uploadFeedbackData(Feedback feedback) async {
    bool success = false;

    try {
      await EndpointResolver.getDocumentEndpoint(EndpointNames.pathToFeedback.name, [feedback.uid!])
          .set(feedback.toMap());
      if (kDebugMode) debugPrint('TiuTiuApp: Feedback Posted Successfully ${feedback.uid}');
      success = true;
    } on FirebaseException catch (exception) {
      crashlyticsController.reportAnError(
        message: 'Erro when tryna to send Feedback data to Firestore: $exception',
        exception: exception,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }

    return success;
  }

  Future<void> uploadPrints({required Function(List) onPrintsUploaded, required Feedback feedback}) async {
    try {
      final imagesStoragePath = _feedbackStoragePathToImages(feedback);

      if (kDebugMode) debugPrint('TiuTiuApp: Uploading feedback prints...');
      final imagesUrlDownloadList = await OtherFunctions.getImageListUrlDownload(
        imagesPathList: feedback.screenshots,
        storagePath: imagesStoragePath,
      );

      onPrintsUploaded(imagesUrlDownloadList);
    } on Exception catch (exception) {
      crashlyticsController.reportAnError(
        message: 'Erro when tryna to get prints url download list: $exception',
        exception: exception,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  String _feedbackStoragePathToImages(Feedback feedback) {
    return EndpointResolver.formattedEndpoint(EndpointNames.feedbackStoragePath.name, [
      feedback.uid,
      FileType.images.name,
    ]);
  }
}
