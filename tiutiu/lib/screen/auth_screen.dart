import 'package:tiutiu/Exceptions/auth_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/input_text.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/providers/auth.dart';

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

  @override
  void initState() {
    super.initState();
  }

  void changeLogginStatus(bool status) {
    setState(() {
      isLogging = status;
    });
  }

  bool validatePassword() {
    return password.text == repeatPassword.text;
  }

  @override
  Widget build(BuildContext context) {    
    var auth = Provider.of<Auth>(context);
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
                      margin: const EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 0.0),
                      height: 200,
                      width: 420,
                      child: Center(
                        child: Image.asset('assets/logo.png'),
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
                      placeholder: 'E-mail',
                      controller: email,
                    ),
                    SizedBox(height: 12),
                    InputText.login(
                      placeholder: 'Senha',
                      controller: password,
                      isPassword: true,
                    ),
                    SizedBox(height: 12),
                    isNewAccount
                        ? InputText.login(
                            placeholder: 'Repita sua senha',
                            controller: repeatPassword,
                            isPassword: true,
                          )
                        : Container(),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonWide(
                          text: '${!isNewAccount ? 'LOGIN' : 'CADASTRE-SE'}',
                          action: () async {
                            changeLogginStatus(true);
                            try {
                              if (isNewAccount) {
                                if (validatePassword()) {
                                  await auth.signup(email.text.trim(), password.text.trim());
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
                                        message: 'Senhas não conferem!'),
                                  );
                                  changeLogginStatus(false);
                                }
                              } else {
                                await auth.login(email.text, password.text);
                                changeLogginStatus(false);
                              }
                            } on AuthException catch (error) {
                              print('ERROR');
                              await showDialog(
                                context: context,
                                builder: (context) => PopUpMessage(
                                  title: 'Falha na autenticação',
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
                                      onPressed: () {},
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
