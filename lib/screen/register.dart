import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/input_text.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/user_provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  File imageFile0;
  Map<String, File> userProfile = {};
  UserProvider userProvider;
  Authentication auth;

  @override
  void didChangeDependencies() {
    userProvider = Provider.of(context, listen: false);
    auth = Provider.of(context, listen: false);
    if (userProvider.photoURL != null) {
      userProfile.putIfAbsent('photoURL', () => userProvider.photoURL);
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
        userProvider.changePhotoURL(userProfile['photoURL']);
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
      return "Informe o celular";
    } else if (value.length < 10) {
      return "O celular deve ter 10 dígitos";
    } else if (!regExp.hasMatch(value)) {
      return "O número do celular so deve conter números";
    }
    return null;
  }

  String validarTelefone(String value) {
    value = telefoneMask.getUnmaskedText();

    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o Telefone fixo";
    } else if (value.length < 12) {
      return "O telefone deve ter 12 dígitos";
    } else if (!regExp.hasMatch(value)) {
      return "O número do telefone só deve conter números";
    }
    return null;
  }

  TextEditingController _whatsapp = TextEditingController();
  TextEditingController _telefone = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> save() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.firebaseUser.uid)
        .set({
      'displayName': auth.firebaseUser.displayName,
      'photoURL': userProfile['photoURL'],
      'phoneNumber': _whatsapp.text
    });
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
      body: Center(
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
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment(-0.9, 1),
                    child: Text('Informe um telefone residencial (Opcional)'),
                  ),
                  SizedBox(height: 5),
                  InputText(
                    inputFormatters: [telefoneMask],
                    placeholder: '(XX) X XXXX-XXXX',
                    keyBoardTypeNumber: true,
                    controller: _telefone,
                    onChanged: () {
                      userProvider.changeTelefone(_telefone.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: ButtonWide(
        color: Colors.green,
        text: 'FINALIZAR',
        rounded: false,
        action: () {
          if (_formKey.currentState.validate()) {
            save();
          }
        },
      ),
      backgroundColor: Colors.blueGrey[50],
    );
  }
}
