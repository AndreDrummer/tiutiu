import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/custom_dropdown_button.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/utils/routes.dart';
import '../Widgets/circle_add_image.dart';
import '../Widgets/input_text.dart';
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
  File imageFile4;
  File imageFile5;
  File imageFile6;
  File imageFile7;

  final TextEditingController _nome = TextEditingController();
  final TextEditingController _ano = TextEditingController();
  final TextEditingController _meses = TextEditingController();
  final TextEditingController _descricao = TextEditingController();

  Map<String, File> petPhotos = {};
  Map<String, String> petPhotosToUpload = {};

  String dropvalueSize;
  String dropvalueHealth;
  String dropvalueBreed;
  String userId;
  LatLng currentLocation;

  bool formIsValid = false;
  bool isLogging = false;
  bool readOnly = false;

  int numberOfImages = 3;

  @override
  void initState() {
    super.initState();
    dropvalueSize = DummyData.size[0];
    dropvalueBreed = DummyData.breed[0];
    dropvalueHealth = DummyData.health[0];

    currentLocation = Provider.of<Location>(context, listen: false).location;
    userId = Provider.of<Authentication>(context, listen: false).firebaseUser.uid;
    print('Local $currentLocation');
  }

  void selectImage(ImageSource source, int index) async {
    var picker = ImagePicker();
    dynamic image = await picker.getImage(source: source);
    switch (index) {
      case 0:
        image = File(image.path);
        setState(() {
          imageFile0 = image;
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile0);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile0);
          }
        });
        break;
      case 1:
        image = File(image.path);
        setState(() {
          imageFile1 = image;
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile1);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile1);
          }
        });
        break;
      case 2:
        image = File(image.path);
        setState(() {
          imageFile2 = image;
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile2);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile2);
          }
        });
        break;
      case 3:
        image = File(image.path);
        setState(() {
          imageFile3 = image;
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile3);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile3);
          }
        });
        break;
      case 4:
        image = File(image.path);
        setState(() {
          imageFile4 = image;
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile4);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile4);
          }
        });
        break;
      case 5:
        image = File(image.path);
        setState(() {
          imageFile5 = image;
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile5);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile5);
          }
        });
        break;
      case 6:
        image = File(image.path);
        setState(() {
          imageFile6 = image;
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile6);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile6);
          }
        });
        break;
      case 7:
        image = File(image.path);
        setState(() {
          imageFile7 = image;
          if (petPhotos.containsKey(index)) {
            petPhotos.remove(index);
            petPhotos.putIfAbsent(index.toString(), () => imageFile7);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile7);
          }
        });
        break;
    }
  }

  void openModalSelectMedia(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            FlatButton(
              child:
                  Text('Tirar uma foto', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.pop(context);
                selectImage(ImageSource.camera, index);
              },
            ),
            FlatButton(
              child: Text('Abrir galeria'),
              onPressed: () {
                Navigator.pop(context);
                selectImage(ImageSource.gallery, index);
              },
            )
          ],
        );
      },
    );
  }

  Future<void> uploadPhotos(String petName) async {
    StorageUploadTask uploadTask;
    StorageReference storageReference;

    for (var key in petPhotos.keys) {
      storageReference =
          FirebaseStorage.instance.ref().child('$userId/$petName--foto__$key');
      uploadTask = storageReference.putFile(petPhotos['$key']);

      await uploadTask.onComplete;
      await storageReference.getDownloadURL().then((urlDownload) async {
        petPhotosToUpload['photo$key'] = await urlDownload;
        print('URL DOWNLOAD $urlDownload');
      });
    }

    return Future.value();
  }

  void changeLogginStatus(bool status) {
    setState(() {
      isLogging = status;
    });
  }

  Future<void> save() async {
    changeLogginStatus(true);
    var petController = PetController();

    await uploadPhotos(_nome.text);

    var dataPetSave = Pet(
      name: _nome.text,
      breed: dropvalueBreed,
      health: dropvalueHealth,
      owner: userId,
      photos: petPhotosToUpload,
      size: dropvalueSize,
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
      details: _descricao.text,
      ano: int.tryParse(_ano.text) ?? 0,
      meses: int.tryParse(_meses.text) ?? 0,
      address: 'Vazio Ainda',
    );

    await petController.insertPet(dataPetSave, kind);
    petPhotosToUpload.clear();
    changeLogginStatus(false);
    return Future.value();
  }

  bool validateForm() {
    return kind == 'donate'
        ? _nome.text.isNotEmpty &&
            _ano.text.isNotEmpty &&
            _meses.text.isNotEmpty &&
            _descricao.text.isNotEmpty &&
            petPhotos.isNotEmpty
        : _nome.text.isNotEmpty &&
            _descricao.text.isNotEmpty &&
            petPhotos.isNotEmpty;
  }

  void setReadOnly() {
    setState(() {
      readOnly = true;
    });
  }

  void incNumberOfImages() {
    setState(() {
      numberOfImages++;
    });
  }

  @override
  Widget build(BuildContext context) {
    params = ModalRoute.of(context).settings.arguments;
    kind = params['kind'];
    print(kind);

    // final avalaibleHeight = MediaQuery.of(context).size.height -
    //     MediaQuery.of(context).padding.top -
    //     14;

    // final width = MediaQuery.of(context).size.width;

    Future<bool> _onWillPopScope() {
      Navigator.pushReplacementNamed(context, Routes.HOME);
      petPhotos.clear();
      petPhotosToUpload.clear();
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    'assets/gato2.jpg',
                  ),
                ),
              ),
              child: Center(
                child: Card(
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(16.0),
                  // ),
                  // color: Colors.transparent,
                  color: Color(0XFFD6D6D6), //Theme.of(context).accentColor,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 26.0, bottom: 10),
                          child: Align(
                            alignment: Alignment(-0.8, 1),
                            child: FittedBox(
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                      child: Icon(Icons.arrow_back, size: 25),
                                      onTap: _onWillPopScope),
                                  SizedBox(width: 10),
                                  Text(
                                    kind == 'Donate'
                                        ? 'Coloque um PET para adoção'
                                        : 'Poste um PET Desaparecido',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Align(
                                alignment: Alignment(-0.8, 1),
                                child: FittedBox(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        kind == 'Donate'
                                            ? '${formIsValid && petPhotos.isEmpty ? 'Insira pelo menos uma foto' : 'Insira algumas fotos do seu bichinho.'}'
                                            : '${formIsValid && petPhotos.isEmpty ? 'Insira pelo menos uma foto' : 'Insira fotos dele.'}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 80.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: numberOfImages < 8
                                      ? numberOfImages + 1
                                      : numberOfImages,
                                  itemBuilder: (ctx, index) {
                                    if (index == numberOfImages) {
                                      print('Index: $index');
                                      print('Number: $numberOfImages');
                                      return InkWell(
                                        onTap: petPhotos[
                                                    '${numberOfImages - 1}'] ==
                                                null
                                            ? null
                                            : () {
                                                incNumberOfImages();
                                              },
                                        child: CircleAddImage(
                                          addButton: true,
                                        ),
                                      );
                                    }
                                    return InkWell(
                                      onTap: () {
                                        print('Foto index: $index');
                                        openModalSelectMedia(context, index);
                                      },
                                      child: CircleAddImage(
                                        // ignore: prefer_if_null_operators
                                        imageUrl: petPhotos['$index'] != null
                                            ? petPhotos['$index']
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              formIsValid && petPhotos.isEmpty
                                  ? HintError(
                                      message: '* Insira pelo menos uma foto')
                                  : SizedBox(),
                              SizedBox(height: 12),
                              InputText(
                                  placeholder: 'Nome',
                                  controller: _nome,
                                  readOnly: readOnly),
                              formIsValid && _nome.text.isEmpty
                                  ? HintError()
                                  : SizedBox(),
                              SizedBox(
                                height: 12,
                              ),
                              Align(
                                alignment: Alignment(-0.95, 1),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'Idade',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: InputText(
                                      placeholder: 'Anos',
                                      keyBoardTypeNumber: true,
                                      controller: _ano,
                                      readOnly: readOnly,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: InputText(
                                      placeholder: 'Meses',
                                      keyBoardTypeNumber: true,
                                      controller: _meses,
                                      readOnly: readOnly,
                                    ),
                                  ),
                                ],
                              ),
                              formIsValid &&
                                      kind == 'Donate' &&
                                      (_ano.text.isEmpty || _meses.text.isEmpty)
                                  ? HintError()
                                  : SizedBox(),
                              SizedBox(
                                height: 12,
                              ),
                              CustomDropdownButton(
                                label: 'Tamanho',
                                initialValue: dropvalueSize,
                                itemList: DummyData.size,
                                onChange: (String value) {
                                  setState(() {
                                    dropvalueSize = value;
                                    print(dropvalueSize);
                                  });
                                },
                                isExpanded: true,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              CustomDropdownButton(
                                label: 'Saúde',
                                initialValue: dropvalueHealth,
                                itemList: DummyData.health,
                                onChange: (String value) {
                                  setState(() {
                                    dropvalueHealth = value;
                                    print(dropvalueHealth);
                                  });
                                },
                                isExpanded: true,
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
                                readOnly: readOnly,
                                size: 150,
                                controller: _descricao,
                                multiline: true,
                                maxlines: 5,
                              ),
                              formIsValid && _descricao.text.isEmpty
                                  ? HintError()
                                  : SizedBox(),
                              SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            isLogging
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Aguarde',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 25,
                                fontWeight: FontWeight.w600)),
                        SizedBox(
                          height: 20,
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                  )
                : SizedBox(),
            Positioned(
              bottom: 0.0,
              child: ButtonWide(
                  rounded: false,
                  isToExpand: true,
                  action: () async {
                    if (validateForm()) {
                      setReadOnly();
                      await save();
                      await showDialog(
                          context: context,
                          builder: (context) => PopUpMessage(
                                title: 'Pronto',
                                message: 'PET postado com sucesso!',
                              )).then(
                        (value) => _onWillPopScope,
                      );
                    } else {
                      setState(() {
                        formIsValid = true;
                      });
                    }
                  },
                  text: 'POSTAR'),
            ),
          ],
        ),
      ),
    );
  }
}
