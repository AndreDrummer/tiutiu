import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/CustomDropDownButton.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import '../Widgets/CircleaddImage.dart';
import '../Widgets/InputText.dart';
import 'package:image_picker/image_picker.dart';
import '../backend/Controller/pet_controller.dart';

import 'package:tiutiu/data/dummy_data.dart';

class NovoPet extends StatefulWidget {
  @override
  _NovoPetState createState() => _NovoPetState();
}

class _NovoPetState extends State<NovoPet> {
  var params;
  var kind;

  File imageFile0;
  File imageFile1;
  File imageFile2;
  File imageFile3;

  Future<File> image0;
  Future<File> image1;
  Future<File> image2;
  Future<File> image3;

  TextEditingController _nome = TextEditingController();
  TextEditingController _idade = TextEditingController();
  TextEditingController _raca = TextEditingController();
  TextEditingController _descricao = TextEditingController();

  Map<String, File> petPhotos = {};
  Map<String, String> petPhotosToUpload = {};

  String dropvalueSize;
  String dropvalueHealth;
  String dropvalueBreed;

  @override
  void initState() {
    super.initState();
    dropvalueSize = DummyData.size[0];
    dropvalueBreed = DummyData.breed[0];
    dropvalueHealth = DummyData.health[0];
  }

  void selectImage(ImageSource source, int index) async {
    ImagePicker picker = new ImagePicker();
    dynamic image = await picker.getImage(source: source);
    switch (index) {
      case 0:
        setState(() {
          imageFile0 = File(image.path);
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile0);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile0);
          }
        });
        break;
      case 1:
        setState(() {
          imageFile1 = File(image.path);
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile1);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile1);
          }
        });
        break;
      case 2:
        setState(() {
          imageFile2 = File(image.path);
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile2);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile2);
          }
        });
        break;
      case 3:
        setState(() {
          imageFile3 = File(image.path);
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile3);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile3);
          }
        });
        break;
    }
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

  Future<void> uploadPhotos(String petName) async {
    StorageUploadTask uploadTask;
    StorageReference storageReference;

    for (String key in petPhotos.keys) {
      storageReference =
          FirebaseStorage.instance.ref().child('userID/foto__$petName--$key');
      uploadTask = storageReference.putFile(petPhotos['$key']);

      await uploadTask.onComplete;
      await storageReference.getDownloadURL().then((urlDownload) async {
        petPhotosToUpload["photo$key"] = await urlDownload;
        print("URL DOWNLOAD $urlDownload");
      });
    }

    return Future.value();
  }

  save() async {
    PetController petController = PetController();

    await uploadPhotos(_nome.text);

    Pet dataPetSave = Pet(
      name: _nome.text,
      breed: dropvalueBreed,
      health: dropvalueHealth,
      owner: 'André',
      photos: petPhotosToUpload,
      size: dropvalueSize,
      latitude: -16.7504593,
      longitude: -49.2593187,
      details: _descricao.text,
      age: 2,
      address: 'Vazio Ainda',
    );

    await petController.insertPet(dataPetSave, kind);
    petPhotosToUpload.clear();
  }

  @override
  Widget build(BuildContext context) {
    params = ModalRoute.of(context).settings.arguments;
    kind = params['kind'];
    print(kind);

    print(petPhotosToUpload);

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
                            InkWell(
                              onTap: () => openModalSelectMedia(context, 0),
                              child: CircleAddImage(
                                imageUrl: petPhotos['0'] != null
                                    ? petPhotos['0'].path
                                    : null,
                              ),
                            ),
                            InkWell(
                              onTap: () => openModalSelectMedia(context, 1),
                              child: CircleAddImage(
                                imageUrl: petPhotos['1'] != null
                                    ? petPhotos['1'].path
                                    : null,
                              ),
                            ),
                            InkWell(
                              onTap: () => openModalSelectMedia(context, 2),
                              child: CircleAddImage(
                                imageUrl: petPhotos['2'] != null
                                    ? petPhotos['2'].path
                                    : null,
                              ),
                            ),
                            InkWell(
                              onTap: () => openModalSelectMedia(context, 3),
                              child: CircleAddImage(
                                imageUrl: petPhotos['3'] != null
                                    ? petPhotos['3'].path
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        InputText(
                          placeholder: 'Nome',
                          controller: _nome,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: InputText(
                                placeholder: 'Idade',
                                controller: _idade,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: CustomDropdownButton(
                                label: 'Tamanho',
                                initialValue: dropvalueSize,
                                itemList: DummyData.size,
                                onChange: (String value) {
                                  setState(() {
                                    dropvalueSize = value;
                                    print(dropvalueSize);
                                  });
                                },
                                isExpanded: false,
                              ),
                            ),
                            Expanded(
                              child: CustomDropdownButton(
                                label: 'Saúde',
                                initialValue: dropvalueHealth,
                                itemList: DummyData.health,
                                onChange: (String value) {
                                  setState(() {
                                    dropvalueHealth = value;
                                    print(dropvalueHealth);
                                  });
                                },
                                isExpanded: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        CustomDropdownButton(
                          isExpanded: true,
                          label: 'Raça',
                          initialValue: dropvalueBreed,
                          itemList: DummyData.breed,
                          onChange: (String value) {
                            setState(() {
                              dropvalueBreed = value;
                              print(value);
                            });
                          },
                        ),
                        SizedBox(height: 12),
                        InputText(
                            placeholder: 'Descrição',
                            size: 150,
                            controller: _descricao,
                            multiline: true,
                            maxlines: 5),
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
                              onPressed: () {
                                save();
                              },
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
