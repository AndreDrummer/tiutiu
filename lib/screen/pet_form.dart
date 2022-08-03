import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Exceptions/tiutiu_exceptions.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/Widgets/custom_dropdown_button.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/squared_add_image.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/pet_form_provider.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/selection_page.dart';
import 'package:tiutiu/utils/other_functions.dart';
import 'package:tiutiu/utils/routes.dart';
import '../Widgets/input_text.dart';
import 'package:image_picker/image_picker.dart';
import '../backend/Controller/pet_controller.dart';
import 'package:tiutiu/data/dummy_data.dart';

class PetForm extends StatefulWidget {
  PetForm({this.editMode = false, this.pet, this.localChanged = false});

  final bool editMode;
  final bool localChanged;
  final Pet pet;

  @override
  _PetFormState createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
  PetFormProvider petFormProvider;
  PetsProvider petsProvider;

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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Asset> petPhotosMulti = List<Asset>();
  List petPhotosToUpload = [];
  List<String> photosToDelete = [];
  List<Uint8List> convertedImageList = [];

  int maxImages = 6;

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
  bool isSaving;
  bool readOnly = false;
  bool convertingImages;
  bool photosFieldIsValid = true;
  AdsProvider adsProvider;
  String storageHashKey;

  void preloadTextFields() {
    petFormProvider.changePetName(widget.pet.name);
    petFormProvider.changePetAge(widget.pet.ano);
    petFormProvider.changePetMonths(widget.pet.meses);
    petFormProvider.changePetDescription(widget.pet.details);
    petFormProvider.changePetSex(widget.pet.sex);
    petFormProvider
        .changePetSelectedCaracteristics(widget.pet.otherCaracteristics);
    petFormProvider.changePetTypeIndex(DummyData.type.indexOf(widget.pet.type));
    petFormProvider.changePetBreedIndex(DummyData
        .breed[petFormProvider.getPetTypeIndex + 1]
        .indexOf(widget.pet.breed));
    petFormProvider.changePetSize(widget.pet.size);
    petFormProvider.changePetColor(widget.pet.color);
    petFormProvider
        .changePetHealthIndex(DummyData.health.indexOf(widget.pet.health));
    petFormProvider.changePetPhotos(widget.pet?.photos ?? [widget.pet.avatar]);
    petFormProvider.changePetInEdition(widget.pet);

    _nome.text = petFormProvider.getPetName;
    _ano.text = petFormProvider.getPetAge.toString();
    _meses.text = petFormProvider.getPetMonths.toString();
    _descricao.text = petFormProvider.getPetDescription;
    petPhotosToUpload.addAll(widget.pet?.photos ?? [widget.pet.avatar]);
    storageHashKey = widget.pet.storageHashKey;
  }

  void clearUpCaracteristics() {
    petFormProvider.changePetSelectedCaracteristics([]);
  }

  @override
  void initState() {
    userId =
        Provider.of<Authentication>(context, listen: false).firebaseUser.uid;

    dropvalueSize = DummyData.size[0];
    dropvalueColor = DummyData.color[0];

    if (!widget.editMode) {
      storageHashKey = generateStorageHashKey();
      if (!widget.localChanged) {
        currentLocation =
            Provider.of<Location>(context, listen: false).getLocation;
      } else {
        currentLocation = LatLng(widget.pet.latitude, widget.pet.longitude);
      }
    } else {
      currentLocation =
          Provider.of<Location>(context, listen: false).getLocation;
    }

    convertingImages = false;
    isSaving = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    adsProvider = Provider.of(context);
    auth = Provider.of<Authentication>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    petFormProvider = Provider.of<PetFormProvider>(context);
    petsProvider = Provider.of(context, listen: false);

    if (widget.editMode) {
      preloadTextFields();
    }
    super.didChangeDependencies();
  }

  void selectImage(ImageSource source, int index) async {
    var picker = ImagePicker();
    PickedFile image = await picker.getImage(source: source);
    List actualPhotoList = [...petFormProvider.getPetPhotos];

    actualPhotoList.add(File(image.path));
    petFormProvider.changePetPhotos(actualPhotoList);
    convertImageToUint8List(petFormProvider.getPetPhotos);
    changePhotosFieldStatus();
  }

