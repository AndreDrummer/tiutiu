import 'package:google_fonts/google_fonts.dart';
import 'package:tiutiu/core/Exceptions/titiu_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/button_social_login.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:tiutiu/Widgets/input_text.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/features/system/controllers.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repeatPassword = TextEditingController();
  bool isNewAccount = true;
  bool isLogging = false;
  bool emailError = false;
  bool passwordError = false;
  bool isToResetPassword = false;
  bool repeatPasswordError = false;
  bool fieldsAreReadyOnly = false;
  // AdsProvider adsProvider;

  @override
  void setState(fn) {
    super.setState(fn);
  }

  void changeLogginStatus(bool status) {
    if (!mounted) return;
    setState(() {
      if (status) {
        fieldsAreReadyOnly = true;
      } else {
        fieldsAreReadyOnly = false;
      }
      isLogging = status;
    });
  }

  void changeResetPasswordStatus(bool status) {
    setState(() {
      isToResetPassword = status;
    });
  }

  bool validatePassword() {
    return password.text == repeatPassword.text.trim();
  }

  bool validateEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email.text.trim());
  }

  bool validateFields() {
    var fieldsAreValids = true;

    if (!validateEmail()) {
      setState(() {
        emailError = true;
        fieldsAreValids = false;
      });
      return fieldsAreValids;
    } else {
      setState(() {
        emailError = false;
        fieldsAreValids = true;
      });
    }

    if (password.text.trim().isEmpty && !isToResetPassword) {
      setState(() {
        passwordError = true;
        fieldsAreValids = false;
      });
      return fieldsAreValids;
    } else {
      setState(() {
        passwordError = false;
        fieldsAreValids = true;
      });
    }

    if (isNewAccount) {
      if (repeatPassword.text.trim().isEmpty ||
          repeatPassword.text.trim() != password.text.trim()) {
        setState(() {
          repeatPasswordError = true;
          fieldsAreValids = false;
        });
        return fieldsAreValids;
      } else {
        setState(() {
          repeatPasswordError = false;
          fieldsAreValids = true;
        });
      }
    }

    return fieldsAreValids;
  }

  void resetPage() {
    email.clear();
    setState(() {
      isToResetPassword = false;
      changeLogginStatus(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 48.0, 8.0, 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                child: Image.asset('assets/newLogo.webp'),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Tiu,tiu',
                                style: GoogleFonts.miltonianTattoo(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    letterSpacing: 12,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        isNewAccount
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 8.0),
                                child: Align(
                                  alignment: Alignment(-0.9, 1),
                                  child: Text(
                                    'Crie sua conta gratuitamente.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 15),
                      ],
                    ),
                    InputText.login(
                      textCapitalization: TextCapitalization.none,
                      placeholder: isToResetPassword
                          ? 'Digite seu email cadastrado'
                          : 'E-mail',
                      onChanged: (text) => validateFields,
                      controller: email,
                      readOnly: fieldsAreReadyOnly,
                    ),
                    emailError
                        ? HintError(
                            message: validateEmail()
                                ? '* Campo obrigatório.'
                                : 'E-mail inválido')
                        : Container(),
                    SizedBox(height: 10),
                    isToResetPassword
                        ? Container()
                        : InputText.login(
                            placeholder: 'Senha',
                            textCapitalization: TextCapitalization.none,
                            controller: password,
                            readOnly: fieldsAreReadyOnly,
                            onChanged: (text) => validateFields,
                            isPassword: true,
                          ),
                    passwordError && !isToResetPassword
                        ? HintError()
                        : Container(),
                    SizedBox(height: 10),
                    isNewAccount
                        ? InputText.login(
                            placeholder: 'Repita sua senha',
                            controller: repeatPassword,
                            readOnly: fieldsAreReadyOnly,
                            textCapitalization: TextCapitalization.none,
                            onChanged: (text) => validateFields,
                            isPassword: true,
                          )
                        : Container(),
                    repeatPasswordError ? HintError() : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Align(
                        alignment: Alignment(-0.95, 1),
                        child: InkWell(
                          onTap: () {
                            if (isNewAccount) {
                              setState(() {
                                isNewAccount = !isNewAccount;
                              });
                            } else {
                              changeResetPasswordStatus(
                                  isToResetPassword ? false : true);
                            }
                          },
                          child: isNewAccount
                              ? Text(
                                  'Fazer login',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : Text(
                                  !isToResetPassword
                                      ? 'Esqueci minha senha'
                                      : 'Fazer login',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ButtonWide(
                            text:
                                '${isToResetPassword ? 'RESETAR SENHA' : !isNewAccount ? 'LOGIN' : 'CADASTRE-SE'}',
                            action: () async {
                              try {
                                if (isNewAccount) {
                                  if (validateFields()) {
                                    if (validatePassword()) {
                                      changeLogginStatus(true);
                                      await authController
                                          .createUserWithEmailAndPassword(
                                              email.text.trim(),
                                              password.text.trim());
                                      changeLogginStatus(false);
                                      setState(() {
                                        isNewAccount = !isNewAccount;
                                      });
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (context) => PopUpMessage(
                                            title: 'Erro',
                                            warning: true,
                                            confirmText: 'OK',
                                            confirmAction: () =>
                                                Navigator.pop(context),
                                            message: 'Senhas não conferem!'),
                                      );
                                      changeLogginStatus(false);
                                    }
                                  } else {
                                    print('invalidos');
                                  }
                                } else if (isToResetPassword) {
                                  changeLogginStatus(true);
                                  await authController
                                      .passwordReset(email.text.trim());
                                  await showDialog(
                                    context: context,
                                    builder: (context) => PopUpMessage(
                                      title: 'E-mail enviado',
                                      message:
                                          'Um link com instruções para redefinir sua senha foi enviado para o e-mail informado.',
                                    ),
                                  ).then((_) => resetPage());
                                } else if (validateFields()) {
                                  changeLogginStatus(true);
                                  await authController
                                      .signInWithEmailAndPassword(
                                    email.text.trim(),
                                    password.text.trim(),
                                  );
                                  changeLogginStatus(false);
                                }
                              } on TiuTiuAuthException catch (error) {
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
                                changeLogginStatus(false);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    !isToResetPassword
                        ? Container(
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isNewAccount = true;
                                    });
                                  },
                                  child: !isNewAccount
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Novo usuário?',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              margin: const EdgeInsets.all(4.0),
                                              child: Text(
                                                ' crie sua conta grátis.',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                                SizedBox(height: 14),
                                Text(
                                  ' acesse com',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        changeLogginStatus(true);
                                        authController
                                            .loginWithGoogle()
                                            .then((_) {
                                          changeLogginStatus(false);
                                          if (canPop != null &&
                                              canPop == true) {
                                            Navigator.popUntil(context,
                                                ModalRoute.withName('/'));
                                          }
                                        });
                                      },
                                      child: ButtonSocialLogin(
                                        imageUrl: 'assets/google.webp',
                                        text: 'Google',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: () async {
                                        try {
                                          changeLogginStatus(true);
                                          await authController
                                              .signInWithFacebook();
                                          if (canPop != null &&
                                              canPop == true) {
                                            Navigator.popUntil(context,
                                                ModalRoute.withName('/'));
                                          }
                                        } on TiuTiuAuthException catch (error) {
                                          await showDialog(
                                            context: context,
                                            builder: (context) => PopUpMessage(
                                              title: 'Falha na autenticação',
                                              confirmText: 'OK',
                                              confirmAction: () =>
                                                  Navigator.pop(context),
                                              error: true,
                                              message: error.toString(),
                                            ),
                                          );
                                          changeLogginStatus(false);
                                        }
                                      },
                                      child: ButtonSocialLogin(
                                        imageUrl: 'assets/face.webp',
                                        text: 'Facebook',
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            LoadDarkScreen(
              show: isLogging,
              message: 'Fazendo login',
            )
          ],
        ),
      ),
    );
  }
}
