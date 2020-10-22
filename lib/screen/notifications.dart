import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/backend/Model/notification_model.dart';
import 'package:tiutiu/screen/confirm_adoption.dart';
import 'package:tiutiu/screen/interested_information_list.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  AdsProvider adsProvider;
  UserProvider userProvider;

  @override
  void didChangeDependencies() {
    adsProvider = Provider.of(context);
    userProvider = Provider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: userProvider.loadNotifications(),
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data.docs.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(height: 100),
                      adsProvider.getCanShowAds
                          ? adsProvider.bannerAdMob(
                              medium_banner: true, adId: adsProvider.topAdId)
                          : Container(),
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
                    adsProvider.getCanShowAds
                        ? adsProvider.bannerAdMob(adId: adsProvider.topAdId)
                        : Container(),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          NotificationModel notificationModel =
                              NotificationModel.fromSnapshot(
                            snapshot.data.docs[index],
                          );                          

                          return _ListTile(
                            notificationModel: notificationModel,
                            notificationRef: snapshot.data.docs[index].reference,
                            userProvider: userProvider
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
    @required this.notificationModel,
    @required this.notificationRef,
    @required this.userProvider,
  });

  final NotificationModel notificationModel;
  final DocumentReference notificationRef;
  final UserProvider userProvider;

  Future<String> loadUserAvatar(DocumentReference userRef) async {    
    User userData = User.fromSnapshot(await userRef.get());
    return Future.value(userData.photoURL);
  }

  Future<Pet> loadPetInfo(DocumentReference petRef) async {
    Pet petInfo = Pet.fromSnapshot(await petRef.get());
    return Future.value(petInfo);
  }

  void handleNavigation(String notificationType, BuildContext context) async {    
    if(!notificationModel.open) {
      await notificationRef.set({'open': true}, SetOptions(merge: true));    
    }

    if (notificationType == 'confirmAdoption') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ConfirmAdoptionScreen();
        }),
      );
    } else {
      Pet petInfo = await loadPetInfo(notificationModel.petReference);
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
    userProvider.loadNotificationsCount();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        handleNavigation(notificationModel.notificationType, context);
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: FutureBuilder<String>(
                  future: loadUserAvatar(notificationModel.userReference),
                  builder: (context, snapshot) {
                    return FadeInImage(
                      placeholder: AssetImage('assets/profileEmpty.png'),
                      image: snapshot.data != null
                          ? NetworkImage(
                              snapshot.data,
                            )
                          : AssetImage('assets/profileEmpty.png'),
                      fit: BoxFit.cover,
                      width: 1000,
                      height: 100,
                    );
                  },
                ),
              ),
            ),
            title: Text(
              notificationModel.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(notificationModel.message),
            trailing: Column(
              children: [           
                !notificationModel.open ? Badge(
                  color: Colors.green,
                  text: 'Nova',
                ) : Text(''),     
                Text(DateFormat('dd/MM/y hh:mm').format(DateTime.parse(notificationModel.time)).split(' ').last),                
                Text(DateFormat('dd/MM/y hh:mm').format(DateTime.parse(notificationModel.time)).split(' ').first)
              ],
            ),
          ),
          Divider(color: Colors.grey)
        ],
      ),
    );
  }
}