  String firstCharacterUpper(String text) {
    List arrayPieces = List();

    String outPut = '';

    text.split(' ').forEach((sepparetedWord) {
      arrayPieces.add(sepparetedWord);
    });

    arrayPieces.forEach((word) {
      word =
          "${word[0].toString().toUpperCase()}${word.toString().substring(1)} ";
      outPut += word;
    });

    return outPut?.trim();
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
                      if (widget.editMode) {
                        photosToDelete
                            .add(petFormProvider.getPetPhotos.elementAt(index));
                      }

                      petFormProvider.getPetPhotos.removeAt(index);

                      if (widget.editMode) {
                        petPhotosToUpload.clear();
                        petPhotosToUpload.addAll(petFormProvider.getPetPhotos);
                      }

                      List actualPhotoList = petFormProvider.getPetPhotos;
                      petFormProvider.changePetPhotos(actualPhotoList);

                      if (!widget.editMode) {
                        convertImageToUint8List(petFormProvider.getPetPhotos);
                      }
                      changePhotosFieldStatus();
                    },
                  )
                ]
              : [
                  FlatButton(
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
    List actualPhotoList = petFormProvider.getPetPhotos;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxImages - actualPhotoList.length,
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
      convertImageToUint8List(petFormProvider.getPetPhotos);
      changePhotosFieldStatus();
      setState(() {
        petPhotosMulti = actualPhotoList as List<Asset>;
      });
    }
  }

  Future<void> convertImageToUint8List(List images) async {
    convertedImageList.clear();
    changeConvertingImagesStatus(true);
    print('Convertendo imagens...');
    for (int i = 0; i < images.length; i++) {
      if (images[i].runtimeType == String) continue;
      if (images[i].runtimeType == Asset) {
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
    StorageUploadTask uploadTask;
    StorageReference storageReference;

    for (int i = 0; i < convertedImageList.length; i++) {
      storageReference = FirebaseStorage.instance.ref().child('$userId/').child(
          'petsPhotos/$kind/$storageHashKey/$petName-${DateTime.now().millisecondsSinceEpoch}');
      uploadTask = storageReference.putData(convertedImageList[i]);
      await uploadTask.onComplete;
      petPhotosToUpload.add(await storageReference.getDownloadURL());
      print('URL DOWNLOAD ${petPhotosToUpload.last}');
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
    StorageReference storageReference;
    try {
      await deleteField(widget.pet.petReference);
      for (String photo in photosToDelete) {
        String filename =
            OtherFunctions.getPhotoName(photo, widget.pet.storageHashKey);
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
    var petController = PetController();

    await uploadPhotos(_nome.text?.trim());

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

    var dataPetSave = Pet(
      type: DummyData.type[petFormProvider.getPetTypeIndex],
      color: petFormProvider.getPetColor,
      name: firstCharacterUpper(petFormProvider.getPetName),
      kind: kind,
      createdAt: DateTime.now().toIso8601String(),
      views: 0,
      petReference: widget?.pet?.petReference ?? null,
      avatar: petPhotosToUpload.isNotEmpty
          ? petPhotosToUpload.first
          : petFormProvider.getPetPhotos.first,
      breed: DummyData.breed[petFormProvider.getPetTypeIndex + 1]
          [petFormProvider.getPetBreedIndex],
      health: DummyData.health[petFormProvider.getPetHealthIndex],
      ownerReference: userProvider.userReference,
      otherCaracteristics: petFormProvider.getPetSelectedCaracteristics,
      photos: petPhotosToUpload,
      size: petFormProvider.getPetSize,
      sex: petFormProvider.getPetSex,
      ownerId: userProvider.uid,
      ownerName: userProvider.displayName,
      latitude: currentLocation?.latitude ?? 0,
      longitude: currentLocation?.longitude ?? 0,
      details: petFormProvider.getPetDescription,
      donated: false,
      found: false,
      ano: petFormProvider.getPetAge,
      meses: petFormProvider.getPetMonths,
      storageHashKey: storageHashKey,
    );

    !widget.editMode
        ? await petController.insertPet(dataPetSave, kind, auth)
        : await petController.updatePet(dataPetSave, widget.pet.petReference);

    final finishin = DateTime.now();
    print('DEMOROU ${finishin.difference(startIn).inSeconds}');
    return Future.value();
  }

  void afterSave() {
    convertedImageList.clear();
    petPhotosMulti.clear();
    petPhotosToUpload.clear();
    petFormProvider.changePetPhotos([]);
    petFormProvider.changePetName('');
    petFormProvider.changePetColor('Abóbora');
    petFormProvider.changePetTypeIndex(0);
    petFormProvider.changePetAge(0);
    petFormProvider.changePetMonths(0);
    petFormProvider.changePetSize('Pequeno-porte');
    petFormProvider.changePetHealthIndex(0);
    petFormProvider.changePetBreedIndex(0);
    petFormProvider.changePetSex('Macho');
    petFormProvider.changePetSelectedCaracteristics([]);
    petFormProvider.changePetDescription('');
    petFormProvider.changePetInEdition(Pet());
    changeSavingStatus(false);
  }

  bool validateForm() {
    changePhotosFieldStatus();
    bool result = petFormProvider.formIsvalid() && photosFieldIsValid;
    return result;
  }

  void changePhotosFieldStatus() {
    setState(() {
      photosFieldIsValid = petFormProvider.getPetPhotos.isNotEmpty;
    });
  }

  void setReadOnly() {
    setState(() {
      readOnly = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    params = ModalRoute.of(context).settings.arguments;
    kind = widget.editMode ? widget.pet.kind : params['kind'];
    petFormProvider.changePetKind(kind);

    Future<bool> _onWillPopScope() {
      if (isSaving || convertingImages) {
        return Future.value(false);
      }
      Navigator.pushReplacementNamed(context, Routes.HOME);
      petFormProvider.getPetPhotos.clear();
      petPhotosToUpload.clear();
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: widget.editMode
              ? Text('Editar dados do ${widget.pet.name}')
              : Text(
                  kind == Constantes.DONATE
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
                                kind == Constantes.DONATE
                                    ? '${petFormProvider.getPetPhotos.isEmpty ? 'Insira pelo menos uma foto' : 'Insira algumas fotos do seu bichinho.'}'
                                    : '${petFormProvider.getPetPhotos.isEmpty ? 'Insira pelo menos uma foto' : 'Insira fotos dele.'}',
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
                        StreamBuilder(
                          stream: petFormProvider.petPhotos,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                Container(
                                  height: 200,
                                  child: ListView.builder(
                                    key: UniqueKey(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        petFormProvider.getPetPhotos.length + 1,
                                    itemBuilder: (ctx, index) {
                                      if (index ==
                                          petFormProvider.getPetPhotos.length) {
                                        return petFormProvider
                                                    .getPetPhotos.length <
                                                maxImages
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
                                !photosFieldIsValid
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
                                snapshot.hasError ? HintError() : SizedBox(),
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
                              initialValue: DummyData.type[snapshot.data ?? 0],
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
                                      kind == Constantes.DONATE &&
                                              snapshot.hasError
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
                                      kind == Constantes.DONATE &&
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
                              initialValue:
                                  DummyData.health[snapshot.data ?? 0],
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
                                            'Características',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Spacer(),
                                          list.isNotEmpty
                                              ? Container(
                                                  height: 20,
                                                  width: 140,
                                                  child: ListView.builder(
                                                    key: UniqueKey(),
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
                                              ? InkWell(
                                                  onTap: () =>
                                                      clearUpCaracteristics(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            style: BorderStyle
                                                                .solid),
                                                        shape: BoxShape.circle),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
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
                            );
                          },
                        ),
                        SizedBox(height: 12),
                        StreamBuilder<String>(
                          stream: petFormProvider.petDescription,
                          builder: (context, snapshot) {
                            return Stack(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: InputText(
                                        placeholder: 'Descrição',
                                        readOnly: readOnly,
                                        size: 150,
                                        onChanged: petFormProvider
                                            .changePetDescription,
                                        controller: _descricao,
                                        multiline: true,
                                        maxlines: 5,
                                      ),
                                    ),
                                    adsProvider.getCanShowAds
                                        ? adsProvider.bannerAdMob(
                                            adId: adsProvider.bottomAdId)
                                        : Container(),
                                  ],
                                ),
                                Positioned(
                                  bottom: 20,
                                  right: 10,
                                  child: snapshot.hasError
                                      ? HintError()
                                      : SizedBox(),
                                )
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
            LoadDarkScreen(show: isSaving, message: 'Aguarde'),
          ],
        ),
        bottomNavigationBar: ButtonWide(
          rounded: false,
          color: isSaving ? Colors.grey : Theme.of(context).primaryColor,
          isToExpand: true,
          action: isSaving || convertingImages
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
                              message: widget.editMode
                                  ? 'Os dados do PET foram atualizados.'
                                  : 'PET postado com sucesso!',
                            )).then(
                      (value) => _onWillPopScope,
                    );
                  } else {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Verifique se há erros no formulário!',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
          text: widget.editMode ? 'SALVAR ALTERAÇÕES' : 'POSTAR',
        ),
      ),
    );
  }
}
