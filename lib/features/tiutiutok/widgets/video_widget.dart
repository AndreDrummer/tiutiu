import 'package:tiutiu/features/tiutiutok/widgets/android_tiutiutok_video.dart';
import 'package:tiutiu/features/tiutiutok/widgets/ios_tiutiutok_video.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class VideoWidget extends StatelessWidget {
  const VideoWidget({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      replacement: AndroidTiutiuTokVideo(post: post),
      child: IOSTiutiuTokVideo(post: post),
      visible: Platform.isIOS,
    );
  }
}
