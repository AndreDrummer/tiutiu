import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/divider.dart';
import 'package:tiutiu/Widgets/input_text.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/utils/formatter.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';

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
  bool deleting = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _whatsAppController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();

  TextEditingController _newPassword = TextEditingController();
  TextEditingController _repeatNewPassword = TextEditingController();

  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _personalDataFormKey = GlobalKey<FormState>();
  UserProvider userProvider;
  UserController userController = UserController();
  Authentication auth;
  AdsProvider adsProvider;

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
    FirebaseAdMob.instance.initialize(appId: Constantes.ADMOB_APP_ID);
    userProvider = Provider.of(context, listen: false);
    if (userProvider.displayName != null) _nameController.text = userProvider.displayName;
    if (userProvider.whatsapp != null) _whatsAppController.text = userProvider.whatsapp;
    if (userProvider.telefone != null) _telefoneController.text = userProvider.telefone;
    if (userProvider.photoURL != null) photoURL = userProvider.photoURL;
    if (userProvider.photoBACK != null) photoBACK = userProvider.photoBACK;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    auth = Provider.of(context);
    adsProvider = Provider.of(context);
    super.didChangeDependencies();
  }

  void changeSaveFormStatus(bool status, {bool deleting = false}) {
    setState(() {
      this.isSavingForm = status;
      this.deleting = deleting;
    });
  }

  void showMessageWarningUpdatePasswordOrDeleteAccount() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: PopUpMessage(
        confirmAction: () {
          auth.signOut();
          userProvider.clearUserDataOnSignOut();
          userProvider.changeRecentlyAuthenticated(true);
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
        confirmText: 'Deslogar Agora',
        denyAction: () {
          Navigator.pop(context);
          changeSaveFormStatus(false);
        },
        denyText: 'Não',
        warning: true,
        message: 'Esta operação é confidencial e requer autenticação recente. Faça login novamente antes de tentar novamente esta solicitação.',
        title: 'Faça login novamente',
      ),
    );
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
      storageReferenceProfile = FirebaseStorage.instance.ref().child('${auth.firebaseUser.uid}').child('avatar/foto_perfil');

      storageReferenceProfile.delete();
      uploadTask = storageReferenceProfile.putFile(userProfile['photoFile']);

      await uploadTask.onComplete;
      await storageReferenceProfile.getDownloadURL().then((urlDownload) async {
        photoURL = await urlDownload;
        print('URL DOWNLOAD $urlDownload');
      });
    }

    if (userProfile['photoFileBack'] != null) {
      storageReferenceback = FirebaseStorage.instance.ref().child('${auth.firebaseUser.uid}').child('avatar/foto_fundo');

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
    return _newPassword.text.trim().isNotEmpty && _repeatNewPassword.text.trim().isNotEmpty;
  }

  bool validatePersonalData() {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);

    bool validWhatsapp = _whatsAppController.text.trim().isNotEmpty && _whatsAppController.text.trim().contains('-') && regExp.hasMatch(_whatsAppController.text.trim().split('-')[1]);

    bool validTelefone = _telefoneController.text.trim().isNotEmpty && _telefoneController.text.trim().contains('-') && regExp.hasMatch(_telefoneController.text.trim().split('-')[1]);

    if (userProvider.getBetterContact == 0) {
      var serializedWhatsappNumber = Formatter.unmaskNumber(_telefoneController.text?.trim());
      if (serializedWhatsappNumber == null) {
        _telefoneController.clear();
      }
      if (!validWhatsapp) {
        setState(() {
          whatsappHasError = true;
          _whatsAppController.text = 'Quando este é o seu melhor contato, deve ser preenchido!';
        });
        return false;
      }
    }

    if (userProvider.getBetterContact == 1) {
      var serializedWhatsappNumber = Formatter.unmaskNumber(_whatsAppController.text?.trim());
      if (serializedWhatsappNumber == null) {
        _whatsAppController.clear();
      }
      if (!validTelefone) {
        setState(() {
          telefoneHasError = true;
          _telefoneController.text = 'Quando este é o seu melhor contato, deve ser preenchido!';
        });
        return false;
      }
    }

    if (_telefoneController.text.trim().isNotEmpty) {
      if (!_telefoneController.text.trim().contains('-'))
        setState(() {
          telefoneHasError = true;
          _telefoneController.text = 'Insira um número válido ou deixe vazio';
        });
      return _telefoneController.text.trim().contains('-');
    }

    if (_whatsAppController.text.trim().isNotEmpty) {
      if (!_whatsAppController.text.trim().contains('-'))
        setState(() {
          whatsappHasError = true;
          _whatsAppController.text = 'Insira um número válido ou deixe vazio';
        });
      return _whatsAppController.text.trim().contains('-');
    }
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
          await auth.firebaseUser.updatePassword(_newPassword.text?.trim());
        } catch (error) {
          changeSaveFormStatus(false);
          isToShowDialog ? showMessageWarningUpdatePasswordOrDeleteAccount() : SizedBox();
          throw '';
        }
      }

      changeSaveFormStatus(true);
      if (userProfile.isNotEmpty) {
        await uploadPhotos();
      }

      await userController.updateUser(userProvider.uid, {
        'displayName': _nameController.text?.trim(),
        'uid': auth.firebaseUser.uid,
        'photoURL': userProfile.isNotEmpty ? photoURL : userProvider.photoURL,
        'photoBACK': userProfile.isNotEmpty ? photoBACK : userProvider.photoBACK,
        'phoneNumber': _whatsAppController.text?.trim(),
        'landline': _telefoneController.text?.trim(),
        'betterContact': userProvider.getBetterContact,
        'email': auth.firebaseUser.email,
        'createdAt': userProvider.createdAt
      });

      userProvider.changeDisplayName(_nameController.text?.trim());
      userProvider.changeBetterContact(userProvider.getBetterContact);
      userProvider.changeWhatsapp(_whatsAppController.text?.trim());
      userProvider.changeTelefone(_telefoneController.text?.trim());
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
    bool conditionsToRemoveBackPhoto = !perfil && userProfile.containsKey('photoFileBack');

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            FlatButton(
              child: Text(
                'Tirar uma foto',
                style: Theme.of(context).textTheme.headline1.copyWith(
                      color: Colors.black,
                    ),
              ),
              onPressed: () {
                Navigator.pop(context);
                selectImage(
                  ImageSource.camera,
                  perfil: perfil,
                );
              },
            ),
            FlatButton(
              child: Text(
                'Abrir galeria',
                style: Theme.of(context).textTheme.headline1.copyWith(
                      color: Colors.black,
                    ),
              ),
              onPressed: () {
                Navigator.pop(context);
                selectImage(
                  ImageSource.gallery,
                  perfil: perfil,
                );
              },
            ),
            conditionsToRemoveBackPhoto
                ? FlatButton(
                    child: Text(
                      'Remover foto',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    onPressed: () {
                      setState(() {
                        userProfile.remove('photoFileBack');
                      });

                      userProvider.changePhotoBack(null);
                      Navigator.pop(context);
                    },
                  )
                : Container()
          ],
        );
      },
    );
  }

  void deleteAccountt() {}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    void navigateToHomeAfterDeleteAccount() {
      showDialog(
        context: context,
        builder: (context) =>
            PopUpMessage(confirmAction: () => Navigator.popUntil(context, ModalRoute.withName('/')), confirmText: 'OK', message: 'Sua conta Tiu, tiu foi deletada pra sempre!', title: 'Conta Excluída'),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (_personalDataFormKey.currentState.validate()) {
          return Future.value(true);
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          'Configurações',
          style: TextStyle(fontSize: 20),
        )),
        backgroundColor: Colors.blueGrey[50],
        body: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            openModalSelectMedia(context, false);
                          },
                          child: Card(
                            elevation: 6.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 200,
                              width: double.infinity,
                              child: Opacity(
                                child: userProfile['photoFileBack'] == null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: FadeInImage(
                                          placeholder: AssetImage('assets/fundo.jpg'),
                                          image: NetworkImage(
                                            userProvider.photoBACK ?? '',
                                          ),
                                          fit: BoxFit.fill,
                                          width: 1000,
                                          height: 1000,
                                        ),
                                      )
                                    : Image.file(
                                        userProfile['photoFileBack'],
                                        width: 1000,
                                        height: 1000,
                                        fit: BoxFit.cover,
                                      ),
                                opacity: 0.15,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black38,
                            ),
                            height: 25,
                            child: FlatButton(
                              onPressed: () => openModalSelectMedia(context, false),
                              child: Text(
                                'Toque p/ alterar plano de fundo',
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                              ),
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
                                child: Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.black38,
                                    child: ClipOval(
                                      child: userProfile['photoFile'] == null
                                          ? userProvider.photoURL != null
                                              ? FadeInImage(
                                                  placeholder: AssetImage('assets/profileEmpty.png'),
                                                  image: NetworkImage(
                                                    userProvider.photoURL,
                                                  ),
                                                  fit: BoxFit.cover,
                                                  width: 1000,
                                                  height: 100,
                                                )
                                              : Icon(Icons.person, color: Colors.white70, size: 50)
                                          : Image.file(
                                              userProfile['photoFile'],
                                              width: 1000,
                                              height: 1000,
                                              fit: BoxFit.cover,
                                            ),
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
                      height: MediaQuery.of(context).size.height / 2,
                      child: Form(
                        key: _personalDataFormKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              child: Column(
                                children: [
                                  _textField(
                                    controller: _nameController,
                                    fieldLabel: 'Nome',
                                    isFieldEditing: isNameEditing,
                                    onPressed: () {
                                      if (isNameEditing) {
                                        userProvider.changeDisplayName(_nameController.text?.trim());
                                        changeFieldEditingState(false, 'isNameEditing');
                                      } else {
                                        changeFieldEditingState(true, 'isNameEditing');
                                      }
                                    },
                                  ),
                                  _textField(
                                    controller: _whatsAppController,
                                    fieldLabel: 'WhatsApp',
                                    isFieldEditing: isWhatsAppEditing,
                                    onFieldSubmitted: (_) => validatePersonalData(),
                                    inputFormatters: [celularMask],
                                    validator: (String value) => validarCelular(value),
                                    keyboardType: TextInputType.number,
                                    fieldHasError: whatsappHasError,
                                    onPressed: () {
                                      if (isWhatsAppEditing) {
                                        userProvider.changeWhatsapp(_whatsAppController.text?.trim());
                                        if (_personalDataFormKey.currentState.validate()) {
                                          changeFieldEditingState(false, 'isWhatsAppEditing');
                                        }
                                      } else {
                                        _whatsAppController.text = userProvider.whatsapp;
                                        changeFieldEditingState(true, 'isWhatsAppEditing');
                                      }
                                    },
                                  ),
                                  _textField(
                                    controller: _telefoneController,
                                    fieldLabel: 'Telefone Fixo',
                                    isFieldEditing: isTelefoneEditing,
                                    onFieldSubmitted: (_) => validatePersonalData(),
                                    inputFormatters: [telefoneMask],
                                    validator: (String value) => validarTelefone(value),
                                    keyboardType: TextInputType.number,
                                    fieldHasError: telefoneHasError,
                                    onPressed: () {
                                      if (isTelefoneEditing) {
                                        userProvider.changeTelefone(_telefoneController.text?.trim());
                                        if (_personalDataFormKey.currentState.validate()) {
                                          changeFieldEditingState(false, 'isTelefoneEditing');
                                        }
                                      } else {
                                        _telefoneController.text = userProvider.telefone;
                                        changeFieldEditingState(true, 'isTelefoneEditing');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            CustomDivider(text: 'Sua melhor forma de contato'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StreamBuilder(
                                stream: userProvider.betterContact,
                                builder: (context, snapshot) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 6.0,
                                    child: Container(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              radio(
                                                groupValue: snapshot.data,
                                                labelText: 'WhatsApp',
                                                onTap: () => userProvider.changeBetterContact(0),
                                                value: 0,
                                                color: Colors.green,
                                              ),
                                              radio(
                                                groupValue: snapshot.data,
                                                labelText: 'Telefone Fixo',
                                                onTap: () => userProvider.changeBetterContact(1),
                                                value: 1,
                                                color: Colors.orange,
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              radio(
                                                groupValue: snapshot.data,
                                                labelText: 'E-mail',
                                                onTap: () => userProvider.changeBetterContact(2),
                                                value: 2,
                                                color: Colors.red,
                                              ),
                                              radio(
                                                groupValue: snapshot.data,
                                                labelText: 'Só pelo chatt',
                                                onTap: () => userProvider.changeBetterContact(3),
                                                value: 3,
                                                color: Colors.purple,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomDivider(text: 'Sobre a conta'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6.0,
                        child: Form(
                          key: _passwordFormKey,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                InputText(
                                  isPassword: true,
                                  hintText: 'Nova Senha',
                                  controller: _newPassword,
                                  validator: (String value) {
                                    if (value.isEmpty && _repeatNewPassword.text.trim().isEmpty) {
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
                                    if (value.isEmpty && _newPassword.text.trim().isEmpty) {
                                      return null;
                                    }
                                    if (value != _newPassword.text?.trim()) {
                                      return 'Senhas não conferem';
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.red,
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => PopUpMessage(
                              title: 'Excluir Conta',
                              message: 'DESEJA DELETAR PERMANENTEMENTE SUA CONTA ?',
                              confirmText: 'Deletar minha conta',
                              confirmAction: () async {
                                if (userProvider.recentlyAuthenticated) {
                                  Navigator.pop(context);
                                  changeSaveFormStatus(true, deleting: true);
                                  try {
                                    await userController.deleteUserAccount(auth, userProvider.userReference);
                                    navigateToHomeAfterDeleteAccount();
                                  } catch (error) {
                                    changeSaveFormStatus(false);
                                    showMessageWarningUpdatePasswordOrDeleteAccount();
                                    throw '$error';
                                  }
                                  changeSaveFormStatus(false);
                                } else {
                                  Navigator.pop(context);
                                  showMessageWarningUpdatePasswordOrDeleteAccount();
                                }
                              },
                              denyText: 'NÃO',
                              denyAction: () => Navigator.pop(context),
                            ),
                          );
                        },
                        child: Text(
                          'DELETAR MINHA CONTA',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    adsProvider.getCanShowAds ? adsProvider.bannerAdMob(adId: adsProvider.bottomAdId) : Container(),
                    SizedBox(height: height < 500 ? 210 : 0)
                  ],
                ),
              ),
            ),
            LoadDarkScreen(
              message: !deleting ? 'Salvando informações' : 'Deletando conta Tiu, tiu...',
              show: isSavingForm,
            ),
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

  Widget _textField({
    TextEditingController controller,
    String fieldLabel,
    bool isFieldEditing,
    Function() onPressed,
    Function(String) onFieldSubmitted,
    List<TextInputFormatter> inputFormatters,
    Function(String) validator,
    TextInputType keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    bool fieldHasError = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6.0,
      child: ListTile(
        title: Text(fieldLabel, style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black)),
        subtitle: isFieldEditing
            ? TextFormField(
                cursorColor: Colors.black,
                textCapitalization: textCapitalization,
                style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black54, fontWeight: FontWeight.w300),
                onFieldSubmitted: onFieldSubmitted,
                inputFormatters: inputFormatters,
                validator: validator,
                keyboardType: keyboardType,
                controller: controller,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                ),
              )
            : Text(controller.text?.trim(), style: fieldHasError ? Theme.of(context).textTheme.headline1.copyWith(color: Colors.red) : null),
        trailing: IconButton(
          icon: isFieldEditing ? Icon(Icons.save) : Icon(Icons.mode_edit),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget radio({String labelText, dynamic groupValue, Function() onTap, dynamic value, Color color}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        child: Row(
          children: [
            Radio(
              activeColor: color,
              groupValue: groupValue,
              value: value,
              onChanged: (value) {
                onTap();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(labelText),
            ),
          ],
        ),
      ),
    );
  }
}
