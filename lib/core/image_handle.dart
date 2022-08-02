import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AssetHandle {
  const AssetHandle(this._imagePath);

  final _imagePath;

  ImageProvider build() {
    if (_imagePath.toString().contains('http')) {
      return NetworkImage(_imagePath);
    } else if (_imagePath is File) {
      return FileImage(_imagePath);
    } else if (_imagePath is String) {
      return AssetImage(_imagePath);
    }

    return AssetImage('assets/profileEmpty.png');
  }

  static ImageProvider placeholder() {
    return AssetImage(
      'assets/profileEmpty.png',
    );
  }

  static Widget getImage(
    dynamic imagePath, {
    bool isUserImage = false,
    BoxFit? fit,
  }) {
    if (imagePath == null || imagePath.toString().isEmpty) {
      return Image.asset(
        isUserImage ? 'assets/profileEmpty.png' : 'assets/profileEmpty.png',
        fit: BoxFit.fill,
      );
    } else if (imagePath.toString().contains('http')) {
      return _networkImage(imagePath, fit: fit);
    } else {
      return _localImage(imagePath);
    }
  }

  static Widget _networkImage(dynamic imagePath, {BoxFit? fit}) {
    return CachedNetworkImage(
      errorWidget: (context, url, error) => Icon(Icons.error),
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(),
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
