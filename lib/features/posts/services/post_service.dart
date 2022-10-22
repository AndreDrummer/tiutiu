import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/data/states_and_cities.dart';
import 'package:tiutiu/core/models/filter_params.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:flutter/foundation.dart';

class PostService {
  Stream<QuerySnapshot<Map<String, dynamic>>> loadPets(
    FilterParams filterParams,
  ) {
    final filterType =
        filterParams.type == PetTypeStrings.all ? null : filterParams.type;

    final disappeared = filterParams.disappeared;

    var filterState =
        filterParams.state == StatesAndCities().stateInitials.first
            ? null
            : filterParams.state;

    if (filterState != null) {
      filterState = StatesAndCities().stateNames.elementAt(
            StatesAndCities().stateInitials.indexOf(filterState),
          );
    }

    return FirebaseFirestore.instance
        .collection(pathToPosts)
        .where(FilterParamsEnum.disappeared.name, isEqualTo: disappeared)
        .where(FilterParamsEnum.state.name, isEqualTo: filterState)
        .where(FilterParamsEnum.type.name, isEqualTo: filterType)
        .snapshots();
  }

  Future<void> uploadVideo({
    required Function(String?) onVideoUploaded,
    required Pet post,
  }) async {
    try {
      final videosStoragePath = userPostsStoragePath(
        fileType: FileType.video.name,
        userId: post.ownerId!,
        postId: post.uid!,
      );

      final videoUrlDownload = await OtherFunctions.getVideoUrlDownload(
        storagePath: videosStoragePath,
        videoPath: post.video,
      );

      onVideoUploaded(videoUrlDownload);
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to get video url download: $exception');
    }
  }

  Future<void> uploadImages({
    required Function(List) onImagesUploaded,
    required Pet post,
  }) async {
    try {
      final imagesStoragePath = userPostsStoragePath(
        fileType: FileType.images.name,
        userId: post.ownerId!,
        postId: post.uid!,
      );

      final imagesUrlDownloadList =
          await OtherFunctions.getImageListUrlDownload(
        storagePath: imagesStoragePath,
        imagesPathList: post.photos,
      );

      onImagesUploaded(imagesUrlDownloadList);
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to get images url download list: $exception');
    }
  }

  Future<bool> uploadPostData(Pet post) async {
    bool success = false;

    try {
      await FirebaseFirestore.instance
          .collection(pathToPosts)
          .doc(post.uid!)
          .set(post.toMap());
      debugPrint('>> Posted Successfully ${post.uid}');
      success = true;
    } on Exception catch (exception) {
      debugPrint('Erro when tryna to send data to Firestore: $exception');
    }

    return success;
  }
}
