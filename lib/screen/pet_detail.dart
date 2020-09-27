import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/card_details.dart';
import 'package:tiutiu/Widgets/divider.dart';
import 'package:tiutiu/Widgets/dots_indicator.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/favorites_provider.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/user_infos_interests.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/announcer_datails.dart';
import 'package:tiutiu/utils/formatter.dart';
import 'package:tiutiu/utils/launcher_functions.dart';

class PetDetails extends StatefulWidget {
  PetDetails({
    this.kind,
    this.pet,
    this.petOwner,
    this.isMine,
  });

  final String kind;
  final Pet pet;
  final User petOwner;
  final bool isMine;

  @override
  _PetDetailsState createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  final PageController _pageController = PageController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FavoritesProvider favoritesProvider;

  Location userLocation;
  UserInfoOrAdoptInterestsProvider userInfosAdopts;
  Authentication auth;
  UserProvider userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userLocation = Provider.of<Location>(context, listen: false);
    auth = Provider.of<Authentication>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userInfosAdopts =
        Provider.of<UserInfoOrAdoptInterestsProvider>(context, listen: false);
    userInfosAdopts.checkInfo(widget.pet.petReference, auth.firebaseUser.uid);
    userInfosAdopts.checkInterested(
        widget.pet.petReference, auth.firebaseUser.uid);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<FavoritesProvider>(context, listen: false)
        .loadFavoritesReference();
  }

  Map<String, dynamic> petIconType = {
    'Cachorro': Tiutiu.dog,
    'Gato': Tiutiu.cat,
    'Pássaro': Tiutiu.twitter_bird,
    'Hamster': Tiutiu.hamster,
    'Outro': Tiutiu.question,
  };

  @override
  Widget build(BuildContext context) {
    List petDetails = [
      {
        'title': 'TIPO',
        'text': widget.pet.type,
        'icon': petIconType[widget.pet.type]
      },
      {'title': 'RAÇA', 'text': widget.pet.breed, 'icon': Icons.linear_scale},
      {
        'title': 'TAMANHO',
        'text': widget.pet.size,
        'icon': Tiutiu.resize_small
      },
      {
        'title': 'SAÚDE',
        'text': widget.pet.health,
        'icon': Tiutiu.healing
      },
      {
        'title': 'IDADE',
        'text': '${widget.pet.ano}a ${widget.pet.meses}m',
        'icon': Tiutiu.birthday_cake
      },
    ];    

    List ownerDetails = [
      {
        'uid': widget.petOwner.id,
        'text': widget.petOwner.name ?? '',
        'launchIcon': Icons.remove_red_eye,
        'imageN': widget.petOwner.photoURL ?? '',
        'callback': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AnnouncerDetails(widget.petOwner);
              },
            ),
          );
        },
      },
      {
        'text': widget.petOwner.betterContact == 0
            ? widget.petOwner.phoneNumber
            : widget.petOwner.betterContact == 1
                ? widget.petOwner.landline
                : widget.petOwner.email,
        'icon': widget.petOwner.betterContact == 0
            ? Tiutiu.whatsapp
            : widget.petOwner.betterContact == 1 ? Icons.phone : Icons.email,
        'color': widget.petOwner.betterContact == 0
            ? Colors.green
            : widget.petOwner.betterContact == 1 ? Colors.orange : Colors.red,
        'callback': () {
          String serializedNumber =
              Formatter.unmaskNumber(widget.petOwner.phoneNumber);

          if (widget.petOwner.betterContact == 0) {
            FlutterOpenWhatsapp.sendSingleMessage('+55$serializedNumber',
                'Olá! Tenho interesse e gostaria de saber mais detalhes sobre o PET *${widget.pet.name}* que postou no app *_Tiu, Tiu_*.');
          } else if (widget.petOwner.betterContact == 1) {
            String serializedNumber =
                Formatter.unmaskNumber(widget.petOwner.landline);
            Launcher.makePhoneCall('tel: $serializedNumber');
          } else {
            Launcher.sendEmail(
              emailAddress: widget.petOwner.email,
              subject: 'Tenho interesse no PET ${widget.pet.name}',
              message:
                  'Olá! Tenho interesse e gostaria de saber mais detalhes sobre o PET ${widget.pet.name} que postou no app Tiu, Tiu.',
            );
          }
        }
      },
      {
        'text': 'Localização',
        'image': 'assets/static_map.jpg',
        // 'imageN': 'https://maps.googleapis.com/maps/api/staticmap?center=${pet.latitude}, ${pet.longitude}&zoom=14&markers=color&markers=color:red%7Clabel:%7c-16.7502014,%20-49.256370000000004&size=600x400&key=${Constantes.WEB_API_KEY}',
        'callback': () {
          MapsLauncher.launchCoordinates(
            widget.pet.latitude,
            widget.pet.longitude,
            widget.pet.name,
          );
        }
      },
    ];    

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Detalhes de ${widget.pet.name}', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'assets/cao e gato.png',
                ),
              )),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                showImages(widget.pet.photos),
                Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: petDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CardDetails(
                          title: petDetails[index]['title'],
                          icon: petDetails[index]['icon'],
                          text: petDetails[index]['text'],
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8.0,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: 0.0, maxHeight: 120),
                          child: Container(
                            width: double.infinity,
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          'Descrição',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(color: Colors.black54),
                                        ),
                                      ),
                                      Divider(),
                                      Text(widget.pet.details),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
                SizedBox(height: 5),
                CustomDivider(text: 'Informações do anunciante'),
                Container(
                  height: 170,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ownerDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return UserCardInfo(
                          text: ownerDetails[index]['text'],
                          icon: ownerDetails[index]['icon'],
                          image: ownerDetails[index]['image'],
                          imageN: ownerDetails[index]['imageN'],
                          color: ownerDetails[index]['color'],
                          callback: ownerDetails[index]['callback'],
                          launchIcon: ownerDetails[index]['launchIcon'],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 140.0),
              ],
            ),
          ),
          !widget.isMine
              ? Positioned(
                  bottom: 18.0,
                  left: widget.kind == 'DONATE'
                      ? 20.0
                      : MediaQuery.of(context).size.width * 0.17,
                  child: ButtonWide(
                    text: widget.kind == 'DONATE'
                        ? 'QUERO ADOTAR'
                        : 'VI ELE AQUI PERTO',
                    color: widget.kind == 'DONATE'
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                    action: () async {
                      final petRef = await widget.pet.petReference.get();
                      final userLocal = userLocation.location;

                      int userPosition = 1;
                      bool canSend = true;
                      String messageTextSnackBar;
                      if (widget.kind == 'DONATE') {
                        if (userInfosAdopts.getAdoptInterest
                            .contains(widget.pet.id)) {
                          setState(() {
                            canSend = false;
                          });
                          messageTextSnackBar =
                              '${ownerDetails[0]['text']} já sabe sobre seu interesse. Aguarde retorno.';
                        } else {
                          if (petRef.data()['adoptInteresteds'] != null) {
                            userPosition =
                                petRef.data()['adoptInteresteds'].length + 1;
                          }
                          messageTextSnackBar =
                              'Você é o $userPositionº interessado no ${widget.pet.name}. Te avisaremos caso o dono aceite seu pedido de adoção!';
                        }
                      } else {
                        if (userInfosAdopts.getInfos.contains(widget.pet.id)) {
                          setState(() {
                            canSend = false;
                          });
                          messageTextSnackBar =
                              'Você já passou informação sobre este PET.';
                        } else {
                          if (petRef.data()['infoInteresteds'] != null) {
                            userPosition =
                                petRef.data()['infoInteresteds'].length + 1;
                          } else {
                            userPosition = 1;
                          }
                          messageTextSnackBar =
                              'Obrigado pela informação! ${ownerDetails[0]['text']} será avisado.';
                        }
                      }

                      if (canSend) {
                        PetController petController = new PetController();
                        petController.showInterestOrInfo(
                            widget.pet.petReference,
                            userProvider.userReference,
                            userLocal,
                            userPosition,
                            isAdopt: widget.kind == 'DONATE');
                        if (widget.kind == 'DONATE') {
                          userInfosAdopts.insertAdoptInterest(widget.pet.id);
                        } else {
                          userInfosAdopts.insertInfos(widget.pet.id);
                        }
                      }

                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Row(
                          children: [
                            Expanded(
                              child: Text(messageTextSnackBar),
                            ),
                          ],
                        ),
                        duration: Duration(seconds: 5),
                      ));
                    },
                  ),
                )
              : Positioned(                
                  bottom: 0.0,                  
                  child: ButtonWide(
                    isToExpand: true,
                    rounded: false,
                    action: () {},
                    text: widget.kind == 'DONATE'
                        ? 'VOCÊ ESTÁ DOANDO'
                        : 'VOCÊ ESTÁ PROCURANDO',
                  ),
                )
        ],
      ),
      floatingActionButton: (!widget.isMine && widget.kind == 'DONATE')
          ? Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
                bool isFavorite = favoritesProvider.getFavoritesPETSIDList
                    .contains(widget.pet.id);
                return FloatingActionButton(
                  onPressed: () async {
                    final user = UserController();
                    final auth =
                        Provider.of<Authentication>(context, listen: false);

                    await user.favorite(auth.firebaseUser.uid,
                        widget.pet.petReference, !isFavorite);

                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text(isFavorite
                          ? 'Removido dos favoritos'
                          : 'Adicionado como favorito'),
                    ));

                    favoritesProvider.loadFavoritesReference();
                    favoritesProvider.handleFavorite(widget.pet.id);
                  },
                  tooltip: isFavorite ? 'Favorito' : 'Favoritar',
                  backgroundColor: isFavorite ? Colors.white : Colors.red,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                );
              },
            )
          : null,
    );
  }

  Widget showImages(Map photos) {
    return Stack(
      children: [
        Container(
          color: Colors.blueGrey[50],
          height: MediaQuery.of(context).size.height / 3,
          width: double.infinity,
          child: PageView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: photos.values.length,
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                photos.values.elementAt(index),
                fit: BoxFit.fill,
                loadingBuilder: loadingImage,
              );
            },
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: DotsIndicator(
              controller: _pageController,
              itemCount: photos.values.length,
              onPageSelected: (int page) {
                _pageController.animateToPage(
                  page,
                  duration: Duration(
                    milliseconds: 500,
                  ),
                  curve: Curves.ease,
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget loadingImage(
      BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Carregando imagem..'),
          LoadingJumpingLine.circle(),
        ],
      ),
    );
  }
}
