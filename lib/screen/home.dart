import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/favorites_provider.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/screen/favorites.dart';
import 'package:tiutiu/screen/my_account.dart';
import 'package:tiutiu/screen/pet_detail.dart';
import 'package:tiutiu/screen/pets_list.dart';
import 'package:tiutiu/utils/constantes.dart';
import '../Widgets/floating_button_option.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import '../utils/routes.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool isAuthenticated;
  UserProvider userProvider;
  PetsProvider petsProvider;
  FavoritesProvider favoritesProvider;
  Authentication auth;
  final fbm = FirebaseMessaging();
  BannerAd homeBanner;
  AdsProvider adsProvider;

  // Widget _buildDialog(BuildContext context) {
  //   return AlertDialog(
  //     content: Text("Item has been updated"),
  //     actions: <Widget>[
  //       FlatButton(
  //         child: const Text('CLOSE'),
  //         onPressed: () {
  //           Navigator.pop(context, false);
  //         },
  //       ),
  //       FlatButton(
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
    adsProvider = Provider.of(context, listen: false);
    adsProvider.changeCanShowAds(true);
    adsProvider.initReward();
    fbm.configure(
      onMessage: (notification) {
        print(notification['data']);
        userProvider.handleNotifications(json.decode(notification['data']['data']));
        return;
      },
      onResume: (notification) {
        print(notification['data']);
        userProvider.handleNotifications(json.decode(notification['data']['data']));
        return;
      },
      onLaunch: (notification) {
        print(notification['data']);
        userProvider.handleNotifications(json.decode(notification['data']['data']));
        return;
      },
    );
    fbm.requestNotificationPermissions();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    adsProvider.changeBannerWidth(MediaQuery.of(context).size.width ~/ 1);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    petsProvider = Provider.of<PetsProvider>(context, listen: false);
    auth = Provider.of<Authentication>(context, listen: false);
    favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    if (auth.firebaseUser != null) setUserMetaData();
    isAuthenticated = auth.firebaseUser != null;
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
      builder: (_) => Consumer<Authentication>(
        builder: (context, auth, child) {
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
      ),
    ).then((value) {
      return false;
    });
  }

  void navigateToAuth() {
    Navigator.pushNamed(context, Routes.AUTH, arguments: true);
  }

  void setUserMetaData() async {
    final CollectionReference usersEntrepreneur = FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot doc = await usersEntrepreneur.doc(auth.firebaseUser.uid).get();
    UserController userController = UserController();

    Future.delayed(Duration(seconds: 60), () {
      userProvider.changeRecentlyAuthenticated(false);
      print('Não autenticado recentemente...');
    });

    userProvider.changeUserReference(doc.reference);
    userProvider.changeUid(auth.firebaseUser.uid);
    userProvider.changePhotoUrl(doc.data()['photoURL']);
    userProvider.changePhotoBack(doc.data()['photoBACK']);
    userProvider.changeWhatsapp(doc.data()['phoneNumber']);
    userProvider.changeDisplayName(doc.data()['displayName']);
    userProvider.changeCreatedAt(doc.data()['createdAt']);
    userProvider.changeTelefone(doc.data()['landline']);
    userProvider.changeBetterContact(doc.data()['betterContact']);
    userProvider.calculateTotals();
    userProvider.changeNotificationToken(await fbm.getToken());
    userController.updateUser(userProvider.uid, {"notificationToken": userProvider.notificationToken});
    if (auth.firebaseUser != null) {
      favoritesProvider.loadFavoritesReference();
    }
  }

  void openPetDetail(Uri deepLink) async {
    final String qParams = deepLink.toString().split(Constantes.DYNAMIC_LINK_PREFIX + '/').last;
    final String kind = qParams.toString().split('/').first;
    final String id = qParams.toString().split('/').last;

    Pet pet = await petsProvider.openPetDetails(id, kind);
    User user = await UserController().getUserByID(pet.ownerId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PetDetails(
            petOwner: user,
            isMine: user.id == auth.firebaseUser?.uid,
            pet: pet,
            kind: pet.kind.toUpperCase(),
          );
        },
      ),
    );
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) openPetDetail(deepLink);
    }, onError: (OnLinkErrorException e) async {
      print('LinkError: ${e.message}');
    });

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      openPetDetail(deepLink);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _screens = <Widget>[
      PetsList(),
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
            _selectedIndex == 0
                ? Positioned(
                    bottom: 0.0,
                    child: ButtonWide(
                      action: () {
                        Navigator.pushNamed(context, Routes.SEARCH_REFINE);
                      },
                      icon: Tiutiu.params,
                      rounded: false,
                      isToExpand: true,
                      text: 'REFINAR BUSCA',
                    ),
                  )
                : SizedBox()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          backgroundColor: Colors.black,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Tiutiu.pets),
              label: 'PETS',
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
        floatingActionButton: _selectedIndex != 0
            ? null
            : SpeedDial(
                marginRight: 18,
                marginBottom: 20,
                animatedIcon: AnimatedIcons.add_event,
                animatedIconTheme: IconThemeData(size: 22.0),
                visible: MediaQuery.of(context).orientation == Orientation.portrait,
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
                    child: FloatingButtonOption(image: 'assets/dogCat2.png'),
                    label: 'Adicionar Desaparecido',
                    backgroundColor: Theme.of(context).accentColor,
                    labelStyle: TextStyle(fontSize: 14.0),
                    onTap: !isAuthenticated
                        ? navigateToAuth
                        : () {
                            Navigator.pushNamed(context, Routes.CHOOSE_LOCATION, arguments: {'kind': 'Disappeared'});
                          },
                  ),
                  SpeedDialChild(
                    child: FloatingButtonOption(image: 'assets/pata.jpg'),
                    label: 'Doar PET',
                    backgroundColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(fontSize: 14.0),
                    onTap: !isAuthenticated
                        ? navigateToAuth
                        : () {
                            Navigator.pushNamed(context, Routes.CHOOSE_LOCATION, arguments: {'kind': 'Donate'});
                          },
                  ),
                ],
              ),
      ),
    );
  }
}
