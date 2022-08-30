import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/circle_child.dart';
import 'package:tiutiu/Widgets/divider.dart';
import 'package:tiutiu/Widgets/fullscreen_images.dart';

import 'package:tiutiu/features/pets/services/pet_service.dart';
import 'package:tiutiu/features/system/controllers.dart';

import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/chat/common/functions.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';

class AnnouncerDetails extends StatefulWidget {
  AnnouncerDetails(
    this.user, {
    this.showOnlyChat = false,
  });

  final TiutiuUser user;
  final bool showOnlyChat;

  @override
  _AnnouncerDetailsState createState() => _AnnouncerDetailsState();
}

class _AnnouncerDetailsState extends State<AnnouncerDetails> {
  // AdsProvider adsProvider;
  int userTotalToDonate = 0;
  int userTotalDonated = 0;
  int userTotalAdopted = 0;
  int userTotalDisap = 0;

  void calculateTotals(user) async {
    PetService petService = PetService.instance;
    DocumentReference userReference = await OtherFunctions.getReferenceById(
      tiutiuUserController.tiutiuUser.uid!,
      FirebaseEnvPath.users,
    );

    QuerySnapshot adopteds =
        await petService.getPetToCount(userReference, FirebaseEnvPath.adopted);
    QuerySnapshot donates =
        await petService.getPetToCount(userReference, FirebaseEnvPath.donate);
    QuerySnapshot disap = await petService.getPetToCount(
        userReference, FirebaseEnvPath.disappeared);
    QuerySnapshot donated = await petService
        .getPetToCount(userReference, FirebaseEnvPath.donate, avalaible: false);

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
                    placeholder: AssetImage(ImageAssets.fundo),
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
                    text: "${widget.user.displayName!.capitalize()}",
                    fontSize: 18),
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
                                Theme.of(context).textTheme.headline4!.copyWith(
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
                                Theme.of(context).textTheme.headline4!.copyWith(
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
                                Theme.of(context).textTheme.headline4!.copyWith(
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
                                Theme.of(context).textTheme.headline4!.copyWith(
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
                                  firstUser: tiutiuUserController.tiutiuUser,
                                  secondUser: widget.user,
                                  context: context,
                                );
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
                      placeholder:
                          AssetHandle(ImageAssets.profileEmpty).build(),
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

  final TiutiuUser? secondUser;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        CommonChatFunctions.openChat(
          firstUser: tiutiuUserController.tiutiuUser,
          secondUser: secondUser!,
          context: context,
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        primary: Colors.purple,
      ),
      child: Text(
        'chat',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
