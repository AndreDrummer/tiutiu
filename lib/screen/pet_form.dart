import 'package:tiutiu/core/Exceptions/tiutiu_exceptions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiutiu/Widgets/custom_dropdown_button.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiutiu/Widgets/squared_add_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/screen/selection_page.dart';
import 'package:tiutiu/utils/other_functions.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:flutter/material.dart';
import '../Widgets/input_text.dart';
import 'dart:typed_data';
import 'dart:math';
import 'dart:io';

class PetForm extends StatefulWidget {
  PetForm({this.editMode = false, this.pet, this.localChanged = false});

  final bool? localChanged;
  final bool? editMode;
  final Pet? pet;

  @override
  _PetFormState createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
  var params;
  var kind;

  File? imageFile0;
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  File? imageFile4;
  File? imageFile5;
  File? imageFile6;
  File? imageFile7;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _descricao = TextEditingController();
  final TextEditingController _meses = TextEditingController();
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _ano = TextEditingController();

  List<Uint8List> convertedImageList = [];
  List<String> photosToDelete = [];
  List petPhotosToUpload = [];
  List petPhotosMulti = [];

  int maxImages = 6;

  bool? macho = true;
  String? dropvalueSize;
  String? dropvalueColor;
  int? dropvalueType = 0;
  int? dropvalueHealth = 0;
  int? dropvalueBreed = 0;
  String? userId;
  LatLng? currentLocation;
  bool? isSaving;
  bool? readOnly = false;
  bool? convertingImages;
  bool? photosFieldIsValid = true;
  // AdsProvider adsProvider;
  String? storageHashKey;

  void preloadTextFields() {
    petFormController.petTypeIndex = DummyData.type.indexOf(widget.pet!.type!);
    petFormController.petPhotos = widget.pet?.photos ?? [widget.pet!.avatar];
    petPhotosToUpload.addAll(widget.pet?.photos ?? [widget.pet!.avatar]);
    petFormController.petDescription = widget.pet!.details!;
    _meses.text = petFormController.petMonths.toString();
    _descricao.text = petFormController.petDescription;
    petFormController.petMonths = widget.pet!.ageMonth!;
    petFormController.petColor = widget.pet!.color!;
    _ano.text = petFormController.petAge.toString();
    petFormController.petName = widget.pet!.name!;
    petFormController.petSize = widget.pet!.size!;
    storageHashKey = widget.pet!.storageHashKey;
    petFormController.petAge = widget.pet!.ageYear!;
    petFormController.petSex = widget.pet!.gender!;
    petFormController.petSelectedCaracteristics =
        widget.pet!.otherCaracteristics!;
    petFormController.petInEdition = widget.pet!;
    _nome.text = petFormController.petName;
    petFormController.petBreedIndex = DummyData
        .breed[petFormController.petTypeIndex + 1]
        .indexOf(widget.pet!.breed!);
    petFormController.petHealthIndex =
        DummyData.health.indexOf(widget.pet!.health!);
  }

  void clearUpCaracteristics() {
    petFormController.petSelectedCaracteristics = [];
  }

  @override
  void initState() {
    userId = authController.firebaseUser!.uid;

    dropvalueSize = DummyData.size[0];
    dropvalueColor = DummyData.color[0];

    if (!widget.editMode!) {
      storageHashKey = generateStorageHashKey();
      if (!widget.localChanged!) {
        // currentLocation =
        //     Provider.of<Location>(context, listen: false).getLocation;
      } else {
        currentLocation = LatLng(widget.pet!.latitude!, widget.pet!.longitude!);
      }
    } else {
      // currentLocation =
      //     Provider.of<Location>(context, listen: false).getLocation;
    }

    convertingImages = false;
    isSaving = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // adsProvider = Provider.of(context)

    if (widget.editMode!) {
      preloadTextFields();
    }
    super.didChangeDependencies();
  }

  void selectImage(ImageSource source, int index) async {
    var picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    List actualPhotoList = [...petFormController.petPhotos];

    actualPhotoList.add(File(image!.path));
    petFormController.petPhotos = actualPhotoList;
    convertImageToUint8List(petFormController.petPhotos);
    photosFieldStatus();
  }

  String firstCharacterUpper(String text) {
    List arrayPieces = [];

    String outPut = '';

    text.split(' ').forEach((sepparetedWord) {
      arrayPieces.add(sepparetedWord);
    });

    arrayPieces.forEach((word) {
      word =
          "${word[0].toString().toUpperCase()}${word.toString().substring(1)} ";
      outPut += word;
    });

    return outPut.trim();
  }

