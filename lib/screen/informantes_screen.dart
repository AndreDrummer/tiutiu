import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/backend/Model/interested_model.dart';
import 'package:tiutiu/providers/user_infos_interests.dart';

class InformantesScreen extends StatefulWidget {
  @override
  _InformantesScreenState createState() => _InformantesScreenState();
}

class _InformantesScreenState extends State<InformantesScreen> {
  UserInfoOrAdoptInterestsProvider userInfoOrAdoptInterestsProvider;

  @override
  void didChangeDependencies() {
    userInfoOrAdoptInterestsProvider =
        Provider.of<UserInfoOrAdoptInterestsProvider>(context);
    super.didChangeDependencies();
  }

  Future<DocumentSnapshot> loadInformateInfo(
      DocumentReference infoReference) async {
    return await infoReference.get();
  }

  @override
  Widget build(BuildContext context) {
    final informante =
        ModalRoute.of(context).settings.arguments as InterestedModel;

    return Scaffold(
      appBar: AppBar(title: Text('Pessoas que viram PETNOME')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: userInfoOrAdoptInterestsProvider.interested,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage(
                messageLoading: 'Carregando lista de informantes',
                circle: true,
              );
            }

            if (!snapshot.hasData || snapshot.data.isEmpty) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ninguém ainda informou sobre PETNOME',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                          ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.sentiment_dissatisfied)
                  ],
                ),
              );
            }

            return FutureBuilder<Object>(
              future: loadInformateInfo(informante.userReference),
              builder: (context, snapshot) {
                if (snapshot != null && !snapshot.hasData) {
                  print(snapshot.data);
                }
                return ListView.builder(
                  itemCount: 3,
                  itemBuilder: (_, index) {
                    return _cardInfo(
                        informanteImage: '',
                        informanteLat: 0,
                        informanteLng: 0,
                        informanteName: 'NOME AZUL CAVALO',
                        petName: 'PETNOME');
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _cardInfo({
    String informanteName,
    String informanteImage,
    String petName,
    double informanteLat,
    double informanteLng,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5),
              width: 100,
              // height: 100,
              child: Column(
                children: [
                  FadeInImage(
                    placeholder: AssetImage('assets/profileEmpty.png'),
                    image: informanteImage != null
                        ? NetworkImage(
                            informanteImage,
                          )
                        : AssetImage('assets/profileEmpty.png'),
                    fit: BoxFit.cover,
                    width: 1000,
                    height: 100,
                  ),
                  SizedBox(height: 35),
                  Text(
                    informanteName.split(' ').first,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text('Viu $petName próximo à'),
                  SizedBox(height: 5),
                  Container(
                    width: 250,
                    height: 150,
                    color: Colors.red,
                  ),
                  SizedBox(height: 5),
                  Text('Clique no mapa para navegar'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
