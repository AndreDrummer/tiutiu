import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:tiutiu/Widgets/input_text.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/formatter.dart';
import 'package:tiutiu/utils/routes.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';

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

  bool nameHasError = false;
  String nameHasErrorMessage = '';

  bool finishing = false;

  int betterContact = 0;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void setFinishing(bool status) {
    setState(() {
      finishing = status;
    });
  }

  @override
  void didChangeDependencies() {
    userProvider = Provider.of(context, listen: false);
    auth = Provider.of(context, listen: false);
    if (userProvider.photoFILE != null) {
      userProfile.putIfAbsent('photoFile', () => userProvider.photoFILE);
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
        userProfile.putIfAbsent('photoFile', () => imageFile0);
        userProvider.changePhotoFILE(userProfile['photoFile']);
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
              child: Text('Tirar uma foto', style: TextStyle(color: Colors.black)),
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
      return null;
    } else if (value.length < 11) {
      setState(() {
        whatsappHasErrorMessage = "O celular deve ter 11 dígitos";
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
    } else if (value.length < 10) {
      setState(() {
        telefoneHasErrorMessage = "O telefone deve ter 10 dígitos";
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
  TextEditingController _name = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> uploadPhotos() async {
    StorageUploadTask uploadTask;
    StorageReference storageReference;

    storageReference = FirebaseStorage.instance.ref().child('${auth.firebaseUser.uid}').child('avatar/foto_perfil');

    uploadTask = storageReference.putFile(userProfile['photoFile']);

    await uploadTask.onComplete;
    await storageReference.getDownloadURL().then((urlDownload) async {
      photoURL = await urlDownload;
      print('URL DOWNLOAD $urlDownload');
    });

    return Future.value();
  }

  bool formIsValid() {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);

    if (_whatsapp.text.trim().isEmpty) {
      setState(() {
        whatsappHasError = true;
      });
    }

    if (_name.text.trim().isEmpty) {
      setState(() {
        nameHasError = true;
      });
    }

    if (_whatsapp.text.trim().isNotEmpty) {
      String unMaskNumber = Formatter.unmaskNumber(_whatsapp.text.trim());
      if (!regExp.hasMatch(unMaskNumber) || unMaskNumber.length < 11) {
        setState(() {
          whatsappHasError = true;
          whatsappHasErrorMessage = 'Insira um número válido';
        });
      } else {
        setState(() {
          whatsappHasError = false;
        });
      }
    }

    if (_name.text.trim().isNotEmpty) {
      setState(() {
        nameHasError = false;
      });
    }

    return !finishing && !nameHasError && !userProfileHasError;
  }

  Future<void> save() async {
    await uploadPhotos();
    UserController userController = UserController();
    await userController.updateUser(auth.firebaseUser.uid, {
      'displayName': _name.text.trim(),
      'uid': auth.firebaseUser.uid,
      'photoURL': photoURL,
      'phoneNumber': _whatsapp.text.trim(),
      'landline': _telefone.text.trim(),
      'betterContact': userProvider.getBetterContact,
      'email': auth.firebaseUser.email,
      'createdAt': DateTime.now().toIso8601String()
    });
    userProvider.changePhotoUrl(photoURL);
    userProfile.clear();
    userProvider.changeTelefone('');
    userProvider.changeWhatsapp('');
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Seja bem vindo!',
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
        ),
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
                                      ? Icon(Icons.person, color: Colors.white38, size: 50)
                                      : Image.file(
                                          userProfile['photoFile'],
                                          width: 1000,
                                          height: 1000,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Adicione sua foto',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                userProfileHasError
                                    ? HintError(
                                        message: userProfileHasErrorMessage,
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      InputText(
                        placeholder: 'Como quer ser chamado (Obrigatório)',
                        controller: _name,
                        validator: (String text) {
                          if (text.isEmpty || text.length < 3) {
                            setState(() {
                              nameHasErrorMessage = "Seu nome é obrigatório";
                              nameHasError = true;
                            });
                          } else {
                            setState(() {
                              nameHasErrorMessage = "";
                              nameHasError = false;
                            });
                          }
                        },
                      ),
                      nameHasError ? HintError(message: nameHasErrorMessage) : Container(),
                      SizedBox(height: 15),
                      InputText(
                        inputFormatters: [celularMask],
                        placeholder: 'Informe seu Whatsapp',
                        hintText: '(XX) X XXXX-XXXX',
                        keyBoardTypeNumber: true,
                        controller: _whatsapp,
                        validator: validarCelular,
                        onChanged: (text) {
                          userProvider.changeWhatsapp(_whatsapp.text.trim());
                        },
                      ),
                      whatsappHasError ? HintError(message: whatsappHasErrorMessage) : Container(),
                      SizedBox(height: 15),
                      InputText(
                        inputFormatters: [telefoneMask],
                        validator: validarTelefone,
                        placeholder: 'Informe um telefone fixo',
                        hintText: '(XX) XXXX-XXXX',
                        keyBoardTypeNumber: true,
                        controller: _telefone,
                        onChanged: (text) {
                          userProvider.changeTelefone(_telefone.text.trim());
                        },
                      ),
                      telefoneHasError ? HintError(message: telefoneHasErrorMessage) : Container(),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment(-0.8, 1),
                        child: Text('Escolha sua melhor forma de contato.'),
                      ),
                      StreamBuilder<Object>(
                        stream: userProvider.betterContact,
                        builder: (context, snapshot) {
                          return Container(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    userProvider.changeBetterContact(0);
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: Theme.of(context).primaryColor,
                                        groupValue: snapshot.data,
                                        value: 0,
                                        onChanged: (value) {
                                          userProvider.changeBetterContact(value);
                                          if (_whatsapp.text.trim().isEmpty) {
                                            setState(() {
                                              whatsappHasErrorMessage = 'Quando este é seu melhor contato, deve ser preenchido.';
                                              whatsappHasError = true;
                                              telefoneHasError = false;
                                            });
                                          }
                                        },
                                      ),
                                      Text('WhatsApp'),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    userProvider.changeBetterContact(1);
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: Colors.orange,
                                        groupValue: snapshot.data,
                                        value: 1,
                                        onChanged: (value) {
                                          userProvider.changeBetterContact(value);
                                          if (_telefone.text.trim().isEmpty) {
                                            setState(() {
                                              telefoneHasError = true;
                                              whatsappHasError = false;
                                              telefoneHasErrorMessage = 'Quando este é seu melhor contato, deve ser preenchido.';
                                            });
                                          }
                                        },
                                      ),
                                      Text('Telefone Fixo'),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    userProvider.changeBetterContact(2);
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: Colors.red,
                                        groupValue: snapshot.data,
                                        value: 2,
                                        onChanged: (value) {
                                          setState(() {
                                            telefoneHasError = false;
                                            whatsappHasError = false;
                                          });
                                          userProvider.changeBetterContact(value);
                                        },
                                      ),
                                      Text('E-mail'),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    userProvider.changeBetterContact(3);
                                  },
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: Colors.purple,
                                        groupValue: snapshot.data,
                                        value: 3,
                                        onChanged: (value) {
                                          setState(() {
                                            telefoneHasError = false;
                                            whatsappHasError = false;
                                          });
                                          userProvider.changeBetterContact(value);
                                        },
                                      ),
                                      Text('Somente pelo chat do aplicativo'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          LoadDarkScreen(show: finishing, message: 'Finalizando cadastro'),
        ],
      ),
      bottomNavigationBar: ButtonWide(
        color: finishing ? Colors.grey : Theme.of(context).primaryColor,
        text: 'FINALIZAR',
        rounded: false,
        action: finishing
            ? null
            : () async {
                if (_formKey.currentState.validate()) {
                  if (userProvider.getBetterContact == 1 && (_telefone.text.trim().isEmpty || _telefone.text.trim().length < 12)) {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1),
                        content: Text('Quando este é seu melhor contato, deve ser preenchido.'),
                      ),
                    );
                  } else {
                    if (validatePictureProfile()) {
                      setFinishing(true);
                      await save();
                      setFinishing(false);
                      await auth.alreadyRegistered();
                      Navigator.pushReplacementNamed(context, Routes.AUTH_HOME);
                    }
                  }
                }
              },
      ),
      backgroundColor: Colors.blueGrey[50],
    );
  }
}
