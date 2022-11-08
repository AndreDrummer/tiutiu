import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:tiutiu/Widgets/outline_input_text.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? whatsappHasErrorMessage = '';
  Map<String, File> userProfile = {};
  bool? whatsappHasError = false;

  File? imageFile0;
  String? photoURL;

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

  void selectImage(ImageSource source) async {
    var picker = ImagePicker();
    dynamic image = await picker.pickImage(source: source);
    image = File(image.path);
    setState(
      () {
        imageFile0 = image;
        userProfile.clear();
        userProfile.putIfAbsent('photoFile', () => imageFile0!);
      },
    );
  }

  void openModalSelectMedia(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            TextButton(
              child: AutoSizeText('Tirar uma foto', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
            ),
            TextButton(
              child: AutoSizeText('Abrir galeria'),
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
      return '';
    } else if (value.length < 11) {
      setState(() {
        whatsappHasErrorMessage = "O celular deve ter 11 dígitos";
        whatsappHasError = true;
      });
      return '';
    } else if (!regExp.hasMatch(value)) {
      setState(() {
        whatsappHasErrorMessage = "O número do celular so deve conter números";
        whatsappHasError = true;
      });
      return '';
    }
    setState(() {
      whatsappHasErrorMessage = '';
      whatsappHasError = false;
    });
    return '';
  }

  String validarTelefone(String value) {
    value = telefoneMask.getUnmaskedText();

    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return '';
    } else if (value.length < 10) {
      setState(() {
        telefoneHasErrorMessage = "O telefone deve ter 10 dígitos";
        telefoneHasError = true;
      });
      return '';
    } else if (!regExp.hasMatch(value)) {
      setState(() {
        telefoneHasErrorMessage = "O número do telefone só deve conter números";
        telefoneHasError = true;
      });
      return '';
    }
    setState(() {
      telefoneHasErrorMessage = "";
      telefoneHasError = false;
    });
    return '';
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
    UploadTask uploadTask;
    Reference storageReference;

    storageReference =
        FirebaseStorage.instance.ref().child('${tiutiuUserController.tiutiuUser.uid}').child('avatar/foto_perfil');

    uploadTask = storageReference.putFile(userProfile['photoFile']!);

    await uploadTask.then((_) async {
      await storageReference.getDownloadURL().then((urlDownload) async {
        photoURL = await urlDownload;
        debugPrint('URL DOWNLOAD $urlDownload');
      });
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
      String? unMaskNumber = Formatters.unmaskNumber(_whatsapp.text.trim());
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
    userProfile.clear();

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: AutoSizeText(
          'Seja bem vindo!',
          style: Theme.of(context).textTheme.headline4!.copyWith(
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
                                      ? Icon(Icons.person, color: AppColors.white, size: 50)
                                      : Image.file(
                                          userProfile['photoFile']!,
                                          width: 1000,
                                          height: 1000,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            AutoSizeText(
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
                      OutlinedInputText(
                        hintText: 'Como quer ser chamado (Obrigatório)',
                      ),
                      nameHasError ? HintError(message: nameHasErrorMessage) : Container(),
                      SizedBox(height: 15),
                      OutlinedInputText(
                        inputFormatters: [celularMask],
                        labelText: 'Informe seu Whatsapp',
                        hintText: '(XX) X XXXX-XXXX',
                        onChanged: (text) {},
                      ),
                      whatsappHasError! ? HintError(message: whatsappHasErrorMessage) : Container(),
                      SizedBox(height: 15),
                      OutlinedInputText(
                        inputFormatters: [telefoneMask],
                        labelText: 'Informe um telefone fixo',
                        hintText: '(XX) XXXX-XXXX',
                        onChanged: (text) {},
                      ),
                      telefoneHasError ? HintError(message: telefoneHasErrorMessage) : Container(),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment(-0.8, 1),
                        child: AutoSizeText('Escolha sua melhor forma de contato.'),
                      ),
                      StreamBuilder<Object>(
                        builder: (context, snapshot) {
                          return Container(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: Theme.of(context).primaryColor,
                                        groupValue: snapshot.data,
                                        value: 0,
                                        onChanged: (value) {
                                          if (_whatsapp.text.trim().isEmpty) {
                                            setState(() {
                                              whatsappHasErrorMessage =
                                                  'Quando este é seu melhor contato, deve ser preenchido.';
                                              whatsappHasError = true;
                                              telefoneHasError = false;
                                            });
                                          }
                                        },
                                      ),
                                      AutoSizeText('WhatsApp'),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: Colors.orange,
                                        groupValue: snapshot.data,
                                        value: 1,
                                        onChanged: (value) {
                                          if (_telefone.text.trim().isEmpty) {
                                            setState(() {
                                              telefoneHasError = true;
                                              whatsappHasError = false;
                                              telefoneHasErrorMessage =
                                                  'Quando este é seu melhor contato, deve ser preenchido.';
                                            });
                                          }
                                        },
                                      ),
                                      AutoSizeText('Telefone Fixo'),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: AppColors.danger,
                                        groupValue: snapshot.data,
                                        value: 2,
                                        onChanged: (value) {
                                          setState(() {
                                            telefoneHasError = false;
                                            whatsappHasError = false;
                                          });
                                        },
                                      ),
                                      AutoSizeText('E-mail'),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: AppColors.secondary,
                                        groupValue: snapshot.data,
                                        value: 3,
                                        onChanged: (value) {
                                          setState(() {
                                            telefoneHasError = false;
                                            whatsappHasError = false;
                                          });
                                        },
                                      ),
                                      AutoSizeText('Somente pelo chat do aplicativo'),
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
          LoadDarkScreen(visible: finishing, message: 'Finalizando cadastro'),
        ],
      ),
      bottomNavigationBar: ButtonWide(
        color: finishing ? Colors.grey : Theme.of(context).primaryColor,
        text: 'FINALIZAR',
        rounded: false,
        onPressed: finishing
            ? null
            : () async {
                if (_formKey.currentState!.validate()) {
                  if (validatePictureProfile()) {
                    setFinishing(true);
                    await save();
                    setFinishing(false);

                    Navigator.pushReplacementNamed(
                      context,
                      Routes.authOrHome,
                    );
                  }
                }
              },
      ),
      backgroundColor: Colors.blueGrey[50],
    );
  }
}
