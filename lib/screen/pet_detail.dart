import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:share/share.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/card_details.dart';
import 'package:tiutiu/Widgets/dots_indicator.dart';
import 'package:tiutiu/Widgets/fullscreen_images.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/Widgets/pop_up_text_field.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/favorites_provider.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:tiutiu/providers/location.dart' as provider;
import 'package:tiutiu/providers/user_infos_interests.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/announcer_datails.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/utils/formatter.dart';
import 'package:tiutiu/utils/launcher_functions.dart';
import 'package:tiutiu/utils/other_functions.dart';
import 'package:tiutiu/utils/routes.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/play_store_rating.dart';
import "package:google_maps_webservice/geocoding.dart";

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

  provider.Location userLocation;
  UserInfoOrAdoptInterestsProvider userInfosAdopts;
  Authentication auth;
  UserProvider userProvider;
  bool isAuthenticated = false;
  bool interestOrInfoWasFired;
  int timeToSendRequestAgain = 120;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userLocation = Provider.of<provider.Location>(context, listen: false);
    auth = Provider.of<Authentication>(context);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userInfosAdopts = Provider.of<UserInfoOrAdoptInterestsProvider>(context, listen: false);
    isAuthenticated = auth.firebaseUser != null;
    if (isAuthenticated) {
      userInfosAdopts.checkInfo(widget.pet.petReference, userProvider.userReference);
      userInfosAdopts.checkInterested(widget.pet.petReference, userProvider.userReference);
    }
  }

  String timeFormmated(int minutes) {
    int hour = minutes ~/ 60;
    int min = minutes % 60;
    if (hour == 0 && min == 1) {
      return '$min minuto';
    } else if (hour > 1 && min == 0) {
      return '$hour horas';
    } else if (hour == 1 && min == 0) {
      return '$hour hora';
    } else if (hour == 0 && min > 1) {
      return '$min minutos';
    } else if (hour == 1 && min == 1) {
      return '$hour hora e $min minuto';
    } else if (hour == 1 && min > 1) {
      return '$hour hora e $min minutos';
    } else if (hour > 1 && min == 1) {
      return '$hour horas e $min minuto';
    } else {
      return '$hour horas e $min minutos';
    }
  }

  @override
  void initState() {
    super.initState();
    interestOrInfoWasFired = false;
    Provider.of<UserInfoOrAdoptInterestsProvider>(context, listen: false).changeLastimeInterestOrInfo(null);
    if (isAuthenticated) Provider.of<FavoritesProvider>(context, listen: false).loadFavoritesReference();
  }

  Map<String, dynamic> petIconType = {
    'Cachorro': Tiutiu.dog,
    'Gato': Tiutiu.cat,
    'Pássaro': Tiutiu.twitter_bird,
    'Hamster': Tiutiu.hamster,
    'Outro': Tiutiu.question,
  };

  void navigateToAuth() {
    Navigator.pushNamed(context, Routes.AUTH, arguments: true);
  }

  Future<void> passInfoDetails(int userPosition) async {
    TextEditingController controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return PopupTextField(
          controller: controller,
          callback: () {
            Navigator.pop(context);
            sendData(userPosition, controller.text);
          },
        );
      },
    );
  }

  void sendData(int userPosition, [String details]) {
    PetController petController = new PetController();
    final userLocal = userLocation.getLocation;

    petController.showInterestOrInfo(
      petName: widget.pet.name,
      petAvatar: widget.pet.avatar,
      petBreed: widget.pet.breed,
      interestedNotificationToken: userProvider.notificationToken,
      ownerNotificationToken: widget.petOwner.notificationToken,
      interestedID: userProvider.uid,
      ownerID: widget.petOwner.id,
      interestedName: userProvider.displayName,
      petReference: widget.pet.petReference,
      userReference: userProvider.userReference,
      interestedAt: DateTime.now().toIso8601String(),
      userLocation: userLocal,
      userPosition: userPosition,
      infoDetails: details,
      isAdopt: widget.kind == 'DONATE',
    );

    setState(() {
      interestOrInfoWasFired = true;
    });

    userInfosAdopts.changeLastimeInterestOrInfo(DateTime.now().toIso8601String());
  }

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(message),
          ),
        ],
      ),
      duration: Duration(seconds: 5),
    ));
  }

  void showInterestOrPassInfo(String ownerName) async {
    final petRef = await widget.pet.petReference.get();
    int userPosition = 1;
    String messageTextSnackBar;
    int hoursSinceLastRequest = DateTime.now().difference(DateTime.parse(userInfosAdopts.getLastimeInterestOrInfo ?? Constantes.APP_BIRTHDAY)).inMinutes;
    switch (widget.kind) {
      case 'DONATE':
        if (hoursSinceLastRequest < timeToSendRequestAgain) {
          messageTextSnackBar =
              '$ownerName já sabe sobre seu interesse. Você pode tentar enviar outra solicitação dentro de ${timeFormmated(timeToSendRequestAgain - hoursSinceLastRequest)}.';
          showSnackBar(messageTextSnackBar);
        } else {
          await PetController().deleteOldInterest(petRef.reference, userProvider.userReference);
          var adoptInterestedsRef = await petRef.reference.collection('adoptInteresteds').get();
          if (adoptInterestedsRef.docs.isNotEmpty) {
            userPosition = adoptInterestedsRef.docs.length + 1;
          }
          messageTextSnackBar = 'Você é o $userPositionº interessado no ${widget.pet.name}. Te avisaremos caso o dono aceite seu pedido de adoção!';
          sendData(userPosition);
          showSnackBar(messageTextSnackBar);
        }
        break;
      default:
        var infoInterestedsRef = await petRef.reference.collection('infoInteresteds').get();

        if (infoInterestedsRef.docs.isNotEmpty) {
          infoInterestedsRef.docs.length + 1;
        } else {
          userPosition = 1;
        }

        messageTextSnackBar = 'Obrigado pela informação! $ownerName será avisado.';

        passInfoDetails(userPosition).then((value) {
          if (interestOrInfoWasFired) showSnackBar(messageTextSnackBar);
        });
    }
  }

  Future<String> _downloadFile() async {
    String filename = OtherFunctions.getPhotoName(widget.pet.avatar, widget.pet.storageHashKey);
    StorageReference ref =
        FirebaseStorage.instance.ref().child('${widget.pet.ownerId}/').child('petsPhotos/${widget.pet.kind}/${widget.pet.storageHashKey}/$filename');
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/pet.jpg');

    if (tempFile.existsSync()) {
      await tempFile.delete();
    }

    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    await task.future;

    return tempFile.path;
  }

  Future<Uri> generateDynamicLink() async {
    String uriPrefix = Constantes.DYNAMIC_LINK_PREFIX;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse('$uriPrefix/${widget.pet.kind}/${widget.pet.id}'),
      androidParameters: AndroidParameters(
        packageName: 'com.anjasolutions.tiutiu',
        minimumVersion: 1,
      ),
    );

    final dynamicUrl = await parameters.buildUrl();
    return dynamicUrl;
  }

  Future<void> sharePet() async {
    String subject = 'Hey! Dá uma olhada nesse bichinho.';
    String message = 'Encontre este e vários outros no aplicativo Tiu, tiu: ${await generateDynamicLink()}';
    String tags = '#tiutiu #adocao #pets';
    String followUs = 'Siga @tiutiuapp no Instagram.';
    try {
      userProvider.changeIsGeneratingSharedLink(true);
      String filePath = await _downloadFile();
      userProvider.changeIsGeneratingSharedLink(false);
      Share.shareFiles(['$filePath'], text: '$subject\n$message\n$tags\n$followUs', subject: subject);
    } catch (e) {
      userProvider.changeIsGeneratingSharedLink(false);
      Share.share('$subject\n$message\n$tags\n$followUs', subject: subject);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final String whatsappMessage = 'Olá! Tenho interesse e gostaria de saber mais detalhes sobre o PET *${widget.pet.name}* que postou no app *_Tiu, Tiu_*.';
    final String emailMessage = 'Olá! Tenho interesse e gostaria de saber mais detalhes sobre o PET ${widget.pet.name} que postou no app Tiu, Tiu.';
    final String emailSubject = 'Tenho interesse no PET ${widget.pet.name}';

    double wannaAdoptButton = widget.kind == 'DONATE' ? width * 0.7 : width * 0.8;
    List otherCaracteristics = widget.pet?.otherCaracteristics ?? ['Teste'];
    List petDetails = [
      {'title': 'TIPO', 'text': widget.pet.type, 'icon': petIconType[widget.pet.type]},
      {'title': 'SEXO', 'text': widget.pet.sex, 'icon': Icons.all_inclusive_outlined},
      {'title': 'RAÇA', 'text': widget.pet.breed, 'icon': Icons.linear_scale},
      {'title': 'TAMANHO', 'text': widget.pet.size, 'icon': Tiutiu.resize_small},
      {'title': 'SAÚDE', 'text': widget.pet.health, 'icon': Tiutiu.healing},
      {'title': 'IDADE', 'text': '${widget.pet.ano}a ${widget.pet.meses}m', 'icon': Tiutiu.birthday_cake},
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
            : widget.petOwner.betterContact == 1
                ? Icons.phone
                : Icons.email,
        'color': widget.petOwner.betterContact == 0
            ? Colors.green
            : widget.petOwner.betterContact == 1
                ? Colors.orange
                : Colors.red,
        'callback': () {
          String serializedNumber = Formatter.unmaskNumber(widget.petOwner.phoneNumber);

          if (widget.petOwner.betterContact == 0) {
            FlutterOpenWhatsapp.sendSingleMessage('+55$serializedNumber', whatsappMessage);
          } else if (widget.petOwner.betterContact == 1) {
            String serializedNumber = Formatter.unmaskNumber(widget.petOwner.landline);
            Launcher.makePhoneCall(number: serializedNumber);
          } else {
            Launcher.sendEmail(emailAddress: widget.petOwner.email, subject: emailSubject, message: emailMessage);
          }
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
        title: Text(
          'Detalhes de ${widget.pet.name}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          // Stack(
          //   children: [
          //     IconButton(
          //       onPressed: !isAuthenticated ? navigateToAuth : () {},
          //       color: Colors.white,
          //       icon: Icon(Icons.chat),
          //     ),
          //     Positioned(
          //       top: 2,
          //       right: 10,
          //       child: Badge(text: 'Em breve', color: Colors.purple, textSize: 6),
          //     ),
          //   ],
          // ),
          IconButton(icon: Icon(Icons.share), onPressed: sharePet)
        ],
      ),
      body: Stack(
        children: [
          Background(
            dark: true,
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
                      itemCount: petDetails.length + otherCaracteristics.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < petDetails.length) {
                          return CardDetails(
                            title: petDetails[index]['title'],
                            icon: petDetails[index]['icon'],
                            text: petDetails[index]['text'],
                          );
                        } else {
                          return CardDetails(
                            title: '  Características',
                            icon: Icons.auto_awesome,
                            text: otherCaracteristics[index - petDetails.length],
                          );
                        }
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
                          constraints: BoxConstraints(minHeight: 0.0, maxHeight: 165),
                          child: Container(
                            width: double.infinity,
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          'Descrição',
                                          style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black54),
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
                Constantes.ADMIN_ID != widget.pet.ownerId
                    ? Column(
                        children: [
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
                                  constraints: BoxConstraints(minHeight: 0.0, maxHeight: 120),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Localização',
                                                style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.black54),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  MapsLauncher.launchCoordinates(
                                                    widget.pet.latitude,
                                                    widget.pet.longitude,
                                                    widget.pet.name,
                                                  );
                                                },
                                                child: Icon(Icons.launch, size: 16, color: Colors.blue),
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        FutureBuilder<Object>(
                                          future: OtherFunctions.getAddress(Location(widget.pet.latitude, widget.pet.longitude)),
                                          builder: (context, snapshot) {
                                            if (snapshot.data == null) {
                                              return Center(
                                                child: Column(
                                                  children: [
                                                    LoadingBumpingLine.circle(size: 15),
                                                    Text('Carregando endereço...'),
                                                  ],
                                                ),
                                              );
                                            }
                                            return Text(
                                              snapshot.data,
                                              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 8.0),
                            child: _ownerPetcontact(
                              user: widget.petOwner,
                              whatsappMessage: whatsappMessage,
                              emailMessage: emailMessage,
                              emailSubject: emailSubject,
                            ),
                          )
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: height / 12),
                        child: RatingUs(),
                      )
              ],
            ),
          ),
          Constantes.ADMIN_ID == widget.pet.ownerId
              ? Container()
              : !widget.isMine
                  ? Positioned(
                      bottom: 20.0,
                      left: widget.kind == 'DONATE' ? 20.0 : MediaQuery.of(context).size.width * 0.1,
                      child: Row(
                        children: [
                          Container(
                            width: wannaAdoptButton,
                            child: ButtonWide(
                                text: widget.kind == 'DONATE' ? 'QUERO ADOTAR' : 'VI ${widget.pet.sex == 'Macho' ? 'ELE' : 'ELA'} AQUI PERTO',
                                color: widget.kind == 'DONATE' ? Colors.red : Theme.of(context).primaryColor,
                                action: !isAuthenticated ? navigateToAuth : () => showInterestOrPassInfo(ownerDetails[0]['text'])),
                          ),
                        ],
                      ),
                    )
                  : Positioned(
                      bottom: 0.0,
                      child: ButtonWide(
                        isToExpand: true,
                        rounded: false,
                        action: () {},
                        text: widget.kind == 'DONATE' ? 'VOCÊ ESTÁ DOANDO' : 'VOCÊ ESTÁ PROCURANDO',
                      ),
                    ),
          StreamBuilder<Object>(
            stream: userProvider.isGeneratingSharedLink,
            builder: (context, snapshot) {
              return LoadDarkScreen(
                message: 'Gerando link compartilhável',
                show: snapshot.data ?? false,
              );
            },
          )
        ],
      ),
      floatingActionButton: (!widget.isMine && widget.kind == 'DONATE')
          ? Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
                bool isFavorite = favoritesProvider.getFavoritesPETSIDList.contains(widget.pet.id);
                return FloatingActionButton(
                  heroTag: 'favorite',
                  onPressed: !isAuthenticated
                      ? navigateToAuth
                      : () async {
                          final user = UserController();

                          await user.favorite(userProvider.userReference, widget.pet.petReference, !isFavorite);

                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text(isFavorite ? 'Removido dos favoritos' : 'Adicionado como favorito'),
                            ),
                          );

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

  void openFullScreenMode(List photos_list) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(
          images: photos_list,
        ),
      ),
    );
  }

  Widget showImages(List photos) {
    return Stack(
      children: [
        InkWell(
          onTap: () => openFullScreenMode(photos),
          child: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            child: PageView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: photos.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  photos.elementAt(index),
                  // fit: BoxFit.cover,
                  loadingBuilder: loadingImage,
                );
              },
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: InkWell(
            onTap: () => openFullScreenMode(photos),
            child: Column(
              children: [
                Icon(Icons.fullscreen, color: Colors.white, size: 40),
                Text(
                  'Abrir tela cheia',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: FittedBox(
                child: Container(
                  child: DotsIndicator(
                    controller: _pageController,
                    itemCount: photos.length,
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
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget loadingImage(BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
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

  Widget _ownerPetcontact({User user, String whatsappMessage, String emailSubject, String emailMessage}) {
    switch (user.betterContact) {
      case 0:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ButtonWide(
                action: () {
                  Launcher.openWhatsApp(number: user.phoneNumber, message: whatsappMessage);
                },
                color: Colors.green,
                icon: Tiutiu.whatsapp,
                isToExpand: false,
                text: 'WhatsApp',
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: ButtonWide(
                action: () {
                  Launcher.makePhoneCall(number: user.phoneNumber ?? user.landline);
                },
                color: Colors.orange,
                icon: Icons.phone,
                isToExpand: false,
                text: 'Ligar',
              ),
            ),
          ],
        );
        break;
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWide(
              action: () {
                Launcher.makePhoneCall(number: user.landline ?? user.phoneNumber);
              },
              color: Colors.orange,
              icon: Icons.phone,
              isToExpand: false,
              text: 'Ligar',
            ),
          ],
        );
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWide(
              action: () {
                Launcher.sendEmail(emailAddress: user.email, message: emailMessage, subject: emailSubject);
              },
              color: Colors.red,
              icon: Icons.mail,
              isToExpand: false,
              text: 'Enviar e-mail',
            ),
          ],
        );
    }
  }
}
