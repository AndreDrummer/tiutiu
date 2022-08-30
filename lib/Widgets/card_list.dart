import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:flutter/material.dart';

class CardList extends StatefulWidget {
  CardList({
    this.favorite = false,
    this.donate = true,
    this.petInfo,
    this.kind,
  });

  final bool favorite;
  final String? kind;
  final Pet? petInfo;
  final bool? donate;

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  Future loadOwner(DocumentReference doc) async {
    final owner = await doc.get();
    if (authController.firebaseUser != null) {
      if (authController.firebaseUser!.uid ==
          (owner.data() as Map<String, dynamic>)['uid']) {
        Map<String, dynamic> map = {'displayName': 'Você'};
        return Future.value(map);
      }
    }
    Map<String, dynamic> userData = (owner.data() as Map<String, dynamic>);
    userData.putIfAbsent(
        'name', () => (owner.data() as Map<String, dynamic>)['displayName']);
    userData.putIfAbsent(
        'id', () => (owner.data() as Map<String, dynamic>)['uid']);
    return Future.value(userData);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    List<String> distanceText = ['00'];
    // OtherFunctions.distanceCalculate(
    //   context,
    //   widget.petInfo!.latitude!,
    //   widget.petInfo!.longitude!,
    // );

    return InkWell(
      onTap: () async {
        if (tiutiuUserController.tiutiuUser.uid != null &&
            tiutiuUserController.tiutiuUser.uid != widget.petInfo!.ownerId) {}

        if (widget.petInfo!.owner == null) {
          print('Was null');
        }
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              height: height / 4,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: FadeInImage(
                  image: AssetHandle(widget.petInfo!.photos!.first).build(),
                  placeholder: AssetImage(ImageAssets.fadeIn),
                  height: 1000,
                  width: 1000,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  border:
                      Border.all(style: BorderStyle.solid, color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: width - 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.petInfo!.name!,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 20),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.petInfo!.breed!,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey,
                                    fontSize: 14),
                          ),
                          SizedBox(height: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 2.0),
                            child: Row(
                              children: [
                                Icon(Tiutiu.eye, size: 14, color: Colors.grey),
                                Text(
                                    '  ${widget.petInfo!.views ?? 1} visualizações',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700)),
                                SizedBox(width: 20),
                                Icon(
                                    widget.petInfo!.kind ==
                                            FirebaseEnvPath.donate
                                        ? Icons.favorite
                                        : Icons.info,
                                    size: 14,
                                    color: Colors.grey),
                                Text(
                                  ' ${widget.petInfo!.kind == FirebaseEnvPath.donate ? 'interessados' : 'informações'}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        IconButton(
                            icon: widget.favorite
                                ? Icon(
                                    Icons.favorite_border,
                                    size: 40,
                                    color: Colors.red,
                                  )
                                : Icon(Tiutiu.location_arrow,
                                    size: 25,
                                    color: Theme.of(context).primaryColor),
                            onPressed: null),
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
                                        .headline4!
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
    );
  }
}
