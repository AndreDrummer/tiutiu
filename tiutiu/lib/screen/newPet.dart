import 'package:flutter/material.dart';
import '../Widgets/CircleaddImage.dart';
import '../Widgets/InputText.dart';

class NovoPet extends StatefulWidget {  
  @override
  _NovoPetState createState() => _NovoPetState();
}

class _NovoPetState extends State<NovoPet> {
  var params;  
  var kind;  

  @override
  void initState() {
    super.initState();        
  }

  @override
  Widget build(BuildContext context) {
    params = ModalRoute.of(context).settings.arguments;
    kind = params['kind'];
    print(kind);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              'assets/gato2.jpg',
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Colors.transparent,
              // color: Color(0XFFD6D6D6), //Theme.of(context).accentColor,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            kind == 'Donate'
                                ? 'Poste um PET para adoção'
                                : 'Poste um PET Desaparecido',
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CircleAddImage(),
                            CircleAddImage(),
                            CircleAddImage(),
                            CircleAddImage(),
                          ],
                        ),
                        SizedBox(height: 12),
                        InputText(
                          placeholder: 'Nome',
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              width: 100,
                              child: InputText(
                                placeholder: 'Idade',
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: InputText(
                                placeholder: 'Raça',
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: InputText(
                                placeholder: 'Tamanho',
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: InputText(
                                placeholder: 'Cor',
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: InputText(
                                placeholder: 'Saúde',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        InputText(placeholder: 'Descrição', size: 150),
                        // SizedBox(height: 120),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                'CANCELAR',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              child: Text(
                                'POSTAR',
                                style: Theme.of(context).textTheme.button,
                              ),
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
