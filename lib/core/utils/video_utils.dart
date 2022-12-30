import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/widgets/loading_video_screen.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/utils/file_cache_manager.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';

class VideoUtils {
  VideoUtils({this.post});

  final Post? post;

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  Future<ChewieController?> getChewieControllerAsync({
    bool isFullscreen = false,
    bool autoPlay = false,
  }) async {
    var videoPath = post?.video;
    final cachedVideos = await cachedVideosMap();
    final cacheExists = cachedVideos[post?.uid!] != null;

    if (cacheExists) {
      videoPath = cachedVideos[post?.uid!];
    }

    if (videoPath != null) {
      if (videoPath.toString().isUrl()) {
        debugPrint('TiuTiuApp: Async: VideoPath from internet');
        videoPlayerController = VideoPlayerController.network(videoPath);
      } else {
        debugPrint('TiuTiuApp: Async: VideoPath from cache');
        videoPath is String ? videoPath = File(videoPath) : videoPath;
        videoPlayerController = VideoPlayerController.file(videoPath);
      }
      chewieController = ChewieController(
        aspectRatio: videoPlayerController?.value.aspectRatio,
        videoPlayerController: videoPlayerController!,
        placeholder: Center(child: LoadingVideo()),
        showControlsOnInitialize: false,
        allowedScreenSleep: false,
        allowFullScreen: false,
        autoInitialize: true,
        showOptions: false,
        autoPlay: autoPlay,
        allowMuting: true,
        zoomAndPan: true,
      );

      return chewieController;
    }

    return null;
  }

  ChewieController? getChewieController({
    bool isFullscreen = false,
    bool autoPlay = false,
  }) {
    var videoPath = post?.video;

    if (videoPath != null) {
      if (videoPath.toString().isUrl()) {
        debugPrint('TiuTiuApp: VideoPath from internet');
        videoPlayerController = VideoPlayerController.network(videoPath);
      } else {
        debugPrint('TiuTiuApp: VideoPath from cache');
        videoPath is String ? videoPath = File(videoPath) : videoPath;
        videoPlayerController = VideoPlayerController.file(videoPath);
      }
      chewieController = ChewieController(
        aspectRatio: videoPlayerController!.value.aspectRatio * .95,
        videoPlayerController: videoPlayerController!,
        placeholder: Center(child: LoadingVideo()),
        showControlsOnInitialize: false,
        allowedScreenSleep: false,
        allowFullScreen: false,
        autoInitialize: true,
        autoPlay: autoPlay,
        allowMuting: true,
        zoomAndPan: true,
      );

      return chewieController;
    }

    return null;
  }

  Future<Map<String, dynamic>> cachedVideosMap() async {
    final storagedVideos = await LocalStorage.getValueUnderLocalStorageKey(
      LocalStorageKey.videosCached,
    );

    debugPrint('TiuTiuApp: Storaged Videos $storagedVideos');

    final Map<String, dynamic> cachedVideosMap = {};

    if (storagedVideos != null) {
      cachedVideosMap.addAll(storagedVideos);
    }

    return cachedVideosMap;
  }

  Future<void> _cacheVideo(Map<String, dynamic> cachedVideosMap) async {
    debugPrint('TiuTiuApp: Cache _cacheVideo');
    final videoPathSaved = await FileCacheManager.save(
      fileUrl: post!.video,
      filename: post!.uid!,
      type: FileType.video,
    );

    cachedVideosMap.putIfAbsent(post!.uid!, () => videoPathSaved);

    debugPrint('TiuTiuApp: Cache current video map $cachedVideosMap');

    await LocalStorage.setValueUnderLocalStorageKey(
      key: LocalStorageKey.videosCached,
      value: cachedVideosMap,
    );
  }

  Future<Map<String, dynamic>> getCachedAssets() async {
    final cachedVideos = await cachedVideosMap();

    debugPrint('TiuTiuApp: getCachedAssets Videos $cachedVideos');

    return cachedVideos;
  }

  Future<void> cacheVideos({required bool isInReviewMode}) async {
    final videosCachedData = await cachedVideosMap();

    if (!isInReviewMode && post?.video != null) {
      if (!videosCachedData.keys.contains(post!.uid)) {
        debugPrint('TiuTiuApp: Cache cacheVideos Video Not Saved');
        await _cacheVideo(videosCachedData);
      } else {
        debugPrint('TiuTiuApp: Cache cacheVideos Video Already Saved');
      }
    }
  }
}
