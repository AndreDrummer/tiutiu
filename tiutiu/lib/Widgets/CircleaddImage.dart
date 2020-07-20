import 'dart:io';

import 'package:flutter/material.dart';

class CircleAddImage extends StatefulWidget {
  var imageUrl;
  CircleAddImage({this.imageUrl});

  @override
  _CircleAddImageState createState() => _CircleAddImageState();
}

class _CircleAddImageState extends State<CircleAddImage> {
  bool isLocalImage = true;

  void checkImageUrl() {
    if (widget.imageUrl != null) {
      widget.imageUrl = widget.imageUrl;
      isLocalImage = widget.imageUrl is File;
    }
  }

  @override
  void initState() {
    super.initState();
    checkImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 40,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
          ),        
          child: Center(
            child: ClipOval(
              child: widget.imageUrl != null
                  ? isLocalImage
                      ? Image.file(widget.imageUrl, fit: BoxFit.fill, width: 100, height: 100,)
                      : Image.network(widget.imageUrl, fit: BoxFit.fill, width: 100, height: 100,)
                  : Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
