import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/Widgets/custom_dropdown_button.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/squared_add_image.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/pet_form_provider.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/selection_page.dart';
import 'package:tiutiu/utils/routes.dart';
import '../Widgets/input_text.dart';
import 'package:image_picker/image_picker.dart';
import '../backend/Controller/pet_controller.dart';
import 'package:tiutiu/data/dummy_data.dart';

class PetForm extends StatefulWidget {
  PetForm({
    this.editMode = false,
    this.petReference,
  });

  final bool editMode;
  final DocumentReference petReference;

  @override
  _PetFormState createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
  PetFormProvider petFormProvider;

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

  List<Asset> petPhotosMulti = List<Asset>();
  List petPhotosToUpload = [];

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
  bool isLogging = false;
  bool readOnly = false;
  int numberOfImages = 3;

  Pet petEdit;

  void preloadTextFields() async {
    PetController petController = PetController();
    var pet = await petController.getPetByReference(widget.petReference);

    petFormProvider.changePetName(pet.name);
    petFormProvider.changePetAge(pet.ano);
    petFormProvider.changePetMonths(pet.meses);
    petFormProvider.changePetDescription(pet.details);
    petFormProvider.changePetSex(pet.sex);
    petFormProvider.changePetSelectedCaracteristics(pet.otherCaracteristics);
    petFormProvider.changePetTypeIndex(DummyData.type.indexOf(pet.type));
    petFormProvider.changePetBreedIndex(
        DummyData.breed[dropvalueType + 1].indexOf(pet.breed));
    petFormProvider.changePetSize(pet.size);
    petFormProvider.changePetColor(pet.color);
    petFormProvider.changePetHealthIndex(DummyData.health.indexOf(pet.health));
    petFormProvider.changePetPhotos(pet.photos);

    _nome.text = petFormProvider.getPetName;
    _descricao.text = petFormProvider.getPetDescription;

    setState(() {
      petEdit = pet;
      numberOfImages = 8;
    });
  }

  void clearUpCaracteristics() {
    petFormProvider.changePetSelectedCaracteristics([]);
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

    currentLocation = Provider.of<Location>(context, listen: false).getLocation;
    userId =
        Provider.of<Authentication>(context, listen: false).firebaseUser.uid;
    print('Local $currentLocation');
  }

  @override
  void didChangeDependencies() {
    auth = Provider.of<Authentication>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    petFormProvider = Provider.of<PetFormProvider>(context);
    super.didChangeDependencies();
  }

  void selectImage(ImageSource source, int index) async {
    var picker = ImagePicker();
    PickedFile image = await picker.getImage(source: source);
    List actualPhotoList = [...petFormProvider.getPetPhotos];

    actualPhotoList.add(File(image.path));
    petFormProvider.changePetPhotos(actualPhotoList);
  }

