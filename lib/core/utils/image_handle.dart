import 'package:cached_network_image/cached_network_image.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AssetHandle {
  const AssetHandle(this._imagePath);

  final _imagePath;

  ImageProvider build() {
    if (_imagePath.toString().contains('http')) {
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
    bool isUserImage = false,
    BoxFit? fit,
  }) {
    if (imagePath == null || imagePath.toString().isEmpty) {
      return Image.asset(
        isUserImage ? ImageAssets.profileEmpty : ImageAssets.profileEmpty,
        fit: BoxFit.fill,
      );
    } else if (imagePath.toString().contains('http')) {
      return _networkImage(imagePath, fit: fit, isUserImage: isUserImage);
    } else {
      return _localImage(imagePath);
    }
  }

  static Widget _networkImage(
    dynamic imagePath, {
    bool isUserImage = false,
    BoxFit? fit,
  }) {
    return CachedNetworkImage(
      errorWidget: (context, url, error) => Icon(Icons.error),
      placeholder: (_, __) => Center(
        child: Opacity(
          opacity: .5,
          child: Image.asset(
            isUserImage ? ImageAssets.profileEmpty : ImageAssets.newLogo,
            fit: BoxFit.cover,
          ),
        ),
      ),
      fit: fit ?? BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      imageUrl: imagePath,
    );
  }
}

Widget _localImage(image) => Image.file(
      image,
      fit: BoxFit.fill,
      height: double.infinity,
      width: double.infinity,
    );
