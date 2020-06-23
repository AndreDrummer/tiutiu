import 'dart:io';

import 'package:flutter/material.dart';
import '../Widgets/CircleaddImage.dart';
import '../Widgets/InputText.dart';
import 'package:image_picker/image_picker.dart';

class NovoPet extends StatefulWidget {
  @override
  _NovoPetState createState() => _NovoPetState();
}

class _NovoPetState extends State<NovoPet> {
  var params;
  var kind;

  Future<PickedFile> image0;
  Future<PickedFile> image1;
  Future<PickedFile> image2;
  Future<PickedFile> image3;

  PickedFile imageFile0;
  PickedFile imageFile1;
  PickedFile imageFile2;
  PickedFile imageFile3;

  List<String> petPhotosToUpload = [];

  @override
  void initState() {
    super.initState();
  }

  void selectImage(ImageSource source, int index) {
    ImagePicker picker = new ImagePicker();
    dynamic image = picker.getImage(source: source);
    switch (index) {
      case 0:
        setState(() {
          image0 = image;
        });
        break;
      case 1:
        setState(() {
          image1 = image;
        });
        break;
      case 2:
        setState(() {
          image2 = image;
        });
        break;
      case 3:
        setState(() {
          image3 = image;
        });
        break;
    }
  }

  Widget setImage(
    PickedFile imageFile, Future<PickedFile> imageFuture, int index) {
    String path ;
    return FutureBuilder<PickedFile>(
      future: imageFuture,
      builder: (BuildContext context, AsyncSnapshot<PickedFile> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          path = snapshot.data.path;
          petPhotosToUpload.add(path);
          imageFuture.then((value) {
            imageFile = value;
          });
        }
        return InkWell(
          onTap: () => openModalSelectMedia(context, index),
          child: CircleAddImage(
            imageUrl: path,
          ),
        );
      },
    );
  }

  openModalSelectMedia(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              FlatButton(
                child: Text("Tirar uma foto",
                    style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera, index);
                },
              ),
              FlatButton(
                child: Text("Abrir galeria"),
                onPressed: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery, index);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    params = ModalRoute.of(context).settings.arguments;
    kind = params['kind'];
    print(kind);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              'assets/gato2.jpg',
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Colors.transparent,
              // color: Color(0XFFD6D6D6), //Theme.of(context).accentColor,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            kind == 'Donate'
                                ? 'Poste um PET para adoção'
                                : 'Poste um PET Desaparecido',
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            setImage(imageFile0, image0, 0),
                            setImage(imageFile1, image1, 1),
                            setImage(imageFile2, image2, 2),
                            setImage(imageFile3, image3, 3),
                          ],
                        ),
                        SizedBox(height: 12),
                        InputText(
                          placeholder: 'Nome',
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              width: 100,
                              child: InputText(
                                placeholder: 'Idade',
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: InputText(
                                placeholder: 'Raça',
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: InputText(
                                placeholder: 'Tamanho',
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: InputText(
                                placeholder: 'Cor',
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: InputText(
                                placeholder: 'Saúde',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        InputText(placeholder: 'Descrição', size: 150),
                        // SizedBox(height: 120),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                'CANCELAR',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              child: Text(
                                'POSTAR',
                                style: Theme.of(context).textTheme.button,
                              ),
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
