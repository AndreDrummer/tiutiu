import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/circle_child.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:tiutiu/providers/pets_provider.dart';

class ConfirmAdoptionScreen extends StatefulWidget {
  @override
  _ConfirmAdoptionScreenState createState() => _ConfirmAdoptionScreenState();
}

class _ConfirmAdoptionScreenState extends State<ConfirmAdoptionScreen> {
  // UserProvider userProvider;

  bool confirmingAdoption = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // AdsProvider adsProvider;
  late PetsProvider petsProvider;

  void changeConfirmingOrDenyAdoptionStatus(bool value) {
    setState(() {
      confirmingAdoption = value;
    });
  }

  Future<void> denyOrConfirmAdoption({
    DocumentReference? petRef,
    DocumentReference? userRef,
    bool? confirmAction,
    String? petName,
  }) async {
    String title = confirmAction! ? 'Confirmar adoção' : 'Negar adoção';
    String message = confirmAction
        ? 'Tem certeza que adotou $petName ?'
        : 'Tem certeza que NÃO adotou $petName ?';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopUpMessage(
        error: !confirmAction,
        title: title,
        message: message,
        denyAction: () => Navigator.pop(context),
        denyText: 'Não',
        confirmText: 'Sim',
        confirmAction: () async {},
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // //
    petsProvider = Provider.of<PetsProvider>(context);
    // adsProvider = Provider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Adoções pendentes de confirmação')),
      body: StreamBuilder<QuerySnapshot>(
        // stream: tiutiuUserController.tiutiuUseradoptionToConfirm(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.length == 0 || snapshot.data == null) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nenhuma notificação para adoção.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w100,
                        ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.sentiment_satisfied_alt_outlined)
                ],
              ),
            );
          }

          List<Pet> pets =
              petsProvider.getPetListFromSnapshots(snapshot.data!.docs);

          return Column(
            children: [
              // adsProvider.getCanShowAds
              // // ? adsProvider.bannerAdMob(adId: adsProvider.topAdId)
              // : Container(),
              Expanded(
                child: ListView.builder(
                  key: UniqueKey(),
                  itemCount: pets.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: FadeInImage(
                              placeholder: AssetImage('assets/fundo.jpg'),
                              image: AssetHandle(
                                pets[index].avatar,
                              ).build(),
                              fit: BoxFit.cover,
                              width: 1000,
                              height: 100,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pets[index].name!,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                pets[index].breed!,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2),
                        Expanded(
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    CircleChild(
                                        child: Icon(Icons.done),
                                        avatarRadius: 20,
                                        color: Colors.green),
                                    Text(
                                      'Confirmar',
                                      style: TextStyle(fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.025),
                              InkWell(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    CircleChild(
                                        child: Icon(Icons.close),
                                        avatarRadius: 20,
                                        color: Colors.red),
                                    Text('Negar',
                                        style: TextStyle(fontSize: 10))
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ]),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
