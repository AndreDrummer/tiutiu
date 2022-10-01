import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/Widgets/outline_input_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiutiu/Widgets/divider.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  String? photoBACK;
  File? imageFile0;
  File? imageFile1;
  String? photoURL;

  Map<String, File> userProfile = {};

  bool isWhatsAppEditing = false;
  bool isTelefoneEditing = false;
  bool isNameEditing = false;
  int? betterContact;

  bool isSavingForm = false;
  bool deleting = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _whatsAppController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();

  TextEditingController _newPassword = TextEditingController();
  TextEditingController _repeatNewPassword = TextEditingController();

  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _personalDataFormKey = GlobalKey<FormState>();

  // AdsProvider adsProvider;

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

  String? validarCelular(String value) {
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

  String? validarTelefone(String value) {
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
    // FirebaseAdMob.instance.initialize(appId: Constantes.ADMOB_APP_ID);
    if (tiutiuUserController.tiutiuUser.displayName != null)
      _nameController.text = tiutiuUserController.tiutiuUser.displayName!;
    if (tiutiuUserController.tiutiuUser.phoneNumber != null)
      _whatsAppController.text = tiutiuUserController.tiutiuUser.phoneNumber!;
    if (tiutiuUserController.tiutiuUser.phoneNumber != null)
      _telefoneController.text = tiutiuUserController.tiutiuUser.phoneNumber!;
    if (tiutiuUserController.tiutiuUser.avatar != null)
      photoURL = tiutiuUserController.tiutiuUser.avatar;
    if (tiutiuUserController.tiutiuUser.photoBACK != null)
      photoBACK = tiutiuUserController.tiutiuUser.photoBACK;
    super.initState();
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
        builder: ((context) => PopUpMessage(
              confirmAction: () {
                authController.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));
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
            )));
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
    Reference storageReferenceProfile;
    Reference storageReferenceback;
    UploadTask uploadTask;

    if (userProfile['photoFile'] != null) {
      storageReferenceProfile = FirebaseStorage.instance
          .ref()
          .child('${tiutiuUserController.tiutiuUser.uid}')
          .child('avatar/foto_perfil');

      storageReferenceProfile.delete();
      uploadTask = storageReferenceProfile.putFile(userProfile['photoFile']!);

      await uploadTask.then((_) async {
        await storageReferenceProfile
            .getDownloadURL()
            .then((urlDownload) async {
          photoURL = await urlDownload;
          print('URL DOWNLOAD $urlDownload');
        });
      });
    }

    if (userProfile['photoFileBack'] != null) {
      storageReferenceback = FirebaseStorage.instance
          .ref()
          .child('${tiutiuUserController.tiutiuUser.uid}')
          .child('avatar/foto_fundo');

      storageReferenceback.delete();
      uploadTask = storageReferenceback.putFile(userProfile['photoFileBack']!);

      await uploadTask.then((_) async {
        await storageReferenceback.getDownloadURL().then((urlDownload) async {
          photoBACK = await urlDownload;
          print('URL DOWNLOAD $urlDownload');
        });
      });
    }

    return Future.value();
  }

  bool passwordWasTouched() {
    return _newPassword.text.trim().isNotEmpty &&
        _repeatNewPassword.text.trim().isNotEmpty;
  }

  bool validatePersonalData() {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);

    bool validWhatsapp = _whatsAppController.text.trim().isNotEmpty &&
        _whatsAppController.text.trim().contains('-') &&
        regExp.hasMatch(_whatsAppController.text.trim().split('-')[1]);

    bool validTelefone = _telefoneController.text.trim().isNotEmpty &&
        _telefoneController.text.trim().contains('-') &&
        regExp.hasMatch(_telefoneController.text.trim().split('-')[1]);

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
    if (_passwordFormKey.currentState!.validate() && validatePersonalData()) {
      if (passwordWasTouched()) {
        changeSaveFormStatus(true);
        try {} catch (error) {
          changeSaveFormStatus(false);
          isToShowDialog
              ? showMessageWarningUpdatePasswordOrDeleteAccount()
              : SizedBox();
          throw '';
        }
      }

      changeSaveFormStatus(true);
      if (userProfile.isNotEmpty) {
        await uploadPhotos();
      }

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
    dynamic image = await picker.pickImage(source: source);
    image = File(image.path);

    if (perfil) {
      setState(
        () {
          imageFile0 = image;
          userProfile.remove('photoFile');
          userProfile.putIfAbsent('photoFile', () => imageFile0!);
        },
      );
    } else {
      setState(
        () {
          imageFile1 = image;
          userProfile.remove('photoFileBack');
          userProfile.putIfAbsent('photoFileBack', () => imageFile1!);
        },
      );
    }
  }

  void openModalSelectMedia(BuildContext context, bool perfil) {
    bool conditionsToRemoveBackPhoto =
        !perfil && userProfile.containsKey('photoFileBack');

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            TextButton(
              child: AutoSizeText(
                'Tirar uma foto',
                style: Theme.of(context).textTheme.headline4!.copyWith(
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
            TextButton(
              child: AutoSizeText(
                'Abrir galeria',
                style: Theme.of(context).textTheme.headline4!.copyWith(
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
                ? TextButton(
                    child: AutoSizeText(
                      'Remover foto',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    onPressed: () {
                      setState(() {
                        userProfile.remove('photoFileBack');
                      });

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
        builder: (context) => PopUpMessage(
            confirmAction: () =>
                Navigator.popUntil(context, ModalRoute.withName('/')),
            confirmText: 'OK',
            message: 'Sua conta Tiu, tiu foi deletada pra sempre!',
            title: 'Conta Excluída'),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (_personalDataFormKey.currentState!.validate()) {
          return Future.value(true);
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
            title: AutoSizeText(
          'Configurações',
          style: TextStyle(fontSize: 20),
        )),
        backgroundColor: Colors.blueGrey[50],
        body: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: AssetHandle.getImage(
                                            tiutiuUserController
                                                    .tiutiuUser.photoBACK ??
                                                ''),
                                      )
                                    : Image.file(
                                        userProfile['photoFileBack']!,
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
                            child: TextButton(
                              onPressed: () =>
                                  openModalSelectMedia(context, false),
                              child: AutoSizeText(
                                'Toque p/ alterar plano de fundo',
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
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
                                          ? tiutiuUserController
                                                      .tiutiuUser.avatar !=
                                                  null
                                              ? AssetHandle.getImage(
                                                  tiutiuUserController
                                                      .tiutiuUser.avatar!)
                                              : Icon(Icons.person,
                                                  color: AppColors.white,
                                                  size: 50)
                                          : Image.file(
                                              userProfile['photoFile']!,
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              child: Column(
                                children: [
                                  _textField(
                                    controller: _nameController,
                                    fieldLabel: 'Nome',
                                    isFieldEditing: isNameEditing,
                                    onPressed: () {
                                      if (isNameEditing) {
                                        changeFieldEditingState(
                                            false, 'isNameEditing');
                                      } else {
                                        changeFieldEditingState(
                                            true, 'isNameEditing');
                                      }
                                    },
                                  ),
                                  _textField(
                                    controller: _whatsAppController,
                                    fieldLabel: 'WhatsApp',
                                    isFieldEditing: isWhatsAppEditing,
                                    onFieldSubmitted: (_) =>
                                        validatePersonalData(),
                                    inputFormatters: [celularMask],
                                    validator: (value) =>
                                        validarCelular(value!),
                                    keyboardType: TextInputType.number,
                                    fieldHasError: whatsappHasError,
                                    onPressed: () {
                                      if (isWhatsAppEditing) {
                                        if (_personalDataFormKey.currentState!
                                            .validate()) {
                                          changeFieldEditingState(
                                              false, 'isWhatsAppEditing');
                                        }
                                      } else {
                                        _whatsAppController.text =
                                            tiutiuUserController
                                                .tiutiuUser.phoneNumber!;
                                        changeFieldEditingState(
                                            true, 'isWhatsAppEditing');
                                      }
                                    },
                                  ),
                                  _textField(
                                    controller: _telefoneController,
                                    fieldLabel: 'Telefone Fixo',
                                    isFieldEditing: isTelefoneEditing,
                                    onFieldSubmitted: (_) =>
                                        validatePersonalData(),
                                    inputFormatters: [telefoneMask],
                                    validator: (value) =>
                                        validarTelefone(value!),
                                    keyboardType: TextInputType.number,
                                    fieldHasError: telefoneHasError,
                                    onPressed: () {
                                      if (isTelefoneEditing) {
                                        if (_personalDataFormKey.currentState!
                                            .validate()) {
                                          changeFieldEditingState(
                                              false, 'isTelefoneEditing');
                                        }
                                      } else {
                                        _telefoneController.text =
                                            tiutiuUserController
                                                .tiutiuUser.phoneNumber!;
                                        changeFieldEditingState(
                                            true, 'isTelefoneEditing');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            CustomDivider(text: 'Sua melhor forma de contato'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StreamBuilder<int>(
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              radio(
                                                groupValue: snapshot.data,
                                                labelText: 'WhatsApp',
                                                value: 0,
                                                color: AppColors.primary,
                                              ),
                                              radio(
                                                groupValue: snapshot.data,
                                                labelText: 'Telefone Fixo',
                                                value: 1,
                                                color: Colors.orange,
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              radio(
                                                groupValue: snapshot.data,
                                                labelText: 'E-mail',
                                                value: 2,
                                                color: AppColors.danger,
                                              ),
                                              radio(
                                                groupValue: snapshot.data,
                                                labelText: 'Só pelo chat',
                                                value: 3,
                                                color: AppColors.secondary,
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
                                OutlinedInputText(
                                  isPassword: true,
                                  hintText: 'Nova Senha',
                                ),
                                SizedBox(height: 15),
                                OutlinedInputText(
                                  isPassword: true,
                                  hintText: 'Repita a nova senha',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          primary: AppColors.danger,
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => PopUpMessage(
                              title: 'Excluir Conta',
                              message:
                                  'DESEJA DELETAR PERMANENTEMENTE SUA CONTA ?',
                              confirmText: 'Deletar minha conta',
                              confirmAction: () async {
                                if (tiutiuUserController.initialized) {
                                  Navigator.pop(context);
                                  changeSaveFormStatus(true, deleting: true);
                                  try {
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
                        child: AutoSizeText(
                          'DELETAR MINHA CONTA',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                    // adsProvider.getCanShowAds
                    // // ? adsProvider.bannerAdMob(adId: adsProvider.bottomAdId)
                    // : Container(),
                    SizedBox(height: height < 500 ? 210 : 0)
                  ],
                ),
              ),
            ),
            LoadDarkScreen(
              message: !deleting
                  ? 'Salvando informações'
                  : 'Deletando conta Tiu, tiu...',
              visible: isSavingForm,
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
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Function(String)? onFieldSubmitted,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool fieldHasError = false,
    bool isFieldEditing = false,
    Function()? onPressed,
    String? fieldLabel,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6.0,
      child: ListTile(
        title: AutoSizeText(fieldLabel!,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black)),
        subtitle: isFieldEditing
            ? TextFormField(
                cursorColor: Colors.black,
                textCapitalization: textCapitalization,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.black54, fontWeight: FontWeight.w300),
                onFieldSubmitted: onFieldSubmitted,
                inputFormatters: inputFormatters,
                validator: validator,
                keyboardType: keyboardType,
                controller: controller,
                decoration: InputDecoration(
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                ),
              )
            : AutoSizeText(controller!.text.trim(),
                style: fieldHasError
                    ? Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: AppColors.danger)
                    : null),
        trailing: IconButton(
          icon: isFieldEditing ? Icon(Icons.save) : Icon(Icons.mode_edit),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget radio({
    Function()? onTap,
    String? labelText,
    int? groupValue,
    int? value,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
          children: [
            Radio<int>(
              activeColor: color,
              groupValue: groupValue,
              value: value!,
              onChanged: (_) {
                onTap?.call();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AutoSizeText(labelText!),
            ),
          ],
        ),
      ),
    );
  }
}
