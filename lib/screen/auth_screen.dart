import 'package:tiutiu/Exceptions/titiu_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/hint_error.dart';
import 'package:tiutiu/Widgets/input_text.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/providers/auth2.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repeatPassword = TextEditingController();
  bool isNewAccount = false;
  bool isLogging = false;
  bool emailError = false;
  bool passwordError = false;
  bool isToResetPassword = false;
  bool repeatPasswordError = false;
  bool fieldsAreReadyOnly = false;

  @override
  void initState() {
    super.initState();
  }

  void changeLogginStatus(bool status) {
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
    return password.text == repeatPassword.text;
  }

  bool validateEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email.text);
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

    if (password.text.isEmpty && !isToResetPassword) {
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
      if (repeatPassword.text.isEmpty || repeatPassword.text != password.text) {
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
    var auth = Provider.of<Authentication>(context);
    return Scaffold(
      backgroundColor: Color(0XFFA9C27B),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/cao e gato.png',
              fit: BoxFit.cover,
              width: 1000,
              height: 1000,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                    height: 200,
                    width: 420,
                    child: Center(
                      child: Image.asset('assets/Logo.png'),
                    ),
                  ),
                  isNewAccount
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment(-0.9, 1),
                              child: Text(
                                'Crie sua conta gratuitamente.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        )
                      : Container(),
                  InputText.login(
                    placeholder: isToResetPassword
                        ? 'Digite seu email cadastrado'
                        : 'E-mail',
                    onChanged: validateFields,
                    controller: email,
                    readOnly: fieldsAreReadyOnly,
                  ),
                  emailError
                      ? HintError(
                          message: validateEmail()
                              ? '* Campo obrigatório.'
                              : 'E-mail inválido')
                      : Container(),
                  SizedBox(height: 12),
                  isToResetPassword
                      ? Container()
                      : InputText.login(
                          placeholder: 'Senha',
                          controller: password,
                          readOnly: fieldsAreReadyOnly,
                          onChanged: validateFields,
                          isPassword: true,
                        ),
                  passwordError && !isToResetPassword
                      ? HintError()
                      : Container(),
                  SizedBox(height: 12),
                  isNewAccount
                      ? InputText.login(
                          placeholder: 'Repita sua senha',
                          controller: repeatPassword,
                          readOnly: fieldsAreReadyOnly,
                          onChanged: validateFields,
                          isPassword: true,
                        )
                      : Container(),
                  repeatPasswordError ? HintError() : Container(),
                  FlatButton(
                    onPressed: () {
                      print('Redefinir senha');
                      changeResetPasswordStatus(
                          isToResetPassword ? false : true);
                    },
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          !isToResetPassword
                              ? 'Esqueci minha senha'
                              : 'Fazer login',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ButtonWide(
                        text:
                            '${isToResetPassword ? 'RESETAR SENHA' : !isNewAccount ? 'LOGIN' : 'CADASTRE-SE'}',
                        action: () async {
                          try {
                            if (isNewAccount) {
                              if (validateFields()) {
                                if (validatePassword()) {
                                  changeLogginStatus(true);
                                  await auth.createUserWithEmailAndPassword(
                                      email.text.trim(), password.text.trim());
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
                              await auth.passwordReset(email.text);
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
                              await auth.signInWithEmailAndPassword(
                                  email.text, password.text);
                              changeLogginStatus(false);
                            }
                          } on TiuTiuAuthException catch (error) {
                            print('ERROR');
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
                      )
                    ],
                  ),
                  isNewAccount
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            child: Text(
                              'Fazer login',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isNewAccount = !isNewAccount;
                              });
                            },
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 15),
                  !isNewAccount
                      ? Container(
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isNewAccount = true;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'No account?',
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
                                        ' Register now for free.',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                'Or create account with',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 10),
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      changeLogginStatus(true);
                                      auth.loginWithGoogle().then((_) {
                                        changeLogginStatus(false);
                                      });
                                    },
                                    child: Image.asset(
                                      'assets/google.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  FlatButton(
                                    onPressed: () {},
                                    child: Image.asset(
                                      'assets/face.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                  )
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
          isLogging
              ? Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
