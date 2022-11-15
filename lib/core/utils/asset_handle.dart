import 'package:tiutiu/core/widgets/loading_image_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AssetHandle {
  const AssetHandle(this._imagePath);

  final _imagePath;

  ImageProvider build() {
    if (_imagePath.isUrl()) {
      return NetworkImage(_imagePath);
    } else if (_imagePath is File) {
      return FileImage(_imagePath);
    } else if (_imagePath is String) {
      return AssetHandle(_imagePath).build();
    }

    return AssetHandle(ImageAssets.profileEmpty).build();
  }

  static ImageProvider placeholder() {
    return AssetHandle(
      ImageAssets.profileEmpty,
    ).build();
  }

  static Widget getImage(
    dynamic imagePath, {
    BorderRadius? borderRadius,
    bool isUserImage = false,
    Object? hero,
    BoxFit? fit,
  }) {
    if (imagePath == null || imagePath.toString().isEmpty) {
      return FadeInImage(
        image: AssetImage(ImageAssets.profileEmpty),
        placeholder: AssetImage(
          isUserImage ? ImageAssets.profileEmpty : ImageAssets.profileEmpty,
        ),
        fit: fit ?? BoxFit.fill,
        width: 1000,
      );
    } else if (imagePath.toString().isUrl()) {
      return _networkImage(isUserImage: isUserImage, hero: hero, imagePath, fit: fit, borderRadius: borderRadius);
    } else if (imagePath.toString().isAsset()) {
      return _imageAsset(imagePath, fit: fit);
    } else {
      return _localImage(imagePath, fit);
    }
  }

  static Widget _imageAsset(
    String path, {
    BoxFit? fit,
  }) {
    return Image.asset(
      path,
      fit: fit ?? BoxFit.fill,
      width: 1000,
    );
  }

  static Widget _networkImage(
    dynamic imagePath, {
    BorderRadius? borderRadius,
    bool isUserImage = false,
    BoxFit? fit,
    Object? hero,
  }) {
    return Hero(
      tag: hero ?? imagePath,
      child: CachedNetworkImage(
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (_, __) => Center(
          child: LoadingImageAnimation(
            imagePath: isUserImage ? ImageAssets.profileEmpty : ImageAssets.newLogo,
          ),
        ),
        fit: fit ?? BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        imageUrl: imagePath,
      ),
    );
  }
}

Widget _localImage(image, BoxFit? fit) {
  return Image.file(
    image is String ? File(image) : image,
    height: double.infinity,
    fit: fit ?? BoxFit.fill,
    width: double.infinity,
  );
}
