import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/favorites_provider.dart';
import 'package:tiutiu/providers/location.dart' as provider_location;
import 'package:tiutiu/screen/pet_detail.dart';
import 'package:tiutiu/utils/math_functions.dart';

// ignore: must_be_immutable
class CardList extends StatefulWidget {
  CardList({
    this.petInfo,
    this.donate = true,
    this.kind,
    this.favorite = false,
  });

  final Pet petInfo;
  final String kind;
  final bool donate;
  bool favorite;

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  Future loadOwner(DocumentReference doc, {Authentication auth}) async {
    final owner = await doc.get();
    if (auth != null) {
      if (auth.firebaseUser.uid == owner.data()['uid']) {
        Map map = {'displayName': 'Você'};
        return Future.value(map);
      }
    }
    return Future.value(owner.data());
  }

  List<String> distanceCalculate(double petLatitude, double petLongitude) {
    provider_location.Location currentLoction =
        Provider.of(context, listen: false);
    String textDistance = '';
    String textTime = '';

    String distance = MathFunctions.distanceMatrix(
      latX: currentLoction.location.latitude,
      longX: currentLoction.location.longitude,
      latY: petLatitude,
      longY: petLongitude,
    );

    String time = MathFunctions.time(double.parse(distance));    

    if (double.parse(time) > 60) {
      textTime = "$time\ h";
    } else {
      textTime = "${time.split('.').first}\ min";
    }

    if (double.parse(distance) < 1000) {
      textDistance = "${distance.split('.').first}m";
    } else {
      textDistance = (double.parse(distance) / 1000).toStringAsFixed(0);
      textDistance = textDistance.split('.').first + ' Km';
    }


    return [textDistance, textTime];
  }

  @override
  Widget build(BuildContext context) {
    UserController user = UserController();
    Authentication auth = Provider.of(context, listen: false);
    FavoritesProvider favoritesProvider = Provider.of(context);
    List<String> distanceText = distanceCalculate(
        widget.petInfo.toMap()['latitude'],
        widget.petInfo.toMap()['longitude']);

    return Stack(
      children: [
        InkWell(
          onTap: () async {
            final user =
                await loadOwner(widget.petInfo.toMap()['ownerReference']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PetDetails(
                    petOwner: User.fromMap(user),
                    isMine: User.fromMap(user).id == auth.firebaseUser?.uid,
                    pet: widget.petInfo,
                    kind: widget.petInfo.kind.toUpperCase(),
                  );
                },
              ),
            );
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
                          style: BorderStyle.solid, color: Colors.grey)),
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/fadeIn.jpg'),
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
                          style: BorderStyle.solid, color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.petInfo.toMap()['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
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
                                    widget.petInfo.toMap()['ownerReference'],
                                    auth: auth.firebaseUser != null ? auth : null),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting || snapshot.data == null) {
                                    return Text('');
                                  }                                
                                  return Text(
                                    '${snapshot.data['displayName']} está ${widget.kind.toUpperCase() == 'DONATE' ? 'doando' : 'procurando'}.',
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
                              icon: widget.favorite
                                  ? Icon(
                                      favoritesProvider.getFavoritesPETSIDList
                                              .contains(
                                                  widget.petInfo.toMap()['id'])
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 40,
                                      color: Colors.red,
                                    )
                                  : Icon(Tiutiu.location_arrow,
                                      size: 25,
                                      color: Theme.of(context).primaryColor),
                              onPressed: !widget.favorite
                                  ? null : () {
                                if (favoritesProvider.getFavoritesPETSIDList
                                    .contains(widget.petInfo.toMap()['id'])) {
                                  user.favorite(
                                      auth.firebaseUser.uid,
                                      widget.petInfo.toMap()['petReference'],
                                      false);
                                  favoritesProvider.handleFavorite(
                                      widget.petInfo.toMap()['id']);
                                } else {
                                  user.favorite(
                                      auth.firebaseUser.uid,
                                      widget.petInfo.toMap()['petReference'],
                                      true);
                                  favoritesProvider.loadFavoritesReference();
                                  favoritesProvider.handleFavorite(
                                      widget.petInfo.toMap()['id']);
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 7.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${distanceText[0]}',
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
        ),       
      ],
    );
  }
}
