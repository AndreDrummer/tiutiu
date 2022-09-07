import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:tiutiu/features/pets/services/pet_service.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/Widgets/loading_screen.dart';
import 'package:tiutiu/screen/choose_location.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/screen/pet_form.dart';
import 'interested_information_list.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MyPetsScreen extends StatefulWidget {
  MyPetsScreen({this.streamBuilder, this.title, this.kind, this.userId});

  final Stream? streamBuilder;
  final String? userId;
  final String? title;
  final String? kind;

  @override
  _MyPetsScreenState createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  late GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PetService petService = PetService.instance;

  // late AdsProvider adsProvider;
  late bool isAuthenticated;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    isAuthenticated = authController.firebaseUser != null;
    // adsProvider = Provider.of(context);
    super.didChangeDependencies();
  }

  void delete(DocumentReference petRef) {
    petService.deletePet(petRef);
  }

  void _addNewPet() {
    if ((widget.kind != FirebaseEnvPath.adopted || widget.kind == null) &&
        isAuthenticated) {
      Navigator.pushReplacementNamed(context, Routes.pet_location_picker,
          arguments: {'kind': widget.kind});
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => AuthScreen()),
          ModalRoute.withName(Routes.auth));
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
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AutoSizeText('${pet.name} foi excluído com sucesso!'),
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
        actions: widget.kind == FirebaseEnvPath.adopted || widget.kind == null
            ? null
            : [
                IconButton(
                  onPressed: _addNewPet,
                  icon: Icon(Icons.add),
                )
              ],
        title: AutoSizeText(
          widget.title!.toUpperCase(),
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      floatingActionButton:
          widget.kind == FirebaseEnvPath.adopted || widget.kind == null
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
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingScreen(text: 'Carregando meus pets');
              }

              if (snapshot.data == null) {
                return Container();
              }

              List<Pet> pets =
                  petsController.getPetListFromSnapshots(snapshot.data!.docs);

              if (pets.isEmpty) {
                return EmptyListScreen(
                  text: 'Nenhum PET',
                  icon: Icons.pets_outlined,
                );
              }
              return Column(
                children: [
                  // adsProvider.getCanShowAds
                  //     ? adsProvider.bannerAdMob(adId: adsProvider.topAdId)
                  //     : Container(),
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
                                          placeholder:
                                              AssetHandle(ImageAssets.fadeIn)
                                                  .build(),
                                          image: NetworkImage(
                                              pets[index].photos!.first!),
                                          height: 1000,
                                          width: 1000,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    widget.kind == null ||
                                            widget.kind ==
                                                FirebaseEnvPath.adopted
                                        ? Container()
                                        : Positioned(
                                            top: 20,
                                            right: 5,
                                            child: _lablePetKind(
                                                pets[index].kind!),
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
                                            AutoSizeText(
                                              pets[index].name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4!
                                                  .copyWith(
                                                    fontSize: 22,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            SizedBox(height: 10),
                                            AutoSizeText(
                                              pets[index].breed!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4!
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
                                    Expanded(
                                      flex: 2,
                                      child: widget.kind == null ||
                                              widget.kind ==
                                                  FirebaseEnvPath.adopted
                                          ? Container()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                AutoSizeText(
                                                  ' |',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.edit,
                                                      size: 30,
                                                      color: Colors.black),
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            PopUpMessage(
                                                              title:
                                                                  'Localização',
                                                              message:
                                                                  'Deseja alterar a localização do PET ?',
                                                              confirmText:
                                                                  'Sim',
                                                              confirmAction:
                                                                  () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                      return ChooseLocation(
                                                                        editMode:
                                                                            true,
                                                                        pet: pets[
                                                                            index],
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              denyText: 'Não',
                                                              denyAction: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                    return PetForm(
                                                                      editMode:
                                                                          true,
                                                                      pet: pets[
                                                                          index],
                                                                      localChanged:
                                                                          false,
                                                                    );
                                                                  },
                                                                ));
                                                              },
                                                            ));
                                                  },
                                                  color: Colors.white,
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete,
                                                      size: 30,
                                                      color: AppColors.danger),
                                                  onPressed: () => openDialog(
                                                    pets[index],
                                                  ),
                                                )
                                              ],
                                            ),
                                    )
                                  ],
                                ),
                                widget.kind == null ||
                                        widget.kind == FirebaseEnvPath.adopted
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
                                                          pet: pets[index],
                                                          kind:
                                                              pets[index].kind);
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
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                    ),
                                                    child: Icon(Icons.menu),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AutoSizeText(
                                                        pets[index].kind ==
                                                                FirebaseEnvPath
                                                                    .donate
                                                            ? 'Ver lista de interessados'
                                                            : 'Ver notificações',
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 50),
                                                          AutoSizeText(pets[
                                                                          index]
                                                                      .kind ==
                                                                  FirebaseEnvPath
                                                                      .disappeared
                                                              ? 'Econtrado'
                                                              : 'Doado'),
                                                          StreamBuilder<Object>(
                                                              stream: null,
                                                              builder: (context,
                                                                  snapshot) {
                                                                return Switch(
                                                                    value: pets[
                                                                            index]
                                                                        .donatedOrFound,
                                                                    onChanged:
                                                                        (value) {
                                                                      print(
                                                                          "PET ${pets[index].toMap()}");
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            final bool
                                                                                textToDisplay =
                                                                                pets[index].donatedOrFound;
                                                                            return PopUpMessage(
                                                                              warning: true,
                                                                              title: '${!textToDisplay ? 'Marcar' : 'Desmarcar'} como ${pets[index].kind == FirebaseEnvPath.disappeared ? 'encontrado' : 'doado'}',
                                                                              message: 'Ao ${!textToDisplay ? 'marcar' : 'desmarcar'} o PET ${!textToDisplay ? 'deixará de' : 'voltará a'} aparecer para o público.',
                                                                              confirmAction: () {
                                                                                Navigator.pop(context);
                                                                                if (pets[index].kind == FirebaseEnvPath.disappeared) {
                                                                                } else {}
                                                                              },
                                                                              confirmText: !textToDisplay ? 'Pode marcar' : 'Desmarcar',
                                                                              denyAction: () => Navigator.pop(context),
                                                                              denyText: !textToDisplay ? 'Não marcar agora' : 'Não desmarcar',
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
  late String textLabel;
  switch (kind) {
    case FirebaseEnvPath.disappeared:
      textLabel = 'Desaparecido';
      break;
    case FirebaseEnvPath.donate:
      textLabel = 'Doação';
  }

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color:
          kind == FirebaseEnvPath.donate ? AppColors.secondary : Colors.black,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: AutoSizeText(
        '$textLabel',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