  void openModalSelectMedia(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: petFormController.petPhotos.isNotEmpty &&
                  petFormController.petPhotos.length > index &&
                  petFormController.petPhotos[index] != null
              ? [
                  TextButton(
                    child: Text('Remover'),
                    onPressed: () {
                      Navigator.pop(context);
                      if (widget.editMode!) {
                        photosToDelete
                            .add(petFormController.petPhotos.elementAt(index));
                      }

                      petFormController.petPhotos.removeAt(index);

                      if (widget.editMode!) {
                        petPhotosToUpload.clear();
                        petPhotosToUpload.addAll(petFormController.petPhotos);
                      }

                      List actualPhotoList = petFormController.petPhotos;
                      petFormController.petPhotos = actualPhotoList;

                      if (!widget.editMode!) {
                        convertImageToUint8List(petFormController.petPhotos);
                      }
                      photosFieldStatus();
                    },
                  )
                ]
              : [
                  TextButton(
                    child: Text(
                      'Tirar uma foto',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      selectImage(ImageSource.camera, index);
                    },
                  ),
                  TextButton(
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

    if (galleryPermissionStatus == PermissionStatus.restricted ||
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
    List resultList = [];
    List actualPhotoList = petFormController.petPhotos;

    try {
      resultList = [];
      // await MultiImagePicker.pickImages(
      //   maxImages: maxImages - actualPhotoList.length,
      //   selectedAssets: petPhotosMulti,
      //   materialOptions: MaterialOptions(
      //     actionBarColor: "#4CAF50",
      //     actionBarTitle: "Selecione fotos do PET",
      //     allViewTitle: "Todas as fotos",
      //     useDetailsView: false,
      //     selectCircleStrokeColor: "#000000",
      //   ),
      // );
    } on Exception catch (e) {
      print(e.toString());
    }
    if (!mounted) return;

    if (resultList.isNotEmpty) {
      actualPhotoList.addAll(resultList);
      petFormController.petPhotos = actualPhotoList;
      convertImageToUint8List(petFormController.petPhotos);
      photosFieldStatus();
      setState(() {
        petPhotosMulti = actualPhotoList;
      });
    }
  }

  Future<void> convertImageToUint8List(List images) async {
    convertedImageList.clear();
    changeConvertingImagesStatus(true);
    print('Convertendo imagens...');
    for (int i = 0; i < images.length; i++) {
      if (images[i].runtimeType == String) continue;
      if (images[i].runtimeType == int /*Asset*/) {
        ByteData byteData = await images[i].getByteData();
        convertedImageList.add(Uint8List.view(byteData.buffer));
      } else {
        convertedImageList.add(await File(images[i].path).readAsBytes());
      }
    }
    changeConvertingImagesStatus(false);
    print('Conversão finalizada...');
  }

  String generateStorageHashKey() {
    Random random = Random();
    int min = 1, max = 1000;
    int randNumber = min + random.nextInt(max - min);
    int hash = randNumber * DateTime.now().millisecond;
    return '$hash.$userId.$randNumber';
  }

  Future<void> uploadPhotos(String petName) async {
    UploadTask uploadTask;
    Reference storageReference;

    for (int i = 0; i < convertedImageList.length; i++) {
      storageReference = FirebaseStorage.instance.ref().child('$userId/').child(
          'petsPhotos/$kind/$storageHashKey/$petName-${DateTime.now().millisecondsSinceEpoch}');
      uploadTask = storageReference.putData(convertedImageList[i]);
      await uploadTask.whenComplete(() {
        petPhotosToUpload.add(storageReference.getDownloadURL());
        print('URL DOWNLOAD ${petPhotosToUpload.last}');
      });
    }

    return Future.value();
  }

  void changeSavingStatus(bool status) {
    setState(() {
      isSaving = status;
    });
  }

  void changeConvertingImagesStatus(bool status) {
    setState(() {
      convertingImages = status;
    });
  }

  Future<void> deleteField(DocumentReference docRef) async {
    await docRef.update({'photos': FieldValue.delete()});
    print("photos Deleted");
  }

  Future<void> deletePhotosFromStorage() async {
    Reference storageReference;
    try {
      for (String photo in photosToDelete) {
        String filename =
            OtherFunctions.getPhotoName(photo, widget.pet!.storageHashKey!);
        storageReference = FirebaseStorage.instance
            .ref()
            .child('$userId/')
            .child('petsPhotos/$kind/$storageHashKey/$filename');
        await storageReference.delete();
      }
    } catch (error) {
      // throw TiuTiuException('INVALID_PATH');
    }
  }

  Future<void> save() async {
    final startIn = DateTime.now();
    changeSavingStatus(true);

    await uploadPhotos(_nome.text.trim());

    if (photosToDelete.isNotEmpty) {
      try {
        await deletePhotosFromStorage();
      } on TiuTiuException catch (error) {
        await showDialog(
          context: context,
          builder: (context) => PopUpMessage(
            title: 'Falha na autenticação',
            confirmText: 'OK',
            confirmAction: () => Navigator.pop(context),
            error: true,
            message: error.toString(),
          ),
        );
      }
    }

    final finishin = DateTime.now();
    print('DEMOROU ${finishin.difference(startIn).inSeconds}');
    return Future.value();
  }

  void afterSave() {
    petFormController.petSelectedCaracteristics = [];
    petFormController.petSize = 'Pequeno-porte';
    petFormController.petColor = 'Abóbora';
    petFormController.petInEdition = Pet();
    petFormController.petDescription = '';
    petFormController.petHealthIndex = 0;
    petFormController.petBreedIndex = 0;
    petFormController.petTypeIndex = 0;
    petFormController.petSex = 'Macho';
    petFormController.petPhotos = [];
    petFormController.petMonths = 0;
    petFormController.petName = '';
    petFormController.petAge = 0;
    convertedImageList.clear();
    petPhotosToUpload.clear();
    changeSavingStatus(false);
    petPhotosMulti.clear();
  }

  bool validateForm() {
    photosFieldStatus();
    bool result = petFormController.formIsvalid() && photosFieldIsValid!;
    return result;
  }

  void photosFieldStatus() {
    setState(() {
      photosFieldIsValid = petFormController.petPhotos.isNotEmpty;
    });
  }

  void setReadOnly() {
    setState(() {
      readOnly = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    params = ModalRoute.of(context)!.settings.arguments;
    kind = widget.editMode! ? widget.pet!.kind : params['kind'];
    petFormController.petKind = kind;

    Future<bool> _onWillPopScope() {
      if (isSaving! || convertingImages!) {
        return Future.value(false);
      }
      Navigator.pushReplacementNamed(context, Routes.home);
      petFormController.petPhotos.clear();
      petPhotosToUpload.clear();
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: widget.editMode!
              ? Text('Editar dados do ${widget.pet!.name}')
              : Text(
                  kind == FirebaseEnvPath.donate
                      ? 'PET PARA ADOÇÃO'
                      : 'PET DESAPARECIDO',
                  style: Theme.of(context).textTheme.headline1!.copyWith(
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
                                kind == FirebaseEnvPath.donate
                                    ? '${petFormController.petPhotos.isEmpty ? 'Insira pelo menos uma foto' : 'Insira algumas fotos do seu bichinho.'}'
                                    : '${petFormController.petPhotos.isEmpty ? 'Insira pelo menos uma foto' : 'Insira fotos dele.'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
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
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 200,
                              child: ListView.builder(
                                key: UniqueKey(),
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    petFormController.petPhotos.length + 1,
                                itemBuilder: (ctx, index) {
                                  if (index ==
                                      petFormController.petPhotos.length) {
                                    return petFormController.petPhotos.length <
                                            maxImages
                                        ? InkWell(
                                            onTap: () async {
                                              openModalSelectMedia(
                                                  context, index);
                                            },
                                            child: SquaredAddImage(
                                              width: 120,
                                            ),
                                          )
                                        : Container();
                                  }
                                  return InkWell(
                                    onTap: () async {
                                      openModalSelectMedia(context, index);
                                    },
                                    child: SquaredAddImage(
                                      width: 235,
                                      imageUrl: petFormController
                                                  .petPhotos[index] !=
                                              null
                                          ? petFormController.petPhotos[index]
                                          : petFormController
                                                      .petPhotos[index] !=
                                                  null
                                              ? petFormController
                                                  .petPhotos[index]
                                              : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                            !photosFieldIsValid!
                                ? HintError(
                                    message: '* Insira pelo menos uma foto')
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(height: 12),
                        InputText(
                          placeholder: 'Nome',
                          onChanged: (value) {
                            petFormController.petName = value;
                          },
                          readOnly: readOnly!,
                          controller: _nome,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CustomDropdownButton(
                          label: 'Tipo',
                          initialValue:
                              DummyData.type[petFormController.petTypeIndex],
                          itemList: DummyData.type,
                          onChange: (String value) {
                            petFormController.petTypeIndex =
                                DummyData.type.indexOf(value);
                            petFormController.petBreedIndex = 0;
                          },
                          isExpanded: true,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CustomDropdownButton(
                          label: 'Cor',
                          initialValue: petFormController.petColor,
                          itemList: DummyData.color,
                          onChange: (value) {
                            petFormController.petColor = value;
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
                                onChanged: (value) {
                                  petFormController.petAge = int.parse(value);
                                },
                                controller: _ano,
                                readOnly: readOnly!,
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: InputText(
                                placeholder: 'Meses',
                                keyBoardTypeNumber: true,
                                onChanged: (value) {
                                  petFormController.petMonths =
                                      int.parse(value);
                                },
                                controller: _meses,
                                readOnly: readOnly!,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CustomDropdownButton(
                          label: 'Tamanho',
                          initialValue: petFormController.petSize,
                          itemList: DummyData.size,
                          onChange: (value) {
                            petFormController.petSize = value;
                          },
                          isExpanded: true,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CustomDropdownButton(
                          label: 'Saúde',
                          initialValue: DummyData
                              .health[petFormController.petHealthIndex],
                          itemList: DummyData.health,
                          onChange: (String value) {
                            petFormController.petHealthIndex =
                                DummyData.health.indexOf(value);
                          },
                          isExpanded: true,
                        ),
                        SizedBox(height: 12),
                        CustomDropdownButton(
                          isExpanded: true,
                          label: 'Raça',
                          initialValue: DummyData
                                  .breed[petFormController.petTypeIndex + 1]
                              [petFormController.petBreedIndex],
                          itemList: DummyData
                              .breed[petFormController.petTypeIndex + 1],
                          onChange: (String value) {
                            petFormController.petBreedIndex = DummyData
                                .breed[petFormController.petTypeIndex + 1]
                                .indexOf(value);
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              style: BorderStyle.solid,
                              color: Colors.lightGreenAccent[200]!,
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
                                value: petFormController.petSex == 'Macho',
                                onChanged: (value) {
                                  petFormController.petSex = 'Macho';
                                },
                              ),
                              Text(
                                'Macho',
                                style: TextStyle(fontSize: 18),
                              ),
                              Checkbox(
                                value: petFormController.petSex == 'Fêmea',
                                onChanged: (value) {
                                  petFormController.petSex = 'Fêmea';
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
                                      List newList = petFormController
                                          .petSelectedCaracteristics;
                                      newList.contains(text)
                                          ? newList.remove(text)
                                          : newList.add(text);
                                      petFormController
                                          .petSelectedCaracteristics = newList;
                                    },
                                    title: 'Outras características',
                                    list: DummyData.otherCaracteristicsList,
                                    valueSelected: petFormController
                                        .petSelectedCaracteristics,
                                  );
                                },
                              ),
                            ).then(
                              (value) {
                                if (value != null) {
                                  petFormController.petSelectedCaracteristics =
                                      value;
                                }
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: Colors.lightGreenAccent[200]!,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(top: 8.0),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Características',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Spacer(),
                                      petFormController
                                              .petSelectedCaracteristics
                                              .isNotEmpty
                                          ? Container(
                                              height: 20,
                                              width: 140,
                                              child: ListView.builder(
                                                key: UniqueKey(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: petFormController
                                                    .petSelectedCaracteristics
                                                    .length,
                                                itemBuilder: (_, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 2.0),
                                                    child: Badge(
                                                      text: petFormController
                                                              .petSelectedCaracteristics[
                                                          index],
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(),
                                      Spacer(),
                                      petFormController
                                              .petSelectedCaracteristics
                                              .isNotEmpty
                                          ? InkWell(
                                              onTap: () =>
                                                  clearUpCaracteristics(),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        style:
                                                            BorderStyle.solid),
                                                    shape: BoxShape.circle),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Icon(Icons.clear),
                                                ),
                                              ),
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
                        Stack(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: InputText(
                                    placeholder: 'Descrição',
                                    readOnly: readOnly!,
                                    size: 150,
                                    onChanged: (value) {
                                      petFormController.petDescription = value;
                                    },
                                    controller: _descricao,
                                    multiline: true,
                                    maxlines: 5,
                                  ),
                                ),
                                // adsProvider.getCanShowAds
                                // ? adsProvider.bannerAdMob(
                                // adId: adsProvider.bottomAdId)
                                // : Container(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            LoadDarkScreen(show: isSaving!, message: 'Aguarde'),
          ],
        ),
        bottomNavigationBar: ButtonWide(
          rounded: false,
          color: isSaving! ? Colors.grey : Theme.of(context).primaryColor,
          isToExpand: true,
          action: isSaving! || convertingImages!
              ? null
              : () async {
                  if (validateForm()) {
                    setReadOnly();
                    await save();
                    afterSave();
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
                              message: widget.editMode!
                                  ? 'Os dados do PET foram atualizados.'
                                  : 'PET postado com sucesso!',
                            )).then(
                      (value) => _onWillPopScope,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Verifique se há erros no formulário!',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
          text: widget.editMode! ? 'SALVAR ALTERAÇÕES' : 'POSTAR',
        ),
      ),
    );
  }
}
