import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/distance.dart' as distanceMatrix;
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/favorites_provider.dart';
import 'package:tiutiu/providers/location.dart' as provider_location;
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/utils/routes.dart';

// ignore: must_be_immutable
class CardList extends StatefulWidget {
  CardList(
      {this.petInfo, this.donate = true, this.kind, this.favorite = false});

  final petInfo;
  final String kind;
  final bool donate;
  bool favorite;

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  Future loadOwner(DocumentReference doc) async {
    final owner = await doc.get();
    return Future.value(owner.data()['displayName']);
  }

  Future calculateDistance(double latitude, double longitude) async {
    provider_location.Location currentLoction =
        Provider.of(context, listen: false);
    final distance =
        distanceMatrix.GoogleDistanceMatrix(apiKey: Constantes.WEB_API_KEY);

    var origins = [
      distanceMatrix.Location(
          currentLoction.location.latitude, currentLoction.location.longitude),
    ];

    var destinations = [
      distanceMatrix.Location(latitude, longitude),
    ];

    var responseForLocation = await distance.distanceWithLocation(
      origins,
      destinations,
    );

    if (responseForLocation.isOkay) {
      print(responseForLocation.destinationAddress.length);
      for (var row in responseForLocation.results) {
        for (var element in row.elements) {
          return ['${element.distance.text}', '${element.duration.text}'];
        }
      }
    } else {
      print('ERROR: ${responseForLocation.errorMessage}');
    }
  }

  @override
  Widget build(BuildContext context) {
    UserController user = UserController();
    Authentication auth = Provider.of(context, listen: false);
    FavoritesProvider favoritesProvider = Provider.of(context);
    
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.PET_DETAILS, arguments: {
          'petInfo': widget.petInfo,
          'kind': widget.kind.toUpperCase()
        });
      },
      child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            // color: Colors.white70,
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: Colors.blueGrey[50],
                      ),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        child: FadeInImage(
                          placeholder: AssetImage('assets/Logo.png'),
                          image: NetworkImage(widget.petInfo.toMap()['avatar']),
                          height: 1000,
                          width: 1000,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.petInfo.toMap()['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          widget.favorite
                              ? IconButton(
                                  icon: Icon(
                                      favoritesProvider.getFavoritesPETSIDList
                                              .contains(
                                                  widget.petInfo.toMap()['id'])
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red),
                                  onPressed: () {
                                    user.favorite(
                                        auth.firebaseUser.uid,
                                        widget.petInfo.toMap()['petReference'],
                                        false);
                                    favoritesProvider.handleFavorite(
                                        widget.petInfo.toMap()['id']);
                                  },
                                )
                              : SizedBox()
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text(widget.petInfo.toMap()['breed']),
                      SizedBox(height: 20),
                      SizedBox(
                        // width: MediaQuery.of(context).size.width * 0.525,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FutureBuilder(
                                future: loadOwner(
                                    widget.petInfo.toMap()['ownerReference']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return LoadingBumpingLine.circle(size: 20);
                                  }
                                  return Text(
                                    '${snapshot.data} está ${widget.kind.toUpperCase() == 'DONATE' ? 'doando' : 'procurando'}.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FutureBuilder(
                                // future: calculateDistance(widget.petInfo.toMap()['latitude'],widget.petInfo.toMap()['longitude']),
                                future: Future.delayed(Duration(seconds: 1), () {
                                  return ['100m', '3min'];
                                }),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return LoadingBumpingLine.circle(size: 20);
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Está a ${snapshot.data[0]}, ',
                                          // 'Está a 1 km, ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Text(
                                          '${snapshot.data[1]} daqui',
                                          // '5 min daqui',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
