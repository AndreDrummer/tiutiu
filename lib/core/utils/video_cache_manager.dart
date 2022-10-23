import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class VideoCacheManager {
  static Future<File> _downloadFile(String videoUrl, String fileName) async {
    final HttpClient httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(videoUrl));
    var response = await request.close();

    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$fileName.mp4');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<String> save(String videoUrl, String fileName) async {
    debugPrint('>>Cache saving...');
    final videoPathSaved = await _downloadFile(videoUrl, fileName);
    debugPrint('>>Cache saved!');

    return videoPathSaved.path;
  }
}
