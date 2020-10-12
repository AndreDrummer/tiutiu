import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/Widgets/custom_dropdown_button.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/selection_page.dart';
import 'package:tiutiu/utils/routes.dart';
import '../Widgets/circle_add_image.dart';
import '../Widgets/input_text.dart';
import 'package:image_picker/image_picker.dart';
import '../backend/Controller/pet_controller.dart';

import 'package:tiutiu/data/dummy_data.dart';

class PetForm extends StatefulWidget {
  PetForm({this.editMode = false, this.petReference});

  final bool editMode;
  final DocumentReference petReference;

  @override
  _PetFormState createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
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

  Map<String, dynamic> petPhotos = {};
  Map<String, String> petPhotosToUpload = {};
  List _selectedCaracteristics = [];
  List _otherCaracteristicsList = [
    'Vermifugado',
    'Castrado',
    'Dócil',
    'Prenhez',
    'Tranquilo',
    'Brincalhão',
    'Tímido',
    'Vacinado'
  ];

  bool macho = true;
  Authentication auth;
  UserProvider userProvider;
  String dropvalueSize;
  String dropvalueColor;
  int dropvalueType = 0;
  int dropvalueHealth = 0;
  int dropvalueBreed = 0;
  String userId;
  LatLng currentLocation;
  bool formIsValid = false;
  bool isLogging = false;
  bool readOnly = false;
  int numberOfImages = 3;

  Pet petEdit;

  void preloadTextFields() async {
    PetController petController = PetController();
    var pet = await petController.getPetByReference(widget.petReference);
    setState(() {
      petEdit = pet;
      _nome.text = pet.name;
      _ano.text = pet.ano.toString();
      _meses.text = pet.meses.toString();
      _descricao.text = pet.details;
      macho = pet.sex == 'Macho' ? true : false;
      _selectedCaracteristics = pet.otherCaracteristics;
      dropvalueType = DummyData.type.indexOf(pet.type);
      dropvalueBreed = DummyData.breed[dropvalueType + 1].indexOf(pet.breed);
      dropvalueSize = pet.size;
      dropvalueColor = pet.color;
      dropvalueHealth = DummyData.health.indexOf(pet.health);
      petPhotos = pet.photos;
      numberOfImages = 8;
    });
  }

  void clearUpCaracteristics() {
    setState(() {
      _selectedCaracteristics.clear();
    });
  }

  void changePetSex(bool value) {
    setState(() {
      macho = value;
    });
  }

  @override
  void initState() {
    if (widget.editMode) {
      preloadTextFields();
    } else {
      dropvalueSize = DummyData.size[0];
      dropvalueColor = DummyData.color[0];
    }
    super.initState();

    currentLocation = Provider.of<Location>(context, listen: false).location;
    userId =
        Provider.of<Authentication>(context, listen: false).firebaseUser.uid;
    print('Local $currentLocation');
  }

