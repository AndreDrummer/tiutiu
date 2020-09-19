import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/circle_child.dart';
import 'package:tiutiu/Widgets/divider.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';
import 'package:tiutiu/utils/launcher_functions.dart';

class AnnouncerDetails extends StatefulWidget {
  @override
  _AnnouncerDetailsState createState() => _AnnouncerDetailsState();
}

class _AnnouncerDetailsState extends State<AnnouncerDetails> {
  int userTotalDonated = 0;
  int userTotalAdopted = 0;
  int userTotalDisap = 0;

  void calculateTotals(user) async {
    PetController petController = PetController();
    QuerySnapshot donates = await petController.getPet(user['uid'], 'Donate');
    QuerySnapshot disap =
        await petController.getPet(user['uid'], 'Disappeared');

    userTotalDisap = disap.docs.length;
    userTotalDonated = donates.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final user =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final userWhatsapp = user['phoneNumber'] ?? null;
    final userLandline = user['landline'] ?? null;
    final userEmail = user['email'] ?? null;

    calculateTotals(user);

    void callWhatsapp() {
      FlutterOpenWhatsapp.sendSingleMessage('+55$userWhatsapp', 'Olá!');
    }

    void callLandline() {
      Launcher.makePhoneCall('tel: $userLandline');
    }

    void callEmail() {
      Launcher.sendEmail(emailAddress: userEmail, message: '', subject: '');
    }

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Background(),
            SizedBox(height: 44),
            Column(
              children: [
                Container(
                  height: height / 2,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/fundo.jpg'),
                    image: NetworkImage(
                      user['photoBACK'] ?? '',
                    ),
                    fit: BoxFit.cover,
                    width: 1000,
                    height: 100,
                  ),
                ),
                SizedBox(height: 80),
                CustomDivider(text: "${user['displayName']}"),
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
                              '3',
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
                                Theme.of(context).textTheme.headline1.copyWith(
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
                                Theme.of(context).textTheme.headline1.copyWith(
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
                                Theme.of(context).textTheme.headline1.copyWith(
                                      color: Colors.black,
                                    ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                CustomDivider(text: ''),
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
                                  child: Icon(PetDetailIcons.whatsapp)))
                          : Container(),
                      userLandline != null
                          ? InkWell(
                              onTap: () {
                                callLandline();
                              },
                              child: CircleChild(
                                  avatarRadius: 25, child: Icon(Icons.phone)))
                          : Container(),
                      userEmail != null
                          ? InkWell(
                              onTap: () {
                                callEmail();
                              },
                              child: CircleChild(
                                  avatarRadius: 25, child: Icon(Icons.email)))
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
              top: height / 2.55,
              child: CircleChild(
                avatarRadius: 80,
                child: FadeInImage(
                  placeholder: AssetImage('assets/profileEmpty.png'),
                  image: NetworkImage(
                    user['photoURL'],
                  ),
                  fit: BoxFit.cover,
                  width: 1000,
                  height: 1000,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
