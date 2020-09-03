import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:tiutiu/Widgets/input_text.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/routes.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  File imageFile0;
  String photoURL;
  Map<String, File> userProfile = {};
  UserProvider userProvider;
  Authentication auth;
  bool whatsappHasError = false;
  String whatsappHasErrorMessage = '';

  bool telefoneHasError = false;
  String telefoneHasErrorMessage = '';

  bool userProfileHasError = false;
  String userProfileHasErrorMessage = '';

  bool finishing = false;

  void setFinishing(bool status) {
    setState(() {
      finishing = status;
    });
  }

  @override
  void didChangeDependencies() {
    userProvider = Provider.of(context, listen: false);
    auth = Provider.of(context, listen: false);
    if (userProvider.photoURL != null) {
      userProfile.putIfAbsent('photoURL', () => userProvider.photoFILE);
    }
    if (userProvider.whatsapp != null) {
      _whatsapp.text = userProvider.whatsapp;
    }
    if (userProvider.telefone != null) {
      _telefone.text = userProvider.telefone;
    }
    super.didChangeDependencies();
  }

  void selectImage(ImageSource source) async {
    var picker = ImagePicker();
    dynamic image = await picker.getImage(source: source);
    image = File(image.path);
    setState(
      () {
        imageFile0 = image;
        userProfile.clear();
        userProfile.putIfAbsent('photoURL', () => imageFile0);
        userProvider.changePhotoFILE(userProfile['photoURL']);
      },
    );
  }

  void openModalSelectMedia(BuildContext context) {
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
                selectImage(ImageSource.camera);
              },
            ),
            FlatButton(
              child: Text('Abrir galeria'),
              onPressed: () {
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
            )
          ],
        );
      },
    );
  }

  var telefoneMask = new MaskTextInputFormatter(
    mask: '(##) ####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  var celularMask = new MaskTextInputFormatter(
    mask: '(##) # ####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String validarCelular(String value) {
    value = celularMask.getUnmaskedText();

    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      setState(() {
        whatsappHasErrorMessage = "Informe o seu WhatsApp";
        whatsappHasError = true;
      });
      return null;
    } else if (value.length < 10) {
      setState(() {
        whatsappHasErrorMessage = "O celular deve ter 10 dígitos";
        whatsappHasError = true;
      });
      return null;
    } else if (!regExp.hasMatch(value)) {
      setState(() {
        whatsappHasErrorMessage = "O número do celular so deve conter números";
        whatsappHasError = true;
      });
      return null;
    }
    setState(() {
      whatsappHasErrorMessage = '';
      whatsappHasError = false;
    });
    return null;
  }

  String validarTelefone(String value) {
    value = telefoneMask.getUnmaskedText();

    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return null;
    } else if (value.length < 12) {
      setState(() {
        telefoneHasErrorMessage = "O telefone deve ter 12 dígitos";
        telefoneHasError = true;
      });
      return null;
    } else if (!regExp.hasMatch(value)) {
      setState(() {
        telefoneHasErrorMessage = "O número do telefone só deve conter números";
        telefoneHasError = true;
      });
      return null;
    }
    setState(() {
      telefoneHasErrorMessage = "";
      telefoneHasError = false;
    });
    return null;
  }

  bool validatePictureProfile() {
    if (userProfile.isEmpty) {
      setState(() {
        userProfileHasErrorMessage = "Adicione sua foto";
        userProfileHasError = true;
      });
      return false;
    } else {
      setState(() {
        userProfileHasErrorMessage = "";
        userProfileHasError = false;
      });
    }
    return true;
  }

  TextEditingController _whatsapp = TextEditingController();
  TextEditingController _telefone = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> uploadPhotos() async {
    StorageUploadTask uploadTask;
    StorageReference storageReference;

    storageReference = FirebaseStorage.instance
        .ref()
        .child('${auth.firebaseUser.uid}')
        .child('avatar');
    uploadTask = storageReference.putFile(userProfile['photoURL']);

    await uploadTask.onComplete;
    await storageReference.getDownloadURL().then((urlDownload) async {
      photoURL = await urlDownload;
      print('URL DOWNLOAD $urlDownload');
    });

    return Future.value();
  }

  Future<void> save() async {    
    await uploadPhotos();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.firebaseUser.uid)
        .set({
      'displayName': auth.firebaseUser.displayName,
      'uid': auth.firebaseUser.uid,
      'photoURL': photoURL,
      'phoneNumber': _whatsapp.text
    });
    userProvider.changePhotoUrl(photoURL);
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    print(userProvider.photoURL);
    print(userProvider.telefone);
    print(userProvider.whatsapp);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem vindo!'),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Seja bem vindo! Conclua seu cadastro para continuar.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                      ),
                      SizedBox(height: 25),
                      InkWell(
                        onTap: () {
                          openModalSelectMedia(context);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.black12,
                                child: ClipOval(
                                  child: userProfile.isEmpty
                                      ? Icon(Icons.person,
                                          color: Colors.white38, size: 50)
                                      : Image.file(
                                          userProfile['photoURL'],
                                          width: 1000,
                                          height: 1000,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('Adicione sua foto'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                userProfileHasError
                                    ? HintError(message: userProfileHasErrorMessage)
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Align(
                        alignment: Alignment(-0.9, 1),
                        child: Text('Informe seu WhatsApp'),
                      ),
                      SizedBox(height: 5),
                      InputText(
                        inputFormatters: [celularMask],
                        placeholder: '(XX) X XXXX-XXXX',
                        keyBoardTypeNumber: true,
                        controller: _whatsapp,
                        validator: validarCelular,
                        onChanged: () {
                          userProvider.changeWhatsapp(_whatsapp.text);
                        },
                      ),
                      whatsappHasError
                          ? HintError(message: whatsappHasErrorMessage)
                          : Container(),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment(-0.9, 1),
                        child: Text('Informe um telefone residencial (Opcional)'),
                      ),
                      SizedBox(height: 5),
                      InputText(
                        inputFormatters: [telefoneMask],
                        validator: (String value) {
                          print('validate telefone');
                          if (_telefone.text.isNotEmpty) {
                            return validarTelefone(value);
                          }
                        },
                        placeholder: '(XX) XXXX-XXXX',
                        keyBoardTypeNumber: true,
                        controller: _telefone,
                        onChanged: () {
                          userProvider.changeTelefone(_telefone.text);
                        },
                      ),
                      telefoneHasError
                          ? HintError(message: telefoneHasErrorMessage)
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          finishing ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingBumpingLine.circle(
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 15),
                  Text('Finalizando cadastro', style: Theme.of(context).textTheme.headline1.copyWith())
                ],
              ),
            ),
          ) : Container()
        ],
      ),
      bottomNavigationBar: ButtonWide(
        color: Colors.green,
        text: 'FINALIZAR',
        rounded: false,
        action: () async {
          if (_formKey.currentState.validate() && validatePictureProfile()) {
            setFinishing(true);
            await save();
            setFinishing(false);
            await auth.alreadyRegistered();
            Navigator.pushReplacementNamed(context, Routes.AUTH_HOME);
          }
        },
      ),
      backgroundColor: Colors.blueGrey[50],
    );
  }
}
