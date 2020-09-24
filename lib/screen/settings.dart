import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/divider.dart';
import 'package:tiutiu/Widgets/input_text.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/formatter.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File imageFile0;
  File imageFile1;
  String photoURL;
  String photoBACK;
  Map<String, File> userProfile = {};

  bool isNameEditing = false;
  bool isWhatsAppEditing = false;
  bool isTelefoneEditing = false;
  int betterContact;

  bool isSavingForm = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _whatsAppController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();

  TextEditingController _newPassword = TextEditingController();
  TextEditingController _repeatNewPassword = TextEditingController();

  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _personalDataFormKey = GlobalKey<FormState>();
  UserProvider userProvider;
  Authentication auth;

  bool telefoneHasError = false;
  bool whatsappHasError = false;

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
    if (userProvider.getBetterContact == 0 && value.isEmpty && userProvider.whatsapp != null && userProvider.whatsapp.isEmpty) {
      return 'Número é obrigatório';
    }
    if (value.isNotEmpty && value.length < 11) {
      return 'Número deve ter 11 dígitos';
    } else if (!regExp.hasMatch(value)) {
      return "O número do celular so deve conter números";
    }
    return null;
  }

  String validarTelefone(String value) {
    value = telefoneMask.getUnmaskedText();

    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (userProvider.getBetterContact == 1 && value.isEmpty && userProvider.telefone != null && userProvider.telefone.isEmpty) {
      return 'Número é obrigatório';
    }
    if (value.isNotEmpty && value.length < 10) {
      return 'Número deve ter 10 dígitos';
    } else if (!regExp.hasMatch(value)) {
      return "O número do telefone so deve conter números";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of(context, listen: false);
    if (userProvider.displayName != null)
      _nameController.text = userProvider.displayName;
    if (userProvider.whatsapp != null)
      _whatsAppController.text = userProvider.whatsapp;
    if (userProvider.telefone != null)
      _telefoneController.text = userProvider.telefone;
    if (userProvider.photoURL != null) photoURL = userProvider.photoURL;
    if (userProvider.photoBACK != null) photoBACK = userProvider.photoBACK;
  }

  @override
  void didChangeDependencies() {
    auth = Provider.of(context);
    super.didChangeDependencies();
  }

  void changeSaveFormStatus(bool status) {
    setState(() {
      isSavingForm = status;
    });
  }

  void changeFieldEditingState(bool newState, String field) {
    switch (field) {
      case 'isNameEditing':
        setState(() {
          isNameEditing = newState;
        });
        break;
      case 'isWhatsAppEditing':
        setState(() {
          isWhatsAppEditing = newState;
        });
        break;
      case 'isTelefoneEditing':
        setState(() {
          isTelefoneEditing = newState;
        });
        break;
    }
  }

  Future<void> uploadPhotos() async {
    StorageUploadTask uploadTask;
    StorageReference storageReferenceProfile;
    StorageReference storageReferenceback;

    if (userProfile['photoFile'] != null) {
      storageReferenceProfile = FirebaseStorage.instance
          .ref()
          .child('${auth.firebaseUser.uid}')
          .child('avatar/foto_perfil');

      storageReferenceProfile.delete();
      uploadTask = storageReferenceProfile.putFile(userProfile['photoFile']);

      await uploadTask.onComplete;
      await storageReferenceProfile.getDownloadURL().then((urlDownload) async {
        photoURL = await urlDownload;
        print('URL DOWNLOAD $urlDownload');
      });
    }

    if (userProfile['photoFileBack'] != null) {
      storageReferenceback = FirebaseStorage.instance
          .ref()
          .child('${auth.firebaseUser.uid}')
          .child('avatar/foto_fundo');

      storageReferenceback.delete();
      uploadTask = storageReferenceback.putFile(userProfile['photoFileBack']);

      await uploadTask.onComplete;
      await storageReferenceback.getDownloadURL().then((urlDownload) async {
        photoBACK = await urlDownload;
        print('URL DOWNLOAD $urlDownload');
      });
    }

    return Future.value();
  }

  bool passwordWasTouched() {
    return _newPassword.text.isNotEmpty && _repeatNewPassword.text.isNotEmpty;
  }

  bool validatePersonalData() {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);

    bool validWhatsapp = _whatsAppController.text.isNotEmpty &&
        _whatsAppController.text.contains('-') &&
        regExp.hasMatch(_whatsAppController.text.split('-')[1]);

    bool validTelefone = _telefoneController.text.isNotEmpty &&
        _telefoneController.text.contains('-') &&
        regExp.hasMatch(_telefoneController.text.split('-')[1]);

    if (userProvider.getBetterContact == 0) {
      var serializedWhatsappNumber = Formatter.unmaskNumber(_telefoneController.text);
      if(serializedWhatsappNumber == null) {
        _telefoneController.clear();
      }
      if (!validWhatsapp) {
        setState(() {
          whatsappHasError = true;
          _whatsAppController.text =
              'Quando este é o seu melhor contato, deve ser preenchido!';
        });
        return false;
      }
    }

    if (userProvider.getBetterContact == 1) {
      var serializedWhatsappNumber = Formatter.unmaskNumber(_whatsAppController.text);
      if(serializedWhatsappNumber == null) {
        _whatsAppController.clear();
      }
      if (!validTelefone) {
        setState(() {
          telefoneHasError = true;
          _telefoneController.text =
              'Quando este é o seu melhor contato, deve ser preenchido!';
        });
        return false;
      }
    }

    if (_telefoneController.text.isNotEmpty) {
      if (!_telefoneController.text.contains('-'))
        setState(() {
          telefoneHasError = true;
          _telefoneController.text = 'Insira um número válido ou deixe vazio';
        });
      return _telefoneController.text.contains('-');
    }

    if (_whatsAppController.text.isNotEmpty) {
      if (!_whatsAppController.text.contains('-'))
        setState(() {
          whatsappHasError = true;
          _whatsAppController.text = 'Insira um número válido ou deixe vazio';
        });
      return _whatsAppController.text.contains('-');
    }

    print('PRONTO');
    setState(() {
      telefoneHasError = false;
      whatsappHasError = false;
    });

    return !whatsappHasError && !telefoneHasError;
  }

  void save({bool isToShowDialog = true}) async {
    if (_passwordFormKey.currentState.validate() && validatePersonalData()) {
      if (passwordWasTouched()) {
        changeSaveFormStatus(true);
        try {
          await auth.firebaseUser.updatePassword(_newPassword.text);
        } catch (error) {
          isToShowDialog
              ? showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: PopUpMessage(
                    confirmAction: () {
                      auth.signOut();
                      ModalRoute.withName('/');
                    },
                    confirmText: 'Deslogar Agora',
                    denyAction: () {
                      Navigator.pop(context);
                      changeSaveFormStatus(false);
                    },
                    denyText: 'Não',
                    warning: true,
                    message:
                        'Esta operação é confidencial e requer autenticação recente. Faça login novamente antes de tentar novamente esta solicitação.',
                    title: 'Faça login novamente',
                  ),
                )
              : SizedBox();
          throw '';
        }
      }

      changeSaveFormStatus(true);
      if (userProfile.isNotEmpty) {
        await uploadPhotos();
      }

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.firebaseUser.uid)
          .set({
        'displayName': _nameController.text,
        'uid': auth.firebaseUser.uid,
        'photoURL': userProfile.isNotEmpty ? photoURL : userProvider.photoURL,
        'photoBACK':
            userProfile.isNotEmpty ? photoBACK : userProvider.photoBACK,
        'phoneNumber': _whatsAppController.text,
        'landline': _telefoneController.text,
        'betterContact': userProvider.getBetterContact,
        'email': auth.firebaseUser.email
      });

      userProvider.changeDisplayName(_nameController.text);
      userProvider.changeBetterContact(userProvider.getBetterContact);
      userProvider.changeWhatsapp(_whatsAppController.text);
      userProvider.changeTelefone(_telefoneController.text);
      userProvider.changePhotoUrl(photoURL);
      userProvider.changePhotoBack(photoBACK);
      userProfile.clear();

      changeSaveFormStatus(false);
      isToShowDialog
          ? await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => PopUpMessage(
                confirmAction: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName('/'),
                  );
                },
                confirmText: 'Voltar a tela inicial',
                message: 'Tudo certo!',
                title: 'Sucesso!',
              ),
            )
          : SizedBox();
    }
  }

  void selectImage(ImageSource source, {bool perfil = true}) async {
    var picker = ImagePicker();
    dynamic image = await picker.getImage(source: source);
    image = File(image.path);

    if (perfil) {
      setState(
        () {
          imageFile0 = image;
          userProfile.remove('photoFile');
          userProfile.putIfAbsent('photoFile', () => imageFile0);
          userProvider.changePhotoFILE(userProfile['photoFile']);
        },
      );
    } else {
      setState(
        () {
          imageFile1 = image;
          userProfile.remove('photoFileBack');
          userProfile.putIfAbsent('photoFileBack', () => imageFile1);
          userProvider.changePhotoFILE(userProfile['photoFileBack']);
        },
      );
    }
  }

  void openModalSelectMedia(BuildContext context, bool perfil) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            FlatButton(
              child:
                  Text('Tirar uma foto', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black)),
              onPressed: () {
                Navigator.pop(context);
                selectImage(ImageSource.camera, perfil: perfil);
              },
            ),
            FlatButton(
              child: Text('Abrir galeria', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black)),
              onPressed: () {
                Navigator.pop(context);
                selectImage(ImageSource.gallery, perfil: perfil);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        if (_personalDataFormKey.currentState.validate()) {          
          return Future.value(true);
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Configurações', style: TextStyle(fontSize: 20),)
        ),
        backgroundColor: Colors.blueGrey[50],
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          openModalSelectMedia(context, false);
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          child: Opacity(
                            child: userProfile['photoFileBack'] == null
                                ? FadeInImage(
                                    placeholder: AssetImage('assets/fundo.jpg'),
                                    image: NetworkImage(
                                      userProvider.photoBACK ?? '',
                                    ),
                                    fit: BoxFit.cover,
                                    width: 1000,
                                    height: 100,
                                  )
                                : Image.file(
                                    userProfile['photoFileBack'],
                                    width: 1000,
                                    height: 1000,
                                    fit: BoxFit.cover,
                                  ),
                            opacity: 0.25,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                openModalSelectMedia(context, true);
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.black12,
                                child: ClipOval(
                                  child: userProfile['photoFile'] == null
                                      ? userProvider.photoURL != null
                                          ? FadeInImage(
                                              placeholder: AssetImage(
                                                  'assets/profileEmpty.png'),
                                              image: NetworkImage(
                                                userProvider.photoURL,
                                              ),
                                              fit: BoxFit.cover,
                                              width: 1000,
                                              height: 100,
                                            )
                                          : Icon(Icons.person,
                                              color: Colors.white54, size: 50)
                                      : Image.file(
                                          userProfile['photoFile'],
                                          width: 1000,
                                          height: 1000,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Form(
                      key: _personalDataFormKey,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text('Nome', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black)),
                            subtitle: isNameEditing
                                ? TextFormField(
                                  style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black54, fontWeight: FontWeight.w300),
                                    controller: _nameController,
                                  )
                                : Text(_nameController.text, style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black)),
                            trailing: IconButton(
                              icon: isNameEditing
                                  ? Icon(Icons.save)
                                  : Icon(Icons.mode_edit),
                              onPressed: () {
                                if (isNameEditing) {
                                  userProvider
                                      .changeDisplayName(_nameController.text);
                                  changeFieldEditingState(
                                      false, 'isNameEditing');
                                } else {
                                  changeFieldEditingState(
                                      true, 'isNameEditing');
                                }
                              },
                            ),
                          ),
                          ListTile(
                            title: Text('WhatsApp', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black)),
                            subtitle: isWhatsAppEditing
                                ? TextFormField(
                                  style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black54, fontWeight: FontWeight.w300),
                                    onChanged: (_) {
                                      validatePersonalData();
                                    },
                                    inputFormatters: [celularMask],
                                    validator: (String value) =>
                                        validarCelular(value),
                                    keyboardType: TextInputType.number,
                                    controller: _whatsAppController,
                                  )
                                : Text(_whatsAppController.text,
                                    style: whatsappHasError
                                        ? TextStyle(
                                            color: Colors.red, fontSize: 11)
                                        : null),
                            trailing: IconButton(
                              icon: isWhatsAppEditing
                                  ? Icon(Icons.save)
                                  : Icon(Icons.mode_edit),
                              onPressed: () {
                                if (isWhatsAppEditing) {
                                  userProvider
                                      .changeWhatsapp(_whatsAppController.text);
                                  if (_personalDataFormKey.currentState
                                      .validate()) {
                                    changeFieldEditingState(
                                        false, 'isWhatsAppEditing');
                                  }
                                } else {
                                  _whatsAppController.text =
                                      userProvider.whatsapp;
                                  changeFieldEditingState(
                                      true, 'isWhatsAppEditing');
                                }
                              },
                            ),
                          ),
                          ListTile(
                            title: Text('Telefone Fixo', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black)),
                            subtitle: isTelefoneEditing
                                ? TextFormField(
                                  style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black54, fontWeight: FontWeight.w300),
                                    onChanged: (_) {
                                      validatePersonalData();
                                    },
                                    inputFormatters: [telefoneMask],
                                    validator: (String value) =>
                                        validarTelefone(value),
                                    keyboardType: TextInputType.number,
                                    controller: _telefoneController,
                                  )
                                : Text(_telefoneController.text,
                                    style: telefoneHasError
                                        ? TextStyle(
                                            color: Colors.red, fontSize: 11)
                                        : null),
                            trailing: IconButton(
                              icon: isTelefoneEditing
                                  ? Icon(Icons.save)
                                  : Icon(Icons.mode_edit),
                              onPressed: () {
                                if (isTelefoneEditing) {
                                  userProvider
                                      .changeTelefone(_telefoneController.text);
                                  if (_personalDataFormKey.currentState
                                      .validate()) {
                                    changeFieldEditingState(
                                        false, 'isTelefoneEditing');
                                  }
                                } else {
                                  _telefoneController.text =
                                      userProvider.telefone;
                                  changeFieldEditingState(
                                      true, 'isTelefoneEditing');
                                }
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment(-0.8, 1),
                            child: Text('Sua melhor forma de contato', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black)),
                          ),
                          StreamBuilder<Object>(
                            stream: userProvider.betterContact,
                            builder: (context, snapshot) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    activeColor: Theme.of(context).primaryColor,
                                    groupValue: snapshot.data,
                                    value: 0,
                                    onChanged: (value) {
                                      userProvider.changeBetterContact(value);
                                    },
                                  ),
                                  Text('WhatsApp', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black)),
                                  Radio(
                                    activeColor: Colors.orange,
                                    groupValue: snapshot.data,
                                    value: 1,
                                    onChanged: (value) {
                                      userProvider.changeBetterContact(value);
                                    },
                                  ),
                                  Text('Telefone Fixo', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black)),
                                  Radio(
                                    activeColor: Colors.red,
                                    groupValue: snapshot.data,
                                    value: 2,
                                    onChanged: (value) {
                                      userProvider.changeBetterContact(value);
                                    },
                                  ),
                                  Text('E-mail', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black)),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomDivider(text: 'Alterar senha'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Form(
                      key: _passwordFormKey,
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          InputText(
                            isPassword: true,
                            hintText: 'Nova Senha',
                            controller: _newPassword,
                            validator: (String value) {
                              if (value.isEmpty &&
                                  _repeatNewPassword.text.isEmpty) {
                                return null;
                              }
                              if (value.length < 6) {
                                return 'A nova senha deve ter no mínimo 6 dígitos';
                              }
                            },
                          ),
                          SizedBox(height: 15),
                          InputText(
                            isPassword: true,
                            hintText: 'Repita a nova senha',
                            controller: _repeatNewPassword,
                            validator: (String value) {
                              if (value.isEmpty && _newPassword.text.isEmpty) {
                                return null;
                              }
                              if (value != _newPassword.text) {
                                return 'Senhas não conferem';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height < 500 ? 100 : 40)
                ],
              ),
            ),
            isSavingForm
                ? Container(
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
                          Text(
                            'Salvando informações',
                            style: Theme.of(context)
                                .textTheme
                                .headline1.copyWith(color: Colors.black)
                                .copyWith(),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        bottomNavigationBar: ButtonWide(
          action: save,
          isToExpand: true,
          rounded: false,
          text: 'SALVAR',
        ),
      ),
    );
  }
}
