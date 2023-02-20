import 'package:tiutiu/core/widgets/loading_image_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AssetHandle {
  static ImageProvider imageProvider(dynamic imagePath) {
    if (imagePath.toString().isUrl()) {
      return NetworkImage(imagePath);
    } else if (imagePath is File) {
      return FileImage(imagePath);
    } else if (imagePath is String) {
      return AssetImage(imagePath);
    }

    return placeholder();
  }

  static ImageProvider placeholder({bool isUserImage = false}) {
    return AssetImage(isUserImage ? ImageAssets.profileEmpty : ImageAssets.newLogo);
  }

  static Widget getImage(
    dynamic imagePath, {
    BorderRadius? borderRadius,
    bool isUserImage = false,
    Object? hero,
    Color? color,
    BoxFit? fit,
  }) {
    if (imagePath == null || imagePath.toString().isEmpty) {
      return FadeInImage(
        placeholder: AssetImage(isUserImage ? ImageAssets.profileEmpty : ImageAssets.newLogo),
        image: AssetImage(isUserImage ? ImageAssets.profileEmpty : ImageAssets.newLogo),
        fit: fit ?? BoxFit.fill,
        width: 1000,
      );
    } else if (imagePath.toString().isUrl()) {
      return _networkImage(
        borderRadius: borderRadius,
        isUserImage: isUserImage,
        color: color,
        hero: hero,
        imagePath,
        fit: fit,
      );
    } else if (imagePath.toString().isAsset()) {
      return _imageAsset(imagePath, fit: fit, color: color);
    } else {
      return _localImage(imagePath, fit, color: color);
    }
  }

  static Widget _imageAsset(
    String path, {
    BoxFit? fit,
    Color? color,
  }) {
    return Image.asset(
      path,
      fit: fit ?? BoxFit.fill,
      color: color,
      width: 1000,
    );
  }

  static Widget _networkImage(
    dynamic imagePath, {
    BorderRadius? borderRadius,
    bool isUserImage = false,
    BoxFit? fit,
    Color? color,
    Object? hero,
  }) {
    return Hero(
      tag: hero ?? imagePath,
      child: CachedNetworkImage(
        color: color,
        errorWidget: (context, url, error) => _imageAsset(ImageAssets.profileEmpty),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (_, __) => Container(
          alignment: Alignment.center,
          color: AppColors.black.withAlpha(100),
          child: isUserImage
              ? LoadingImageAnimation(imagePath: ImageAssets.profileEmpty)
              : LottieAnimation(animationPath: AnimationsAssets.pawLoading),
        ),
        fit: fit ?? BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        imageUrl: imagePath,
      ),
    );
  }
}

Widget _localImage(image, BoxFit? fit, {Color? color}) {
  return Image.file(
    image is String ? File(image) : image,
    height: double.infinity,
    fit: fit ?? BoxFit.fill,
    color: color,
    width: double.infinity,
  );
}
