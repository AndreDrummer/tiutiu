import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class PostDetailVideo extends StatefulWidget {
  const PostDetailVideo({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<PostDetailVideo> createState() => _PostDetailVideoState();
}

class _PostDetailVideoState extends State<PostDetailVideo> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;

  @override
  void initState() {
    super.initState();

    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,
      cacheConfiguration: BetterPlayerCacheConfiguration(
        key: LocalStorageKey.videosCached.name,
        maxCacheFileSize: 10 * 1024 * 1024,
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 10 * 1024 * 1024,
        useCache: true,
      ),
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        allowedScreenSleep: false,
        aspectRatio: .5,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.triangleExclamation, color: AppColors.white),
                SizedBox(height: 4.0.h),
                AutoSizeTexts.autoSizeText14('Erro ao reproduzir o video', color: AppColors.white),
                SizedBox(height: 16.0.h),
                TextButton(
                  onPressed: () {
                    _betterPlayerController.retryDataSource();
                    setState(() {});
                  },
                  child: AutoSizeTexts.autoSizeText12('Tentar novamente', color: AppColors.white),
                )
              ],
            ),
          );
        },
        expandToFill: true,
        fit: BoxFit.cover,
        autoPlay: false,
      ),
      betterPlayerDataSource: _betterPlayerDataSource,
    );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _betterPlayerController.preCache(_betterPlayerDataSource);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AspectRatio(
        aspectRatio: _betterPlayerController.getAspectRatio() ?? 16 / 9,
        child: BetterPlayer(
          controller: _betterPlayerController,
        ),
      ),
    );
  }
}