  @override
  void didChangeDependencies() {
    auth = Provider.of<Authentication>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  void selectImage(ImageSource source, int index) async {
    var picker = ImagePicker();
    dynamic image = await picker.getImage(source: source);
    switch (index) {
      case 0:
        image = File(image.path);
        setState(() {
          imageFile0 = image;
          if (petPhotos.containsKey('$index')) {
            petPhotos.remove('$index');
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
          if (petPhotos.containsKey('$index')) {
            petPhotos.remove('$index');
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
          if (petPhotos.containsKey('$index')) {
            petPhotos.remove('$index');
            petPhotos.putIfAbsent(index.toString(), () => imageFile2);
          } else {
            petPhotos.putIfAbsent(index.toString(), () => imageFile2);
          }
        });
        break;
      case 3:
        image = File(image.path);
        print('Foto $index ');
        setState(() {
          imageFile3 = image;
          if (petPhotos.containsKey('$index')) {
            petPhotos.remove('$index');
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
          if (petPhotos.containsKey('$index')) {
            petPhotos.remove('$index');
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
          if (petPhotos.containsKey('$index')) {
            petPhotos.remove('$index');
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
          if (petPhotos.containsKey('$index')) {
            petPhotos.remove('$index');
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
          if (petPhotos.containsKey('$index')) {
            petPhotos.remove('$index');
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
      storageReference = FirebaseStorage.instance
          .ref()
          .child('$userId/')
          .child('petsPhotos/$petName--foto__${DateTime.now().millisecond}');
      if (petPhotos['$key'].runtimeType != String) {
        uploadTask = storageReference.putFile(petPhotos['$key']);
        await uploadTask.onComplete;
        await storageReference.getDownloadURL().then((urlDownload) async {
          petPhotosToUpload['photo$key'] = await urlDownload;
          print('URL DOWNLOAD $urlDownload');
        });
      } else if (petPhotos['$key'].runtimeType == String) {
        petPhotosToUpload[key] = petPhotos[key];
      }
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
        type: DummyData.type[dropvalueType],
        color: dropvalueColor,
        name: _nome.text,
        kind: kind,
        avatar: petPhotosToUpload.values.first,
        breed: DummyData.breed[dropvalueType + 1][dropvalueBreed],
        health: DummyData.health[dropvalueHealth],
        ownerReference: userProvider.userReference,
        otherCaracteristics: _selectedCaracteristics,
        photos: petPhotosToUpload,
        size: dropvalueSize,
        sex: macho ? 'Macho' : 'Fêmea',
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
        details: _descricao.text,
        donated: false,
        found: false,
        ano: int.tryParse(_ano.text) ?? 0,
        meses: int.tryParse(_meses.text) ?? 0);

    !widget.editMode
        ? await petController.insertPet(dataPetSave, kind, auth)
        : await petController.updatePet(dataPetSave, userId, kind, petEdit.id);
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
    kind = widget.editMode ? petEdit?.kind : params['kind'];

    print(petPhotos);

    Future<bool> _onWillPopScope() {
      Navigator.pushReplacementNamed(context, Routes.HOME);
      petPhotos.clear();
      petPhotosToUpload.clear();
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        appBar: AppBar(
          title: widget.editMode
              ? Text('Editar dados do ${petEdit?.name}')
              : Text(
                  kind == 'Donate' ? 'PET para adoção' : 'PET Desaparecido',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
        ),
        body: Stack(
          children: <Widget>[
            Background(dark: true),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 0.8),
                            end: Alignment(0.0, 0.0),
                            colors: [
                              Color.fromRGBO(0, 0, 0, 0),
                              Color.fromRGBO(0, 0, 0, 0.6),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment(-1, 1),
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
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              height: 80.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: numberOfImages < 8
                                    ? numberOfImages + 1
                                    : numberOfImages,
                                itemBuilder: (ctx, index) {
                                  if (index == numberOfImages) {
                                    // print('Index: ${petPhotos}');
                                    return InkWell(
                                      onTap: petPhotos[
                                                      '${numberOfImages - 1}'] ==
                                                  null &&
                                              petPhotos[
                                                      'photo${numberOfImages - 1}'] ==
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
                                          : petPhotos['photo$index'] != null
                                              ? petPhotos['photo$index']
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
                            CustomDropdownButton(
                              label: 'Tipo',
                              initialValue: DummyData.type[dropvalueType],
                              itemList: DummyData.type,
                              onChange: (String value) {
                                setState(() {
                                  dropvalueType = DummyData.type.indexOf(value);
                                  dropvalueBreed = 0;
                                });
                              },
                              isExpanded: true,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            CustomDropdownButton(
                              label: 'Cor',
                              initialValue: dropvalueColor,
                              itemList: DummyData.color,
                              onChange: (String value) {
                                setState(() {
                                  dropvalueColor = value;
                                  print(dropvalueColor);
                                });
                              },
                              isExpanded: true,
                            ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              initialValue: DummyData.health[dropvalueHealth],
                              itemList: DummyData.health,
                              onChange: (String value) {
                                setState(() {
                                  dropvalueHealth =
                                      DummyData.health.indexOf(value);
                                  print(dropvalueHealth);
                                });
                              },
                              isExpanded: true,
                            ),
                            SizedBox(height: 12),
                            CustomDropdownButton(
                              isExpanded: true,
                              label: 'Raça',
                              initialValue: DummyData.breed[dropvalueType + 1]
                                  [dropvalueBreed],
                              itemList: DummyData.breed[dropvalueType + 1],
                              onChange: (String value) {
                                setState(() {
                                  dropvalueBreed = DummyData
                                      .breed[dropvalueType + 1]
                                      .indexOf(value);
                                });
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(top: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Colors.lightGreenAccent[200],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Sexo',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Checkbox(
                                    value: macho,
                                    onChanged: (value) {
                                      changePetSex(value);
                                    },
                                  ),
                                  Text(
                                    'Macho',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Checkbox(
                                    value: !macho,
                                    onChanged: (value) {
                                      changePetSex(!value);
                                    },
                                  ),
                                  Text(
                                    'Fêmea',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SelectionPage(
                                        onTap: (text) {
                                          setState(() {
                                            _selectedCaracteristics
                                                    .contains(text)
                                                ? _selectedCaracteristics
                                                    .remove(text)
                                                : _selectedCaracteristics
                                                    .add(text);
                                          });
                                        },
                                        title: 'Outras características',
                                        list: _otherCaracteristicsList,
                                        valueSelected: _selectedCaracteristics,
                                      );
                                    },
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    _selectedCaracteristics = value;
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      color: Colors.lightGreenAccent[200],
                                    ),
                                    borderRadius: BorderRadius.circular(12)),
                                margin: const EdgeInsets.only(top: 8.0),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Outras características',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Spacer(),
                                          _selectedCaracteristics.isNotEmpty
                                              ? Container(
                                                  height: 20,
                                                  width: 100,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          _selectedCaracteristics
                                                              .length,
                                                      itemBuilder: (_, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 2.0),
                                                          child: Badge(
                                                              text:
                                                                  _selectedCaracteristics[
                                                                      index]),
                                                        );
                                                      }),
                                                )
                                              : Container(),
                                          Spacer(),
                                          _selectedCaracteristics.isNotEmpty
                                              ? FlatButton(
                                                  child: Text('Limpar'),
                                                  onPressed: () =>
                                                      clearUpCaracteristics(),
                                                )
                                              : Icon(Icons.arrow_forward)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                ],
              ),
            ),
            LoadDarkScreen(show: isLogging, message: 'Aguarde'),
            Positioned(
              bottom: 0.0,
              child: ButtonWide(
                  rounded: false,
                  color:
                      isLogging ? Colors.grey : Theme.of(context).primaryColor,
                  isToExpand: true,
                  action: isLogging
                      ? null
                      : () async {
                          if (validateForm()) {
                            setReadOnly();
                            await save();
                            await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => PopUpMessage(
                                      title: 'Pronto',
                                      confirmText: 'Ok',
                                      confirmAction: () {
                                        Navigator.popUntil(
                                          context,
                                          ModalRoute.withName('/'),
                                        );
                                      },
                                      message: widget.editMode
                                          ? 'Os dados do PET foram atualizados'
                                          : 'PET postado com sucesso!',
                                    )).then(
                              (value) => _onWillPopScope,
                            );
                          } else {
                            setState(() {
                              formIsValid = true;
                            });
                          }
                        },
                  text: widget.editMode ? 'SALVAR ALTERAÇÕES' : 'POSTAR'),
            ),
          ],
        ),
      ),
    );
  }
}
