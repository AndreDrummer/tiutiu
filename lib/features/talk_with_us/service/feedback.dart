import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/features/talk_with_us/model/feedback.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:flutter/foundation.dart';

class FeedbackService {
  Future<bool> uploadFeedbackData(Feedback feedback) async {
    bool success = false;

    try {
      await FirebaseFirestore.instance.collection(pathToFeedbacks).doc(feedback.uid!).set(feedback.toMap());
      debugPrint('>> Feedback Posted Successfully ${feedback.uid}');
      success = true;
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to send Feedback data to Firestore: $exception');
    }

    return success;
  }

  Future<void> uploadPrints({required Function(List) onPrintsUploaded, required Feedback feedback}) async {
    try {
      final imagesStoragePath = _feedbackStoragePathToImages(feedback);

      debugPrint('>> Uploading feedback prints...');
      final imagesUrlDownloadList = await OtherFunctions.getImageListUrlDownload(
        imagesPathList: feedback.screenshots,
        storagePath: imagesStoragePath,
      );

      onPrintsUploaded(imagesUrlDownloadList);
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to get prints url download list: $exception');
      rethrow;
    }
  }

  String _feedbackStoragePathToImages(Feedback feedback) => feedbackStoragePath(
        fileType: FileType.images.name,
        userId: feedback.ownerId!,
        postId: feedback.uid!,
      );
}
