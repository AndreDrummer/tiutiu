import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/badge.dart';
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
    InterestedModel informante = arguments['informanteInfo'] as InterestedModel;

    return Scaffold(
      appBar: AppBar(
          title: Text('${arguments['petName']} foi visto aqui'.toUpperCase())),
      body: StreamBuilder(
        stream: userInfoOrAdoptInterestsProvider.info,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage(
              messageLoading: 'Carregando lista de informantes',
              circle: true,
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

              return _cardInfo(
                  onUserView: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AnnouncerDetails(
                            User.fromSnapshot(snapshot.data),
                          );
                        },
                      ),
                    );
                  },
                  informanteImage: snapshot.data!.data()['photoURL'],
                  informanteLat: informante.userLat,
                  informanteLng: informante.userLog,
                  informanteName: snapshot.data!.data()['displayName'],
                  petName: arguments['petName'],
                  dateTime: informante.interestedAt,
                  details: informante.infoDetails);
            },
          );
        },
      ),
    );
  }

  Widget _cardInfo({
    String informanteName,
    String details,
    String informanteImage,
    String dateTime,
    String petName,
    double informanteLat,
    double informanteLng,
    Function() onUserView,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          height: MediaQuery.of(context).size.height / 2.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () => onUserView(),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: FadeInImage(
                          placeholder: AssetImage('assets/profileEmpty.png'),
                          image: informanteImage != null
                              ? NetworkImage(
                                  informanteImage,
                                )
                              : AssetImage('assets/profileEmpty.png'),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visto dia ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(dateTime)).split(' ').first} às ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(dateTime)).split(' ').last}, próximo à',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: FutureBuilder(
                            future: getAddress(
                                Location(informanteLat, informanteLng)),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Center(
                                  child: LoadingBumpingLine.circle(size: 15),
                                );
                              }
                              return Text(
                                snapshot.data,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.blueGrey),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
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
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      width: MediaQuery.of(context).size.width - 10,
                      height: details.isEmpty ? 222 : 160,
                      child: FadeInImage(
                        placeholder: AssetImage('assets/static_map.jpg'),
                        image: NetworkImage(
                            'https://maps.googleapis.com/maps/api/staticmap?center=$informanteLat, $informanteLng&zoom=15&markers=color:red%7Clabel:%7c$informanteLat,%20$informanteLng&size=600x400&key=${Constantes.WEB_API_KEY}'),
                        fit: BoxFit.cover,
                        width: 1000,
                        height: 100,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 12,
                      child: Badge(
                        color: Colors.black26,
                        text: 'Clique no mapa para navegar',
                        textSize: 10,
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Detalhes: ${details ?? 'Não informado'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
