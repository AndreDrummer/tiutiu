import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/circle_child.dart';
import 'package:tiutiu/Widgets/divider.dart';
import 'package:tiutiu/Widgets/fullscreen_images.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/utils/launcher_functions.dart';

class AnnouncerDetails extends StatefulWidget {
  AnnouncerDetails(this.user);
  final User user;

  @override
  _AnnouncerDetailsState createState() => _AnnouncerDetailsState();
}

class _AnnouncerDetailsState extends State<AnnouncerDetails> {
  int userTotalToDonate = 0;
  int userTotalDonated = 0;
  int userTotalAdopted = 0;
  int userTotalDisap = 0;
  UserController userController = UserController();

  void calculateTotals(user) async {
    PetController petController = PetController();
    DocumentReference userReference = await userController.getReferenceById(user.id);

    QuerySnapshot adopteds = await petController.getPetToCount(userReference, 'Adopted');
    QuerySnapshot donates = await petController.getPetToCount(userReference, 'Donate');
    QuerySnapshot disap = await petController.getPetToCount(userReference, 'Disappeared');
    QuerySnapshot donated = await petController.getPetToCount(userReference, 'Donate', avalaible: false);

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
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final userWhatsapp = widget.user.phoneNumber ?? null;
    final userLandline = widget.user.landline ?? null;
    final userEmail = widget.user.email ?? null;

    void callWhatsapp() {
      FlutterOpenWhatsapp.sendSingleMessage('+55$userWhatsapp', 'Olá!');
    }

    void callLandline() {
      String tel = userLandline != null && userLandline != '' ? userLandline : userWhatsapp;
      Launcher.makePhoneCall('tel: $tel');
    }

    void callEmail() {
      Launcher.sendEmail(emailAddress: userEmail, message: '', subject: '');
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
                  height: height / 2.5,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/fundo.jpg'),
                    image: widget.user.photoBACK != null
                        ? NetworkImage(
                            widget.user.photoBACK,
                          )
                        : AssetImage('assets/fundo.jpg'),
                    fit: BoxFit.cover,
                    width: 1000,
                    height: 100,
                  ),
                ),
                SizedBox(height: 65),
                CustomDivider(text: "${widget.user.name}"),
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
                            style: Theme.of(context).textTheme.headline1.copyWith(
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
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Doados',
                            style: Theme.of(context).textTheme.headline1.copyWith(
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
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Adotados',
                            style: Theme.of(context).textTheme.headline1.copyWith(
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
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Desaparecidos',
                            style: Theme.of(context).textTheme.headline1.copyWith(
                                  color: Colors.black,
                                ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black),
                Spacer(),
                CustomDivider(text: 'Contato'),
                Padding(
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
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 30,
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              left: width * 0.3,
              top: height / 3.5,
              child: InkWell(
                onTap: widget.user.photoURL != null ? () => openFullScreenMode([widget.user.photoURL], 'profilePic') : () {},
                child: CircleChild(
                  avatarRadius: 80,
                  child: Hero(
                    tag: 'profilePic',
                    child: FadeInImage(
                      placeholder: AssetImage('assets/profileEmpty.png'),
                      image: NetworkImage(
                        widget.user.photoURL,
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