  void openModalSelectMedia(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: petFormProvider.getPetPhotos.isNotEmpty &&
                  petFormProvider.getPetPhotos.length > index &&
                  petFormProvider.getPetPhotos[index] != null
              ? [
                  FlatButton(
                    child: Text('Remover'),
                    onPressed: () {
                      Navigator.pop(context);
                      List actualPhotoList = petFormProvider.getPetPhotos;
                      actualPhotoList.removeAt(index);
                      petFormProvider.changePetPhotos(actualPhotoList);
                    },
                  )
                ]
              : [
                  FlatButton(
                    child: Text('Tirar uma foto',
                        style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.pop(context);
                      selectImage(ImageSource.camera, index);
                    },
                  ),
                  FlatButton(
                    child: Text('Abrir galeria'),
                    onPressed: () async {
                      if (await checkAndRequestCameraPermissions()) {
                        multiImages();
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
        );
      },
    );
  }

  Future<bool> checkAndRequestCameraPermissions() async {
    PermissionStatus galleryPermissionStatus =
        await Permission.photos.request();

    if (galleryPermissionStatus == PermissionStatus.undetermined ||
        galleryPermissionStatus == PermissionStatus.denied) {
      galleryPermissionStatus = await Permission.photos.request();
    } else if (galleryPermissionStatus == PermissionStatus.permanentlyDenied) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopUpMessage(
            confirmAction: openAppSettings,
            confirmText: 'Abrir configurações',
            denyAction: () {
              Navigator.pop(context);
            },
            denyText: 'Não',
            warning: true,
            message:
                'Para conseguir inserir fotos do PET você precisa conceder acesso a sua galeria.',
            title: 'Acesso negado!',
          );
        },
      );
    } else {
      return true;
    }

    return false;
  }

  Future<void> multiImages() async {
    List<Asset> resultList = List<Asset>();
    List actualPhotoList = [...petFormProvider.getPetPhotos];    

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 8 - actualPhotoList.length,
        // enableCamera: true,
        selectedAssets: petPhotosMulti,
        materialOptions: MaterialOptions(
          actionBarColor: "#4CAF50",
          actionBarTitle: "Selecione fotos do PET",
          allViewTitle: "Todas as fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    if (!mounted) return;

    if (resultList.isNotEmpty) {
      actualPhotoList.addAll(resultList);
      petFormProvider.changePetPhotos(actualPhotoList);
      setState(() {
        petPhotosMulti = actualPhotoList;
      });
    }
  }

  Future<Uint8List> convertImageToUint8List(image) async {
      print('RUNTIME ${image.runtimeType}');
    if (image.runtimeType == Asset) {
      ByteData byteData = await image.getByteData();
      return Uint8List.view(byteData.buffer);
    } else {
      return await File(image.path).readAsBytes();
    }    
  }

  Future<void> uploadPhotos(String petName) async {
    StorageUploadTask uploadTask;
    StorageReference storageReference;

    List imagesPet = petFormProvider.getPetPhotos;

    for (int i = 0; i < imagesPet.length; i++) {
      storageReference = FirebaseStorage.instance
          .ref()
          .child('$userId/')
          .child('petsPhotos/$petName--foto__${DateTime.now().millisecond}');
      if (imagesPet[i].runtimeType != String) {        
        uploadTask = storageReference.putData(await convertImageToUint8List(imagesPet[i]));
        await uploadTask.onComplete;
        await storageReference.getDownloadURL().then((urlDownload) async {
          petPhotosToUpload.add(urlDownload);
          print('URL DOWNLOAD $urlDownload');
        });
      } else if (imagesPet[i].runtimeType == String) {
        petPhotosToUpload.add(imagesPet[i]);
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
      type: DummyData.type[petFormProvider.getPetTypeIndex],
      color: petFormProvider.getPetColor,
      name: petFormProvider.getPetName,
      kind: kind,
      avatar: petPhotosToUpload.first,
      breed: DummyData.breed[petFormProvider.getPetTypeIndex + 1]
          [petFormProvider.getPetBreedIndex],
      health: DummyData.health[petFormProvider.getPetHealthIndex],
      ownerReference: userProvider.userReference,
      otherCaracteristics: petFormProvider.getPetSelectedCaracteristics,
      photos: petPhotosToUpload,
      size: petFormProvider.getPetSize,
      sex: petFormProvider.getPetSex,
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
      details: petFormProvider.getPetDescription,
      donated: false,
      found: false,
      ano: petFormProvider.getPetAge,
      meses: petFormProvider.getPetMonths,
    );

    !widget.editMode
        ? await petController.insertPet(dataPetSave, kind, auth)
        : await petController.updatePet(dataPetSave, userId, kind, petEdit.id);

    petPhotosToUpload.clear();
    petFormProvider.dispose();
    changeLogginStatus(false);
    return Future.value();
  }

  bool validateForm() {
    return kind == 'donate'
        ? _nome.text.isNotEmpty &&
            _ano.text.isNotEmpty &&
            _meses.text.isNotEmpty &&
            _descricao.text.isNotEmpty &&
            petFormProvider.getPetPhotos.isNotEmpty
        : _nome.text.isNotEmpty &&
            _descricao.text.isNotEmpty &&
            petFormProvider.getPetPhotos.isNotEmpty;
  }

  void setReadOnly() {
    setState(() {
      readOnly = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    params = ModalRoute.of(context).settings.arguments;
    kind = widget.editMode ? petEdit?.kind : params['kind'];

    print(petFormProvider.getPetPhotos);

    Future<bool> _onWillPopScope() {
      Navigator.pushReplacementNamed(context, Routes.HOME);
      petFormProvider.getPetPhotos.clear();
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
                                    ? '${petFormProvider.getPetPhotos.isEmpty ? 'Insira pelo menos uma foto' : 'Insira algumas fotos do seu bichinho.'}'
                                    : '${petFormProvider.getPetPhotos.isEmpty ? 'Insira pelo menos uma foto' : 'Insira fotos dele.'}',
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: petFormProvider.petPhotos,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                Container(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        petFormProvider.getPetPhotos.length + 1,
                                    itemBuilder: (ctx, index) {
                                      if (index ==
                                          petFormProvider.getPetPhotos.length) {
                                        return petFormProvider
                                                    .getPetPhotos.length <
                                                8
                                            ? InkWell(
                                                onTap: () async {
                                                  openModalSelectMedia(
                                                      context, index);
                                                },
                                                child: SquaredAddImage(
                                                  width: petFormProvider
                                                          .getPetPhotos.isEmpty
                                                      ? null
                                                      : 120,
                                                ),
                                              )
                                            : Container();
                                      }
                                      return InkWell(
                                        onTap: () async {
                                          openModalSelectMedia(context, index);
                                        },
                                        child: SquaredAddImage(
                                          width: petFormProvider
                                                  .getPetPhotos.isEmpty
                                              ? null
                                              : 235,
                                          imageUrl: petFormProvider
                                                      .getPetPhotos[index] !=
                                                  null
                                              ? petFormProvider
                                                  .getPetPhotos[index]
                                              : petFormProvider.getPetPhotos[
                                                          index] !=
                                                      null
                                                  ? petFormProvider
                                                      .getPetPhotos[index]
                                                  : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        petFormProvider.formIsvalid() && snapshot.data.isEmpty
                                    ? HintError(
                                        message: '* Insira pelo menos uma foto')
                                    : SizedBox(),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 12),
                        StreamBuilder<String>(
                          stream: petFormProvider.petName,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                InputText(
                                  placeholder: 'Nome',
                                  onChanged: petFormProvider.changePetName,
                                  controller: _nome,
                                  readOnly: readOnly,
                                ),
                        petFormProvider.formIsvalid() && snapshot.data.isEmpty
                                    ? HintError()
                                    : SizedBox(),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        StreamBuilder<int>(
                          stream: petFormProvider.petTypeIndex,
                          builder: (context, snapshot) {
                            return CustomDropdownButton(
                              label: 'Tipo',
                              initialValue: DummyData.type[snapshot.data],
                              itemList: DummyData.type,
                              onChange: (String value) {
                                petFormProvider.changePetTypeIndex(
                                    DummyData.type.indexOf(value));
                                petFormProvider.changePetBreedIndex(0);
                              },
                              isExpanded: true,
                            );
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        StreamBuilder<String>(
                          stream: petFormProvider.petColor,
                          builder: (context, snapshot) {
                            return CustomDropdownButton(
                              label: 'Cor',
                              initialValue: snapshot.data,
                              itemList: DummyData.color,
                              onChange: petFormProvider.changePetColor,
                              isExpanded: true,
                            );
                          },
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
                              child: StreamBuilder<int>(
                                stream: petFormProvider.petAge,
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      InputText(
                                        placeholder: 'Anos',
                                        keyBoardTypeNumber: true,
                                        onChanged: (value) {
                                          petFormProvider
                                              .changePetAge(int.parse(value));
                                        },
                                        controller: _ano,
                                        readOnly: readOnly,
                                      ),
                              petFormProvider.formIsvalid() &&
                                              kind == 'Donate' &&
                                              snapshot.data == null
                                          ? HintError()
                                          : SizedBox(),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: StreamBuilder<int>(
                                stream: petFormProvider.petMonths,
                                builder: (context, snapshot) {
                                  return Column(
                                    children: [
                                      InputText(
                                        placeholder: 'Meses',
                                        keyBoardTypeNumber: true,
                                        onChanged: (value) {
                                          petFormProvider.changePetMonths(
                                              int.parse(value));
                                        },
                                        controller: _meses,
                                        readOnly: readOnly,
                                      ),
                              petFormProvider.formIsvalid() &&
                                              kind == 'Donate' &&
                                              snapshot.data == null
                                          ? HintError()
                                          : SizedBox(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        StreamBuilder<String>(
                          stream: petFormProvider.petSize,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {}                            
                            return CustomDropdownButton(
                              label: 'Tamanho',
                              initialValue: snapshot.data,
                              itemList: DummyData.size,
                              onChange: petFormProvider.changePetSize,
                              isExpanded: true,
                            );
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        StreamBuilder<int>(
                          stream: petFormProvider.petHealthIndex,
                          builder: (context, snapshot) {
                            return CustomDropdownButton(
                              label: 'Saúde',
                              initialValue: DummyData.health[snapshot.data],
                              itemList: DummyData.health,
                              onChange: (String value) {
                                petFormProvider.changePetHealthIndex(
                                    DummyData.health.indexOf(value));
                              },
                              isExpanded: true,
                            );
                          },
                        ),
                        SizedBox(height: 12),
                        StreamBuilder<int>(
                          stream: petFormProvider.petBreedIndex,
                          builder: (context, snapshot) {
                            return CustomDropdownButton(
                              isExpanded: true,
                              label: 'Raça',
                              initialValue: DummyData.breed[
                                      petFormProvider.getPetTypeIndex + 1]
                                  [petFormProvider.getPetBreedIndex],
                              itemList: DummyData
                                  .breed[petFormProvider.getPetTypeIndex + 1],
                              onChange: (String value) {
                                petFormProvider.changePetBreedIndex(DummyData
                                    .breed[petFormProvider.getPetTypeIndex + 1]
                                    .indexOf(value));
                              },
                            );
                          },
                        ),
                        StreamBuilder<String>(
                            stream: petFormProvider.petSex,
                            builder: (context, snapshot) {
                              return Container(
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
                                      value: snapshot.data == 'Macho',
                                      onChanged: (value) {
                                        petFormProvider.changePetSex('Macho');
                                      },
                                    ),
                                    Text(
                                      'Macho',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Checkbox(
                                      value: snapshot.data == 'Fêmea',
                                      onChanged: (value) {
                                        petFormProvider.changePetSex('Fêmea');
                                      },
                                    ),
                                    Text(
                                      'Fêmea',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        StreamBuilder<List>(
                          stream: petFormProvider.petSelectedCaracteristics,
                          builder: (context, snapshot) {
                            List list = [];
                            if (snapshot.data != null && snapshot.hasData) {
                              list = snapshot.data;
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SelectionPage(
                                        onTap: (text) {
                                          List newList = list;
                                          newList.contains(text)
                                              ? newList.remove(text)
                                              : newList.add(text);
                                          petFormProvider
                                              .changePetSelectedCaracteristics(
                                                  newList);
                                        },
                                        title: 'Outras características',
                                        list: DummyData.otherCaracteristicsList,
                                        valueSelected: petFormProvider
                                            .getPetSelectedCaracteristics,
                                      );
                                    },
                                  ),
                                ).then(
                                  (value) {
                                    if (value != null) {
                                      petFormProvider
                                          .changePetSelectedCaracteristics(
                                              value);
                                    }
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    style: BorderStyle.solid,
                                    color: Colors.lightGreenAccent[200],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                                          list.isNotEmpty
                                              ? Container(
                                                  height: 20,
                                                  width: 100,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: list.length,
                                                    itemBuilder: (_, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 2.0),
                                                        child: Badge(
                                                          text: list[index],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container(),
                                          Spacer(),
                                          list.isNotEmpty
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
                            );
                          },
                        ),
                        SizedBox(height: 12),
                        StreamBuilder<String>(
                          stream: petFormProvider.petDescription,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                InputText(
                                  placeholder: 'Descrição',
                                  readOnly: readOnly,
                                  size: 150,
                                  onChanged:
                                      petFormProvider.changePetDescription,
                                  controller: _descricao,
                                  multiline: true,
                                  maxlines: 5,
                                ),
                        petFormProvider.formIsvalid() && _descricao.text.isEmpty
                                    ? HintError()
                                    : SizedBox(),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            LoadDarkScreen(show: isLogging, message: 'Aguarde'),
          ],
        ),
        bottomNavigationBar: ButtonWide(
          rounded: false,
          color: isLogging ? Colors.grey : Theme.of(context).primaryColor,
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
                  }
                },
          text: widget.editMode ? 'SALVAR ALTERAÇÕES' : 'POSTAR',
        ),
      ),
    );
  }
}
