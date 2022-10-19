import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:tiutiu/core/local_storage/local_storage.dart';

class VideoCacheManager {
  static Future<File> _downloadFile(String videoUrl, String fileName) async {
    final HttpClient httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(videoUrl));
    var response = await request.close();

    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<void> save(String videoUrl, String fileName) async {
    final videoFile = await _downloadFile(videoUrl, fileName);

    await LocalStorage.setValueUnderString(
      value: videoFile.path,
      key: fileName,
    );

    debugPrint('Video Cached $fileName: $videoUrl');
  }

  static Future<String> getCachedVideoIfExists(String videoFileName) async {
    return await LocalStorage.getValueUnderString(videoFileName);
  }
}
