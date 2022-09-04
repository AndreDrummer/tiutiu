import 'package:loading_animations/loading_animations.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  FullScreenImage({
    this.images,
    this.tag,
  });

  final List? images;
  final String? tag;

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
            key: UniqueKey(),
            physics: zoom ? const NeverScrollableScrollPhysics() : null,
            scrollDirection: Axis.horizontal,
            itemCount: widget.images!.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 1.2,
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    loadingBuilder: (context, Widget child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText('Carregando imagem..'),
                            LoadingJumpingLine.circle(),
                          ],
                        ),
                      );
                    },
                    image: AssetHandle(widget.images![index]).build(),
                    fit: BoxFit.fill,
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
