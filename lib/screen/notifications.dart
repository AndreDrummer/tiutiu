import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/screen/interested_information_list.dart';
import 'package:tiutiu/core/models/notification_model.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // AdsProvider adsProvider;

  @override
  void didChangeDependencies() {
    // adsProvider = Provider.of(context);

    super.didChangeDependencies();
  }

  List<QueryDocumentSnapshot> orderedListByTime(
      List<QueryDocumentSnapshot> docs) {
    List<QueryDocumentSnapshot> newList = docs;
    newList.sort((a, b) =>
        DateTime.parse((b.data() as Map<String, dynamic>)['time'])
            .millisecondsSinceEpoch -
        DateTime.parse((a.data() as Map<String, dynamic>)['time'])
            .millisecondsSinceEpoch);
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          'Notificações'.toUpperCase(),
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(height: 100),
                      // adsProvider.getCanShowAds
                      //     ? adsProvider.bannerAdMob(
                      //         medium_banner: true, adId: adsProvider.topAdId)
                      //     : Container(),
                      SizedBox(height: 40),
                      EmptyListScreen(
                        text: 'Nenhuma notificação!',
                        icon: Icons.notifications_off_outlined,
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    // adsProvider.getCanShowAds
                    //     ? adsProvider.bannerAdMob(adId: adsProvider.topAdId)
                    //     : Container(),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        key: UniqueKey(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          NotificationModel notificationModel =
                              NotificationModel.fromSnapshot(orderedListByTime(
                                  snapshot.data!.docs)[index]);

                          return _ListTile(
                            notificationModel: notificationModel,
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  _ListTile({
    required this.notificationModel,
  });

  final NotificationModel notificationModel;

  Future<String> loadUserAvatar(DocumentReference userRef) async {
    TiutiuUser userData = TiutiuUser.fromSnapshot(await userRef.get());
    return Future.value(userData.avatar);
  }

  Future<Pet> loadPetInfo(DocumentReference petRef) async {
    Pet petInfo =
        Pet.fromMap((await petRef.get()).data() as Map<String, dynamic>);
    return Future.value(petInfo);
  }

  void handleNavigation(String notificationType, BuildContext context) async {
    if (!notificationModel.open!) {
      await notificationModel.notificationReference!
          .set({'open': true}, SetOptions(merge: true));
    }

    Pet petInfo = await loadPetInfo(notificationModel.petReference!);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return InterestedList(
          kind: petInfo.kind,
          pet: petInfo,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        handleNavigation(notificationModel.notificationType!, context);
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: FutureBuilder<String>(
                  future: loadUserAvatar(notificationModel.userReference!),
                  builder: (context, snapshot) {
                    return FadeInImage(
                      placeholder:
                          AssetHandle(ImageAssets.profileEmpty).build(),
                      image: AssetHandle(
                        snapshot.data,
                      ).build(),
                      fit: BoxFit.cover,
                      width: 1000,
                      height: 100,
                    );
                  },
                ),
              ),
            ),
            title: AutoSizeText(
              notificationModel.title!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: AutoSizeText(notificationModel.message!),
            trailing: Column(
              children: [
                !notificationModel.open!
                    ? Badge(
                        color: AppColors.primary,
                        text: 'Nova',
                      )
                    : AutoSizeText(''),
                AutoSizeText(DateFormat('dd/MM/y HH:mm')
                    .format(DateTime.parse(notificationModel.time!))
                    .split(' ')
                    .last),
                AutoSizeText(DateFormat('dd/MM/y HH:mm')
                    .format(DateTime.parse(notificationModel.time!))
                    .split(' ')
                    .first)
              ],
            ),
          ),
          Divider(color: Colors.grey)
        ],
      ),
    );
  }
}
