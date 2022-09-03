import 'package:tiutiu/features/home/widgets/bottom_bar.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/screen/donate_disappeared_list.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/core/utils/constantes.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/screen/my_account.dart';
import 'package:tiutiu/screen/pet_detail.dart';
import 'package:tiutiu/screen/favorites.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  var _screens = <Widget>[
    PetsList(),
    homeController.isAuthenticated ? MyAccount() : AuthScreen(),
    homeController.isAuthenticated ? Favorites() : AuthScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: leaveApplication,
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            _screens.elementAt(homeController.bottomBarIndex),
          ],
        ),
        bottomNavigationBar: BottomBar(),
        // floatingActionButton: _selectedIndex > 1
        //     ? null
        //     : SpeedDial(
        //         animatedIcon: AnimatedIcons.add_event,
        //         animatedIconTheme: IconThemeData(size: 22.0),
        //         visible:
        //             MediaQuery.of(context).orientation == Orientation.portrait,
        //         closeManually: false,
        //         curve: Curves.bounceIn,
        //         overlayOpacity: 0.5,
        //         onOpen: () {},
        //         onClose: () {},
        //         tooltip: 'Adicionar PET',
        //         heroTag: 'speed-dial-hero-tag',
        //         backgroundColor: Theme.of(context).primaryColor,
        //         foregroundColor: Colors.white,
        //         elevation: 8.0,
        //         shape: CircleBorder(),
        //         children: [
        //           SpeedDialChild(
        //             child: FloatingButtonOption(image: ImageAssets.dogCat2),
        //             label: 'Adicionar Desaparecido',
        //             backgroundColor: Theme.of(context).primaryColor,
        //             labelStyle: TextStyle(fontSize: 14.0),
        //             onTap: !isAuthenticated
        //                 ? navigateToAuth
        //                 : () {
        //                     Navigator.pushNamed(
        //                         context, Routes.pet_location_picker,
        //                         arguments: {
        //                           'kind': FirebaseEnvPath.disappeared
        //                         });
        //                   },
        //           ),
        //           SpeedDialChild(
        //             child: FloatingButtonOption(image: ImageAssets.dogCat),
        //             label: 'Doar PET',
        //             backgroundColor: Theme.of(context).primaryColor,
        //             labelStyle: TextStyle(fontSize: 14.0),
        //             onTap: !isAuthenticated
        //                 ? navigateToAuth
        //                 : () {
        //                     Navigator.pushNamed(
        //                         context, Routes.pet_location_picker,
        //                         arguments: {'kind': FirebaseEnvPath.donate});
        //                   },
        //           ),
        //         ],
        //       ),
      ),
    );
  }
}
