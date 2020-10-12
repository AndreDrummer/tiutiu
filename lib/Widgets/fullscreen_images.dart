import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class FullScreenImage extends StatefulWidget {
  FullScreenImage({
    this.images,
    this.tag
  });

  final List images;
  final String tag;

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  bool zoom = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0XFF000000),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.2,
          child: ListView.builder(
            physics: zoom ? const NeverScrollableScrollPhysics() : null,
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 1.2,
                  width: MediaQuery.of(context).size.width,
                  child: ZoomableWidget(
                    maxScale: 7.0,
                    minScale: 0.5,
                    autoCenter: true,
                    initialScale: 1.0,
                    child: Hero(
                      tag: widget.tag ?? '$index',
                      child: Image(
                        image: AdvancedNetworkImage(widget.images[index]),
                        fit: BoxFit.fill,
                      ),
                    ),
                    onZoomChanged: (double value) {                      
                      if (value >= 1.01) {
                        setState(() {
                          zoom = true;
                        });
                      } else {
                        setState(() {
                          zoom = false;
                        });
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
