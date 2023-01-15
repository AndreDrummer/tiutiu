import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  Background({this.image});

  final image;

  @override
  Widget build(BuildContext context) {
    final urlImage = image == null ? ImageAssets.bones2 : image;
    return Container(
      child: Opacity(
        opacity: image != null ? 0.3 : 0.03,
        child: AssetHandle.getImage(urlImage, fit: BoxFit.contain),
      ),
    );
  }
}
