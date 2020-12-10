import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/Widgets/loading_screen.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/screen/choose_location.dart';
import 'package:tiutiu/screen/pet_form.dart';
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
  UserController userController = UserController();
  PetsProvider petsProvider;
  bool isAuthenticated;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AdsProvider adsProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<QuerySnapshot> myPetsStream() {
    if (widget.kind != null) {
      switch (widget.kind) {
        case Constantes.DONATE:
          return userController.loadMyPostedPetsToDonate(userId: userProvider.uid);
          break;
        case Constantes.DISAPPEARED:
          return userController.loadMyPostedPetsDisappeared(userId: userProvider.uid);
          break;
        default:
          return userController.loadMyAdoptedPets(userId: userProvider.uid);
      }
    } else {
      return userController.loadMyDonatedPets(userProvider.userReference);
    }
  }

  @override
  void didChangeDependencies() {
    userProvider = Provider.of(context, listen: false);

    auth = Provider.of<Authentication>(context);
    petsProvider = Provider.of<PetsProvider>(context);
    isAuthenticated = auth.firebaseUser != null;
    adsProvider = Provider.of(context);
    super.didChangeDependencies();
  }

  void delete(DocumentReference petRef) {
    petController.deletePet(petRef);
    if (widget.kind == Constantes.DONATE) {
      userController.loadMyPostedPetsToDonate(userId: userProvider.uid);
    } else {
      userController.loadMyPostedPetsDisappeared(userId: userProvider.uid);
    }
    userProvider.calculateTotals();
  }

  void _addNewPet() {
    if ((widget.kind != Constantes.ADOPTED || widget.kind == null) && isAuthenticated) {
      Navigator.pushReplacementNamed(context, Routes.CHOOSE_LOCATION, arguments: {'kind': widget.kind});
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => AuthScreen()), ModalRoute.withName(Routes.AUTH));
    }
  }

  void openDialog(Pet pet) {
    showDialog(
      context: context,
      builder: (context) {
        return PopUpMessage(
          error: true,
          title: 'Excluir publicação',
          message: 'Tem certeza que deseja excluir ${pet.name} ?',
          denyAction: () => Navigator.pop(context),
          denyText: 'Não',
          confirmAction: () {
            delete(pet.petReference);
            Navigator.pop(context);
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('${pet.name} foi excluído com sucesso!'),
              ),
            );
          },
          confirmText: 'Sim',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: widget.kind == Constantes.ADOPTED || widget.kind == null
            ? null
            : [
                IconButton(
                  onPressed: _addNewPet,
                  icon: Icon(Icons.add),
                )
              ],
        title: Text(
          widget.title.toUpperCase(),
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      floatingActionButton: widget.kind == Constantes.ADOPTED || widget.kind == null
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _addNewPet,
                  child: Icon(Icons.add),
                ),
              ],
            ),
      body: Stack(
        children: [
          Background(),
          StreamBuilder<QuerySnapshot>(
            stream: myPetsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingScreen(text: 'Carregando meus pets');
              }

              if (snapshot.data == null) {
                return Container();
              }

              List<Pet> pets = petsProvider.getPetListFromSnapshots(snapshot.data.docs);

              if (pets.isEmpty) {
                return EmptyListScreen(
                  text: 'Nenhum PET',
                  icon: Icons.pets_outlined,
                );
              }
              return Column(
                children: [
                  adsProvider.getCanShowAds ? adsProvider.bannerAdMob(adId: adsProvider.topAdId) : Container(),
                  Expanded(
                    child: ListView.builder(
                      key: UniqueKey(),
                      itemCount: pets.length,
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
                                          placeholder: AssetImage('assets/fadeIn.jpg'),
                                          image: NetworkImage(pets[index].avatar),
                                          height: 1000,
                                          width: 1000,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    widget.kind == null || widget.kind == Constantes.ADOPTED
                                        ? Container()
                                        : Positioned(
                                            top: 20,
                                            right: 5,
                                            child: _lablePetKind(pets[index].kind),
                                          )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 15),
                                      child: Container(
                                        width: 160,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              pets[index].name,
                                              style: Theme.of(context).textTheme.headline1.copyWith(
                                                    fontSize: 22,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              pets[index].breed,
                                              style: Theme.of(context).textTheme.headline1.copyWith(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: widget.kind == null || widget.kind == Constantes.ADOPTED
                                          ? Container()
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  ' |',
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.edit, size: 30, color: Colors.black),
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => PopUpMessage(
                                                              title: 'Localização',
                                                              message: 'Deseja alterar a localização do PET ?',
                                                              confirmText: 'Sim',
                                                              confirmAction: () {
                                                                Navigator.pop(context);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) {
                                                                      return ChooseLocation(
                                                                        editMode: true,
                                                                        pet: pets[index],
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              denyText: 'Não',
                                                              denyAction: () {
                                                                Navigator.pop(context);
                                                                Navigator.push(context, MaterialPageRoute(
                                                                  builder: (context) {
                                                                    return PetForm(
                                                                      editMode: true,
                                                                      pet: pets[index],
                                                                      localChanged: false,
                                                                    );
                                                                  },
                                                                ));
                                                              },
                                                            ));
                                                  },
                                                  color: Colors.white,
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete, size: 30, color: Colors.red),
                                                  onPressed: () => openDialog(
                                                    pets[index],
                                                  ),
                                                )
                                              ],
                                            ),
                                    )
                                  ],
                                ),
                                widget.kind == null || widget.kind == Constantes.ADOPTED
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
                                                      return InterestedList(pet: pets[index], kind: pets[index].kind);
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(4.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        style: BorderStyle.solid,
                                                      ),
                                                    ),
                                                    child: Icon(Icons.menu),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        pets[index].kind == Constantes.DONATE ? 'Ver lista de interessados' : 'Ver notificações',
                                                        style: TextStyle(
                                                          decoration: TextDecoration.underline,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 50),
                                                          Text(pets[index].kind == Constantes.DISAPPEARED ? 'Econtrado' : 'Doado'),
                                                          StreamBuilder<Object>(
                                                              stream: null,
                                                              builder: (context, snapshot) {
                                                                return Switch(
                                                                    value: pets[index].kind == Constantes.DISAPPEARED ? pets[index].found : pets[index].donated,
                                                                    onChanged: (value) {
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (context) {
                                                                            return PopUpMessage(
                                                                              warning: true,
                                                                              title: 'Marcar como ${pets[index].kind == Constantes.DISAPPEARED ? 'encontrado' : 'doado'}',
                                                                              message:
                                                                                  'Ao ${!pets[index].found ? 'marcar' : 'desmarcar'} o PET ${!pets[index].found ? 'deixará de' : 'voltará a'} aparecer para o público.',
                                                                              confirmAction: () {
                                                                                Navigator.pop(context);
                                                                                if (pets[index].kind == Constantes.DISAPPEARED) {
                                                                                  pets[index].petReference.set({'found': !pets[index].found}, SetOptions(merge: true));
                                                                                } else {
                                                                                  pets[index].petReference.set({'donated': !pets[index].donated}, SetOptions(merge: true));
                                                                                }
                                                                              },
                                                                              confirmText: !pets[index].found ? 'Pode marcar' : 'Desmarcar',
                                                                              denyAction: () => Navigator.pop(context),
                                                                              denyText: !pets[index].found ? 'Não marcar agora' : 'Não desmarcar',
                                                                            );
                                                                          });
                                                                    });
                                                              }),
                                                        ],
                                                      )
                                                    ],
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
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _lablePetKind(String kind) {
  String textLabel;
  switch (kind) {
    case Constantes.DISAPPEARED:
      textLabel = 'Desaparecido';
      break;
    case Constantes.DONATE:
      textLabel = 'Doação';
  }

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: kind == Constantes.DONATE ? Colors.purple : Colors.black,
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
