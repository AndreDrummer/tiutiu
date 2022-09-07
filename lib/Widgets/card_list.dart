import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardList extends StatefulWidget {
  CardList({
    this.favorite = false,
    this.pet,
  });

  final bool favorite;
  final Pet? pet;

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

    List<String> distanceText = OtherFunctions.distanceCalculate(
      context,
      widget.pet!.latitude!,
      widget.pet!.longitude!,
    );

    return InkWell(
      onTap: () async {
        if (tiutiuUserController.tiutiuUser.uid != null &&
            tiutiuUserController.tiutiuUser.uid != widget.pet!.ownerId) {}

        if (widget.pet!.owner == null) {
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
              height: Get.height / 1.88,
              width: double.infinity,
              child: CarouselSlider.builder(
                itemCount: widget.pet!.photos?.length ?? 0,
                itemBuilder: (ctx, index, i) {
                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: FadeInImage(
                      image: AssetHandle(widget.pet!.photos!.first).build(),
                      placeholder: AssetImage(ImageAssets.fadeIn),
                      height: 1000,
                      width: 1000,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                options: CarouselOptions(
                  enableInfiniteScroll: widget.pet!.photos!.length > 1,
                  autoPlayCurve: Curves.easeIn,
                  disableCenter: true,
                  viewportFraction: 1,
                  autoPlay: true,
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
                border: Border.all(
                  style: BorderStyle.solid,
                  color: Colors.grey,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: width - 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            widget.pet!.name!,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 20),
                          ),
                          SizedBox(height: 5),
                          AutoSizeText(
                            widget.pet!.breed!,
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
                                AutoSizeText(
                                    '  ${widget.pet!.views ?? 1} visualizações',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700)),
                                SizedBox(width: 20),
                                Icon(
                                    widget.pet!.kind == FirebaseEnvPath.donate
                                        ? Icons.favorite
                                        : Icons.info,
                                    size: 14,
                                    color: Colors.grey),
                                AutoSizeText(
                                  ' ${widget.pet!.kind == FirebaseEnvPath.donate ? 'interessados' : 'informações'}',
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
                                    color: AppColors.danger,
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
                                  AutoSizeText(
                                    '${distanceText[0]}',
                                    style: TextStyles.fontSize12(),
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
