import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/circle_child.dart';
import 'package:tiutiu/Widgets/divider.dart';
import 'package:tiutiu/Widgets/fullscreen_images.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/chat/common/functions.dart';
import 'package:tiutiu/core/image_handle.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/utils/launcher_functions.dart';
import 'package:tiutiu/utils/other_functions.dart';
import 'package:tiutiu/utils/string_extension.dart';

class AnnouncerDetails extends StatefulWidget {
  AnnouncerDetails(
    this.user, {
    this.showOnlyChat = false,
  });

  final User user;
  final bool showOnlyChat;

  @override
  _AnnouncerDetailsState createState() => _AnnouncerDetailsState();
}

class _AnnouncerDetailsState extends State<AnnouncerDetails> {
  int userTotalToDonate = 0;
  int userTotalDonated = 0;
  int userTotalAdopted = 0;
  int userTotalDisap = 0;
  UserController userController = UserController();
  // AdsProvider adsProvider;

  void calculateTotals(user) async {
    PetController petController = PetController();
    DocumentReference userReference =
        await OtherFunctions.getReferenceById(user.id, 'Users');

    QuerySnapshot adopteds =
        await petController.getPetToCount(userReference, Constantes.ADOPTED);
    QuerySnapshot donates =
        await petController.getPetToCount(userReference, Constantes.DONATE);
    QuerySnapshot disap = await petController.getPetToCount(
        userReference, Constantes.DISAPPEARED);
    QuerySnapshot donated = await petController
        .getPetToCount(userReference, Constantes.DONATE, avalaible: false);

    setState(() {
      userTotalAdopted = adopteds.docs.length;
      userTotalDisap = disap.docs.length;
      userTotalToDonate = donates.docs.length;
      userTotalDonated = donated.docs.length;
    });
  }

  @override
  void initState() {
    calculateTotals(widget.user);
    super.initState();
  }

  @override
  void setState(fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void didChangeDependencies() {
    // adsProvider = Provider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final userWhatsapp = widget.user.phoneNumber ?? null;
    final userLandline = widget.user.landline ?? null;
    final userEmail = widget.user.email ?? null;

    void callWhatsapp() {
      // FlutterOpenWhatsapp.sendSingleMessage('+55$userWhatsapp', 'Olá!');
    }

    void callLandline() {
      String? tel = userLandline != null && userLandline != ''
          ? userLandline
          : userWhatsapp;
      Launcher.makePhoneCall(number: tel!);
    }

    void callEmail() {
      Launcher.sendEmail(emailAddress: userEmail!, message: '', subject: '');
    }

    void openFullScreenMode(List photos_list, String tag) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImage(
            images: photos_list,
            tag: tag,
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Background(),
            Column(
              children: [
                SizedBox(height: 25),
                Container(
                  height: height / 3.5,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/fundo.jpg'),
                    image: AssetHandle(
                      widget.user.photoBACK,
                    ).build(),
                    fit: BoxFit.fill,
                    width: 1000,
                    height: 100,
                  ),
                ),
                SizedBox(height: 50),
                CustomDivider(
                    text: "${widget.user.name!.capitalize()}", fontSize: 18),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          CircleChild(
                            avatarRadius: 25,
                            child: Text(
                              '$userTotalToDonate',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'P/ adoção',
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      color: Colors.black,
                                    ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CircleChild(
                            avatarRadius: 25,
                            child: Text(
                              '$userTotalDonated',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Doados',
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      color: Colors.black,
                                    ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CircleChild(
                            avatarRadius: 25,
                            child: Text(
                              "$userTotalAdopted",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Adotados',
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      color: Colors.black,
                                    ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CircleChild(
                            avatarRadius: 25,
                            child: Text(
                              "$userTotalDisap",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Desaparecidos',
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      color: Colors.black,
                                    ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black),
                Padding(
                  padding: EdgeInsets.only(top: height / 10),
                  // TODO: Tinha um anuncio aqui
                  // child: adsProvider.getCanShowAds
                  // ? adsProvider.bannerAdMob(
                  // adId: adsProvider.bottomAdId, medium_banner: true)
                  // : Container(),
                ),
                Spacer(),
                CustomDivider(text: 'Contato'),
                widget.user.betterContact == 3 || widget.showOnlyChat
                    ? _OnlyChatButton(secondUser: widget.user)
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            userWhatsapp != null
                                ? InkWell(
                                    onTap: () {
                                      callWhatsapp();
                                    },
                                    child: CircleChild(
                                      avatarRadius: 25,
                                      child: Icon(
                                        Tiutiu.whatsapp,
                                      ),
                                    ),
                                  )
                                : Container(),
                            userLandline != null
                                ? InkWell(
                                    onTap: () {
                                      callLandline();
                                    },
                                    child: CircleChild(
                                      avatarRadius: 25,
                                      child: Icon(
                                        Icons.phone,
                                      ),
                                    ),
                                  )
                                : Container(),
                            userEmail != null
                                ? InkWell(
                                    onTap: () {
                                      callEmail();
                                    },
                                    child: CircleChild(
                                      avatarRadius: 25,
                                      child: Icon(
                                        Icons.email,
                                      ),
                                    ),
                                  )
                                : Container(),
                            InkWell(
                              onTap: () {
                                CommonChatFunctions.openChat(
                                    context: context,
                                    firstUser: Provider.of<UserProvider>(
                                            context,
                                            listen: false)
                                        .user(),
                                    secondUser: widget.user);
                              },
                              child: CircleChild(
                                avatarRadius: 25,
                                child: Icon(
                                  Icons.chat,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ],
            ),
            Positioned(
              top: 30,
              child: Container(
                margin: const EdgeInsets.only(left: 8.0, top: 8.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.0, 0.8),
                    end: Alignment(0.0, 0.0),
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0),
                      Color.fromRGBO(0, 0, 0, 0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 30, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Positioned(
              left: width * 0.3,
              top: height / 5,
              child: InkWell(
                onTap: widget.user.photoURL != null
                    ? () =>
                        openFullScreenMode([widget.user.photoURL], 'profilePic')
                    : () {},
                child: CircleChild(
                  avatarRadius: 70,
                  child: Hero(
                    tag: 'profilePic',
                    child: FadeInImage(
                      placeholder: AssetImage('assets/profileEmpty.png'),
                      image: NetworkImage(
                        widget.user.photoURL!,
                      ),
                      fit: BoxFit.cover,
                      width: 1000,
                      height: 1000,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnlyChatButton extends StatelessWidget {
  _OnlyChatButton({
    this.secondUser,
  });

  final User? secondUser;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        CommonChatFunctions.openChat(
          context: context,
          firstUser: Provider.of<UserProvider>(context, listen: false).user(),
          secondUser: secondUser!,
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.purple,
      child: Text(
        'CHAT',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
