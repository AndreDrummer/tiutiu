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

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File imageFile0;
  String photoURL;
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
    StorageReference storageReference;

    storageReference = FirebaseStorage.instance
        .ref()
        .child('${auth.firebaseUser.uid}')
        .child('avatar/foto_perfil');

    storageReference.delete();
    uploadTask = storageReference.putFile(userProfile['photoFile']);

    await uploadTask.onComplete;
    await storageReference.getDownloadURL().then((urlDownload) async {
      photoURL = await urlDownload;
      print('URL DOWNLOAD $urlDownload');
    });

    return Future.value();
  }

  bool passwordWasTouched() {
    return _newPassword.text.isNotEmpty && _repeatNewPassword.text.isNotEmpty;
  }

  void save() async {
    if (_passwordFormKey.currentState.validate()) {
      if (passwordWasTouched()) {
        changeSaveFormStatus(true);
        try {
          await auth.firebaseUser.updatePassword(_newPassword.text);
        } catch (error) {
          showDialog(
            context: context,
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
          );
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
      userProfile.clear();

      changeSaveFormStatus(false);
      await showDialog(
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
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      backgroundColor: Colors.blueGrey[50],
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      openModalSelectMedia(context);
                    },
                    child: Container(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black12,
                            child: ClipOval(
                                child: userProfile.isEmpty
                                    ? userProvider.photoURL != null
                                        ? FadeInImage(
                                            placeholder: AssetImage(
                                                'assets/profileEmpty.jpg'),
                                            image: NetworkImage(
                                              userProvider.photoURL,
                                            ),
                                            fit: BoxFit.cover,
                                            width: 1000,
                                            height: 100,
                                          )
                                        : Icon(Icons.person,
                                            color: Colors.white54, size: 50)
                                    : Image.file(userProfile['photoFile'],
                                        width: 1000,
                                        height: 1000,
                                        fit: BoxFit.cover)),
                          ),
                          SizedBox(height: 7),
                          Text('Alter/Adicionar')
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Form(
                      key: _personalDataFormKey,
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text('Nome'),
                            subtitle: isNameEditing
                                ? TextFormField(
                                    controller: _nameController,
                                  )
                                : Text(_nameController.text),
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
                            title: Text('WhatsApp'),
                            subtitle: isWhatsAppEditing
                                ? TextFormField(
                                    inputFormatters: [celularMask],
                                    validator: (String value) =>
                                        validarCelular(value),
                                    keyboardType: TextInputType.number,
                                    controller: _whatsAppController,
                                  )
                                : Text(_whatsAppController.text),
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
                                  changeFieldEditingState(
                                      true, 'isWhatsAppEditing');
                                }
                              },
                            ),
                          ),
                          ListTile(
                            title: Text('Telefone Fixo'),
                            subtitle: isTelefoneEditing
                                ? TextFormField(
                                    inputFormatters: [telefoneMask],
                                    validator: (String value) =>
                                        validarTelefone(value),
                                    keyboardType: TextInputType.number,
                                    controller: _telefoneController,
                                  )
                                : Text(_telefoneController.text),
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
                                  changeFieldEditingState(
                                      true, 'isTelefoneEditing');
                                }
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment(-0.8, 1),
                            child: Text('Sua melhor forma de contato'),
                          ),
                          StreamBuilder<Object>(
                            stream: userProvider.betterContact,
                            builder: (context, snapshot) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    activeColor: Colors.green,
                                    groupValue: snapshot.data,
                                    value: 0,
                                    onChanged: (value) {
                                      userProvider.changeBetterContact(value);
                                    },
                                  ),
                                  Text('WhatsApp'),
                                  Radio(
                                    activeColor: Colors.orange,
                                    groupValue: snapshot.data,
                                    value: 1,
                                    onChanged: (value) {
                                      userProvider.changeBetterContact(value);
                                    },
                                  ),
                                  Text('Telefone Fixo'),
                                  Radio(
                                    activeColor: Colors.red,
                                    groupValue: snapshot.data,
                                    value: 2,
                                    onChanged: (value) {
                                      userProvider.changeBetterContact(value);
                                    },
                                  ),
                                  Text('E-mail'),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomDivider(text: 'Alterar senha'),
                  Form(
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
                  )
                ],
              ),
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
                          style:
                              Theme.of(context).textTheme.headline1.copyWith(),
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
        text: 'Salvar',
      ),
    );
  }
}
