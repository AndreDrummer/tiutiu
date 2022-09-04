import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SquaredAddImage extends StatefulWidget {
  SquaredAddImage({
    this.addButton = false,
    this.imageUrl,
    this.width,
  });

  final bool? addButton;
  final double? width;
  final imageUrl;

  @override
  _SquaredAddImageState createState() => _SquaredAddImageState();
}

class _SquaredAddImageState extends State<SquaredAddImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.lightGreenAccent[200]!,
          style: BorderStyle.solid,
        ),
        color: Colors.white,
      ),
      height: 200,
      width: widget.width != null
          ? widget.width
          : MediaQuery.of(context).size.width - 49,
      child: Center(
        child: widget.addButton!
            ? Icon(Icons.add, size: 50, color: Colors.white)
            : widget.imageUrl != null
                ? widget.imageUrl.runtimeType != String &&
                        widget.imageUrl.runtimeType != String //Asset
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          widget.imageUrl,
                          fit: BoxFit.fill,
                          width: widget.width != null
                              ? widget.width
                              : (MediaQuery.of(context).size.width - 32),
                          height: 300,
                        ),
                      )
                    : widget.imageUrl.runtimeType != String &&
                            widget.imageUrl.runtimeType == String //Asset
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Center()
                            // AssetThumb(
                            //   asset: widget.imageUrl,
                            //   height: 300,
                            //   width: 370,
                            // ),
                            )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.fill,
                              width: widget.width != null
                                  ? widget.width
                                  : (MediaQuery.of(context).size.width - 32),
                              height: 300,
                            ),
                          )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_rounded,
                        color: Colors.blue,
                        size: 40,
                      ),
                      AutoSizeText(
                        'Adicionar fotos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
