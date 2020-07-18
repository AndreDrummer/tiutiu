import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/inputText.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repeatPassword = TextEditingController();
  // Auth auth;
  bool isNewAccount = false;

  @override
  void initState() {
    super.initState();
    // auth = Provider.of<Auth>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                      height: 200,
                      width: 420,
                      child: Center(
                        child: Image.asset('assets/logo.png'),
                      ),
                    ),
                    isNewAccount ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment(-0.9, 1),
                          child: Text(
                            "Crie sua conta gratuitamente.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ) : Container(),
                    InputText.login(
                      placeholder: 'E-mail',
                    ),
                    SizedBox(height: 12),
                    InputText.login(
                      placeholder: 'Senha',
                      isPassword: true,
                    ),
                    SizedBox(height: 12),
                    isNewAccount
                        ? InputText.login(
                            placeholder: 'Repita sua senha',
                            isPassword: true,
                          )
                        : Container(),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            if(isNewAccount) {
                              setState(() {
                                isNewAccount = !isNewAccount;
                              });
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 260,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.green),
                            child: Center(
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                        "No account?",
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
                                          " Register now for free.",
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
                                  "Or create account with",
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
            )
          ],
        ),
      ),
    );
  }
}
