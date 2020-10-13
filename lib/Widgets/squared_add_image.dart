import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SquaredAddImage extends StatefulWidget {
  SquaredAddImage({
    this.width,
    this.imageUrl,
    this.addButton = false,
  });

  final imageUrl;
  final double width;
  final bool addButton;

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
          color: Colors.lightGreenAccent[200],
          style: BorderStyle.solid,
        ),
        color: Colors.white,
      ),
      height: 200,
      width: widget.width != null
          ? widget.width
          : MediaQuery.of(context).size.width - 49,
      child: Center(
        child: widget.addButton
            ? Icon(Icons.add, size: 50, color: Colors.white)
            : widget.imageUrl != null
                ? widget.imageUrl.runtimeType != String &&
                        widget.imageUrl.runtimeType != Asset
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
                            widget.imageUrl.runtimeType == Asset
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AssetThumb(
                              asset: widget.imageUrl,
                              height: 300,
                              width: 370,
                            ),
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
                      Text(
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
