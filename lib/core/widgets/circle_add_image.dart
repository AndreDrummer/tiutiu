import 'package:flutter/material.dart';
import 'dart:io';

import 'package:tiutiu/core/constants/app_colors.dart';

// ignore: must_be_immutable
class CircleAddImage extends StatefulWidget {
  CircleAddImage({
    this.imageUrl,
    this.addButton = false,
  });

  var imageUrl;
  final bool addButton;

  @override
  _CircleAddImageState createState() => _CircleAddImageState();
}

class _CircleAddImageState extends State<CircleAddImage> {
  bool isLocalImage = true;

  void checkImageUrl() {
    if (widget.imageUrl != null) {
      setState(() {
        isLocalImage = widget.imageUrl.runtimeType == File;
      });
    }
  }

  @override
  void initState() {
    checkImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: CircleAvatar(
        backgroundColor: widget.addButton ? Colors.black26 : AppColors.white,
        radius: 40,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              style: BorderStyle.solid,
              color: Colors.lightGreenAccent[200]!,
            ),
          ),
          child: Center(
            child: ClipOval(
              child: widget.addButton
                  ? Icon(Icons.add, size: 50, color: AppColors.white)
                  : widget.imageUrl != null
                      ? widget.imageUrl.runtimeType != String
                          ? Image.file(
                              widget.imageUrl,
                              fit: BoxFit.fill,
                              width: 100,
                              height: 100,
                            )
                          : Image.network(
                              widget.imageUrl,
                              fit: BoxFit.fill,
                              width: 100,
                              height: 100,
                            )
                      : Icon(
                          Icons.add_photo_alternate,
                          size: 50,
                          color: Colors.grey,
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
