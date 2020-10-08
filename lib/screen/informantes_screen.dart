import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/backend/Model/interested_model.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/providers/user_infos_interests.dart';
import "package:google_maps_webservice/geocoding.dart";
import 'package:tiutiu/screen/announcer_datails.dart';
import 'package:tiutiu/utils/constantes.dart';

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

  Future<String> getAddress(Location location) async {
    final geocoding = new GoogleMapsGeocoding(apiKey: Constantes.WEB_API_KEY);
    final result = await geocoding.searchByLocation(location);
    return result.results.first.formattedAddress;
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    InterestedModel informante = arguments['informanteInfo'];

    return Scaffold(
      appBar: AppBar(title: Text('${arguments['petName']} foi visto aqui')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: userInfoOrAdoptInterestsProvider.info,
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
                      'Ninguém ainda informou sobre ${arguments['petName']}',
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

            return FutureBuilder<DocumentSnapshot>(
              future: loadInformateInfo(informante.userReference),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(child: LoadingBumpingLine.circle(size: 30));
                }
                return Center(
                  child: _cardInfo(
                    onUserView: ()  {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AnnouncerDetails(User.fromSnapshot(snapshot.data));
                        },

                      ),);
                    },
                    informanteImage: snapshot.data.data()['photoURL'],
                    informanteLat: informante.userLat,
                    informanteLng: informante.userLog,
                    informanteName: snapshot.data.data()['displayName'],
                    petName: arguments['petName'],
                  ),
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
    Function() onUserView
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () => onUserView(),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('${informanteName.split(' ').first}'),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        InkWell(
          onTap: () {
            MapsLauncher.launchCoordinates(
              informanteLat,
              informanteLng,
              informanteName.split(' ').first,
            );
          },
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 250,
                child: Image.asset('assets/static_map.jpg', fit: BoxFit.fill),
              ),
              SizedBox(height: 2),
              Text('Clique no mapa para navegar',
                  style: TextStyle(fontSize: 10)),
              SizedBox(height: 10),
              FutureBuilder(
                future: getAddress(Location(informanteLat, informanteLng)),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: LoadingBumpingLine.circle(size: 30));
                  }
                  return Text(
                    snapshot.data,
                    textAlign: TextAlign.center,
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
