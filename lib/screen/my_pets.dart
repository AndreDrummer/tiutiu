import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/loading_screen.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/screen/choose_location.dart';
import 'package:tiutiu/utils/routes.dart';
import 'interested_information_list.dart';

class MyPetsScreen extends StatefulWidget {
  MyPetsScreen({this.streamBuilder, this.title, this.kind, this.userId});

  final String title;
  final String userId;
  final String kind;
  final Stream streamBuilder;

  @override
  _MyPetsScreenState createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  UserProvider userProvider;
  Authentication auth;
  PetController petController = PetController();
  bool isAuthenticated;

  @override
  void didChangeDependencies() {
    userProvider = Provider.of(context, listen: false);
    if (widget.kind != null) {
      userProvider.loadMyPets(kind: widget.kind);
    } else {
      print('Load donated');
      userProvider.loadDonatedPets(widget.userId);
    }
    auth = Provider.of<Authentication>(context);
    isAuthenticated = auth.firebaseUser != null;
    super.didChangeDependencies();
  }

  void delete(DocumentReference petRef) {
    petController.deletePet(petRef);
    userProvider.loadMyPets(kind: widget.kind);
    userProvider.calculateTotals();
  }

  void _addNewPet() {
    if ((widget.kind != 'Adopted' || widget.kind == null) && isAuthenticated) {
      Navigator.pushReplacementNamed(context, Routes.CHOOSE_LOCATION,
          arguments: {'kind': widget.kind});
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => AuthScreen()),
          ModalRoute.withName(Routes.AUTH));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: widget.kind == 'Adopted' || widget.kind == null
            ? null
            : [
                IconButton(
                  onPressed: _addNewPet,
                  icon: Icon(Icons.add),
                )
              ],
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      floatingActionButton: widget.kind == 'Adopted' || widget.kind == null
          ? null
          : FloatingActionButton(
              onPressed: _addNewPet,
              child: Icon(Icons.add),
            ),
      body: RefreshIndicator(
        onRefresh: () => userProvider.loadMyPets(kind: widget.kind),
        child: Stack(
          children: [
            Background(),
            StreamBuilder<List<Pet>>(
              stream: widget.streamBuilder,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingScreen(text: 'Carregando meus pets');
                }
                if (snapshot.data.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum PET',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                          ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: height / 3.5,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: FadeInImage(
                                      placeholder:
                                          AssetImage('assets/fadeIn.jpg'),
                                      image: NetworkImage(
                                          snapshot.data[index].avatar),
                                      height: 1000,
                                      width: 1000,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                widget.kind == null || widget.kind == 'Adopted'
                                    ? Container()
                                    : Positioned(
                                        top: 20,
                                        right: 5,
                                        child: _lablePetKind(
                                            snapshot.data[index].kind),
                                      )
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 15),
                                  child: Container(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data[index].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(
                                                fontSize: 22,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          snapshot.data[index].breed,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Spacer(),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                Expanded(
                                  flex: 2,
                                  child: widget.kind == null ||
                                          widget.kind == 'Adopted'
                                      ? Container()
                                      : Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.amber),
                                              child: IconButton(
                                                icon: Icon(Icons.mode_edit),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return ChooseLocation(
                                                          editMode: true,
                                                          petReference: snapshot
                                                              .data[index]
                                                              .petReference,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red),
                                              child: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  delete(
                                                    snapshot.data[index]
                                                        .petReference,
                                                  );
                                                },
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                )
                              ],
                            ),
                            widget.kind == null || widget.kind == 'Adopted'
                                ? Container()
                                : Column(
                                    children: [
                                      Divider(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return InterestedList(
                                                      pet: snapshot.data[index],
                                                      kind: snapshot
                                                          .data[index].kind);
                                                },
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    style: BorderStyle.solid,
                                                  ),
                                                ),
                                                child: Icon(Icons.menu),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                snapshot.data[index].kind ==
                                                        'Donate'
                                                    ? 'Ver lista de interessados'
                                                    : 'Ver notificações',
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _lablePetKind(String kind) {
  String textLabel;
  switch (kind) {
    case 'Disappeared':
      textLabel = 'Desaparecido';
      break;
    case 'Donate':
      textLabel = 'Doação';
  }

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: kind == 'Donate' ? Colors.purple : Colors.black,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        textLabel,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
