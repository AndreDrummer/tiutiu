import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import '../Widgets/floating_button_option.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import '../core/utils/routes/routes_name.dart';
import 'package:tiutiu/screen/my_account.dart';
import 'package:tiutiu/screen/pet_detail.dart';
import 'package:tiutiu/screen/pets_list.dart';
import 'package:tiutiu/screen/favorites.dart';
import 'package:tiutiu/core/utils/constantes.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final fbm = FirebaseMessaging();

  // AdsProvider adsProvider;
  int _selectedIndex = 0;
  late bool isAuthenticated;
  // BannerAd homeBanner;

  // Widget _buildDialog(BuildContext context) {
  //   return AlertDialog(
  //     content: Text("Item has been updated"),
  //     actions: <Widget>[
  //       TextButton(
  //         child: const Text('CLOSE'),
  //         onPressed: () {
  //           Navigator.pop(context, false);
  //         },
  //       ),
  //       TextButton(
  //         child: const Text('SHOW'),
  //         onPressed: () {
  //           Navigator.pop(context, true);
  //         },
  //       ),
  //     ],
  //   );
  // }

  // void _showItemDialog(Map<String, dynamic> message) {
  //   showDialog<bool>(
  //     context: context,
  //     builder: (_) => _buildDialog(context),
  //   ).then((bool shouldNavigate) {
  //     if (shouldNavigate == true) {
  //       _navigateToItemDetail(message);
  //     }
  //   });
  // }

  // void _navigateToItemDetail(Map<String, dynamic> message) {
  // final Item item = _itemForMessage(message);
  // Clear away dialogs
  // Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
  // if (!item.route.isCurrent) {
  //   Navigator.push(context, item.route);
  // }
  // }

  @override
  void initState() {
    this.initDynamicLinks();
    // adsProvider = Provider.of(context, listen: false);
    // adsProvider
    //     .canShowAds()
    //     .then((value) => adsProvider.changeCanShowAds(value));
    // adsProvider.initReward();
    // fbm.configure(
    //   onMessage: (notification) {
    //     print(notification['data']);
    //     userProvider
    //         .handleNotifications(json.decode(notification['data']['data']));
    //     return;
    //   },
    //   onResume: (notification) {
    //     print(notification['data']);
    //     userProvider
    //         .handleNotifications(json.decode(notification['data']['data']));
    //     return;
    //   },
    //   onLaunch: (notification) {
    //     print(notification['data']);
    //     userProvider
    //         .handleNotifications(json.decode(notification['data']['data']));
    //     return;
    //   },
    // );
    // fbm.requestNotificationPermissions();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // adsProvider.changeBannerWidth(MediaQuery.of(context).size.width ~/ 1);

    if (authController.firebaseUser != null) setUserMetaData();
    isAuthenticated = authController.firebaseUser != null;
    super.didChangeDependencies();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> leaveApplication() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopUpMessage(
          title: 'Encerrar aplicação',
          message: 'Deseja realmente sair?',
          confirmAction: () {
            exit(0);
          },
          confirmText: 'Sim',
          denyAction: () {
            Navigator.pop(context);
          },
          denyText: 'Não',
        );
      },
    ).then((value) {
      return false;
    });
  }

  void navigateToAuth() {
    Navigator.pushNamed(context, Routes.auth, arguments: true);
  }

  void setUserMetaData() async {
    Future.delayed(Duration(seconds: 60), () {
      print('Não autenticado recentemente...');
    });

    // tiutiuUserController.tiutiuUserchangeNotificationToken(await fbm.getToken());
    // userController.updateUser(tiutiuUserController.tiutiuUser.uid,
    //     {"notificationToken": tiutiuUserController.tiutiuUsernotificationToken});
  }

  void openPetDetail(Uri deepLink) async {
    final String qParams =
        deepLink.toString().split(Constantes.DYNAMIC_LINK_PREFIX + '/').last;
    final String kind = qParams.toString().split('/').first;
    final String id = qParams.toString().split('/').last;

    Pet pet = await petsController.openPetDetails(id, kind);
    TiutiuUser user = await tiutiuUserController.tiutiuUser;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PetDetails(
            petOwner: user,
            isMine: user.uid == authController.firebaseUser?.uid,
            pet: pet,
            kind: pet.kind!.toUpperCase(),
          );
        },
      ),
    );
  }

  void initDynamicLinks() async {
    // FirebaseDynamicLinks.instance.onLink(
    //     onSuccess: (PendingDynamicLinkData dynamicLink) async {
    //   final Uri deepLink = dynamicLink?.link;
    //   if (deepLink != null) openPetDetail(deepLink);
    // }, onError: (OnLinkErrorException e) async {
    //   print('LinkError: ${e.message}');
    // });

    // final PendingDynamicLinkData data =
    //     await FirebaseDynamicLinks.instance.getInitialLink();
    // final Uri deepLink = data?.link;
    // if (deepLink != null) {
    //   openPetDetail(deepLink);
    // }
  }

  @override
  Widget build(BuildContext context) {
    var _screens = <Widget>[
      PetsList(petKind: FirebaseEnvPath.donate),
      PetsList(petKind: FirebaseEnvPath.disappeared),
      isAuthenticated ? Favorites() : AuthScreen(),
      isAuthenticated ? MyAccount() : AuthScreen(),
    ];

    return WillPopScope(
      onWillPop: leaveApplication,
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            _screens.elementAt(_selectedIndex),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          backgroundColor: Colors.black,
          showSelectedLabels: true,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Tiutiu.pets),
              label: 'Adotar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Tiutiu.exclamation),
              label: 'Desaparecidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Tiutiu.user, size: 18),
              label: 'Eu',
            )
          ],
        ),
        floatingActionButton: _selectedIndex > 1
            ? null
            : SpeedDial(
                animatedIcon: AnimatedIcons.add_event,
                animatedIconTheme: IconThemeData(size: 22.0),
                visible:
                    MediaQuery.of(context).orientation == Orientation.portrait,
                closeManually: false,
                curve: Curves.bounceIn,
                overlayOpacity: 0.5,
                onOpen: () {},
                onClose: () {},
                tooltip: 'Adicionar PET',
                heroTag: 'speed-dial-hero-tag',
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                    child: FloatingButtonOption(image: 'assets/dogCat2.webp'),
                    label: 'Adicionar Desaparecido',
                    backgroundColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(fontSize: 14.0),
                    onTap: !isAuthenticated
                        ? navigateToAuth
                        : () {
                            Navigator.pushNamed(
                                context, Routes.pet_location_picker,
                                arguments: {
                                  'kind': FirebaseEnvPath.disappeared
                                });
                          },
                  ),
                  SpeedDialChild(
                    child: FloatingButtonOption(image: 'assets/dogCat.webp'),
                    label: 'Doar PET',
                    backgroundColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(fontSize: 14.0),
                    onTap: !isAuthenticated
                        ? navigateToAuth
                        : () {
                            Navigator.pushNamed(
                                context, Routes.pet_location_picker,
                                arguments: {'kind': FirebaseEnvPath.donate});
                          },
                  ),
                ],
              ),
      ),
    );
  }
}
