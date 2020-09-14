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
  CardList({
    this.petInfo,
    this.donate = true,
    this.kind,
    this.favorite = false,
  });

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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border.all(
                  style: BorderStyle.solid,
                  color: Colors.grey
                )
              ),
              height: 300,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: FadeInImage(
                  placeholder: AssetImage('assets/Logo.png'),
                  image: NetworkImage(widget.petInfo.toMap()['avatar']),
                  height: 1000,
                  width: 1000,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border.all(
                  style: BorderStyle.solid,
                  color: Colors.grey
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.petInfo.toMap()['name'],
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 25),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.petInfo.toMap()['breed'],
                        ),
                        SizedBox(height: 20),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                              );
                            }),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        IconButton(
                          icon: widget.favorite ? Icon(
                            favoritesProvider.getFavoritesPETSIDList
                                    .contains(widget.petInfo.toMap()['id'])
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 40,
                            color: Colors.red,
                          ) : Icon(Icons.send, size: 40, color: Colors.green),
                          onPressed: () {
                            if (widget.favorite) {
                              user.favorite(auth.firebaseUser.uid,widget.petInfo.toMap()['petReference'],false);
                              favoritesProvider.handleFavorite(widget.petInfo.toMap()['id']);
                            } else {
                              
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        Row(
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${snapshot.data[0]}, ',
                                        // 'Está a 1 km, ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        '${snapshot.data[1]}',
                                        // '5 min daqui',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    )
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
