import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/donate_disappeared_list.dart';
import 'package:tiutiu/utils/routes.dart';

class PetsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final indexTab = ModalRoute.of(context).settings.arguments;
    final petProvider = Provider.of<PetsProvider>(context);
    void navigateToAuth() {
      Navigator.pushNamed(context, Routes.AUTH, arguments: true);
    }

    return DefaultTabController(
      length: 2,
      initialIndex: indexTab ?? 0,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          title: Row(            
            children: [
              Container(
                padding: const EdgeInsets.all(2.50),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset('assets/pata.jpg',
                    width: 20, height: 20, color: Colors.white),
              ),
              SizedBox(width: 15),
              Text(
                'Tiu, tiu',
                style: GoogleFonts.miltonianTattoo(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
              Spacer(),
              Consumer<UserProvider>(
                builder: (_, userProvider, child) => Consumer<Authentication>(
                  builder: (_, auth, child) => auth.firebaseUser == null
                      ? Container()
                      : Stack(
                          children: [
                            IconButton(
                              onPressed: auth.firebaseUser == null
                                  ? navigateToAuth
                                  : () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.NOTIFICATIONS,
                                      );
                                    },
                              icon: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: UserController().loadNotificationsCount(userProvider.uid),
                              builder: (context, snapshot) {
                                return Positioned(
                                  right: 10,
                                  child: Badge(
                                    color: Colors.red,
                                    text: snapshot.data?.docs?.length ?? 0,
                                  ),
                                );
                              }
                            )
                          ],
                        ),
                ),
              )
            ],
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Tiutiu.dog), text: 'ADOTAR'),
              Tab(icon: Icon(Tiutiu.exclamation), text: 'DESAPARECIDOS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DonateDisappearedList(stream: petProvider.loadDonatedPETS),
            DonateDisappearedList(stream: petProvider.loadDisappearedPETS),
          ],
        ),
      ),
    );
  }
}
