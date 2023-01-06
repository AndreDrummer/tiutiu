import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class FileCacheManager {
  static Future<File> _downloadFile({
    required String filename,
    required String fileUrl,
    required FileType type,
  }) async {
    final HttpClient httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(fileUrl));
    var response = await request.close();

    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;

    final name = type == FileType.images ? '$filename.png' : '$filename.mp4';

    File file = new File('$dir/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<String> save({
    required String filename,
    required String fileUrl,
    required FileType type,
  }) async {
    final fileSavedType = type == FileType.images ? 'image' : 'video';

    final fileSavedPath = await _downloadFile(
      filename: filename,
      fileUrl: fileUrl,
      type: type,
    );

    debugPrint('TiuTiuApp: Cache $fileSavedType saved!');

    return fileSavedPath.path;
  }
}
