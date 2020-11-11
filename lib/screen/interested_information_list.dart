import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/Widgets/interested_info_card.dart';
import 'package:tiutiu/Widgets/interested_list_tile.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/backend/Model/interested_model.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/providers/user_infos_interests.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/announcer_datails.dart';
import 'package:tiutiu/utils/routes.dart';

class InterestedList extends StatefulWidget {
  InterestedList({
    this.pet,
    this.kind,
  });

  final Pet pet;
  final String kind;

  @override
  _InterestedListState createState() => _InterestedListState();
}

class _InterestedListState extends State<InterestedList> {
  UserInfoOrAdoptInterestsProvider userInfoOrAdoptInterestsProvider;
  UserProvider userProvider;
  UserController userController = UserController();
  bool isSinalizing = false;

  void changeIsSinalizingStatus(bool value) {
    setState(() {
      isSinalizing = value;
    });
  }

  Future<void> donatePetToSomeone({
    DocumentReference interestedReference,
    DocumentReference ownerReference,
    String interestedNotificationToken,
    String ownerNotificationToken,
    String interestedName,
    String interestedID,
    int userPosition,
    Pet pet,
  }) async {
    await userController
        .donatePetToSomeone(
      pet: pet,
      interestedID: interestedID,
      interestedName: interestedName,
      ownerReference: ownerReference,
      interestedReference: interestedReference,
      userPosition: userPosition,
      ownerNotificationToken: ownerNotificationToken,
      interestedNotificationToken: interestedNotificationToken,
    )
        .then(
      (_) {
        _showDialogCard(
          title: 'Sucesso',
          message: '$interestedName será notificado sobre a adoção!',
          confirmAction: () {
            userInfoOrAdoptInterestsProvider
                .loadInterested(widget.pet.petReference);
            Navigator.pop(context);
          },
          confirmText: 'OK',
        );
      },
    );
  }

  void _showDialogCard({
    Function confirmAction,
    String confirmText,
    String message,
    String title,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopUpMessage(
        confirmAction: () => confirmAction(),
        confirmText: confirmText,
        message: message,
        title: title,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    userInfoOrAdoptInterestsProvider =
        Provider.of<UserInfoOrAdoptInterestsProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    if (widget.kind == 'Donate') {
      userInfoOrAdoptInterestsProvider.loadInterested(widget.pet.petReference);
    } else {
      userInfoOrAdoptInterestsProvider.loadInfo(widget.pet.petReference);
    }

    super.didChangeDependencies();
  }

  void doar(User interestedUser, InterestedModel interestedModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopUpMessage(
        confirmAction: () async {
          Navigator.pop(context);
          changeIsSinalizingStatus(true);
          await donatePetToSomeone(
            interestedName: interestedUser.name,
            ownerReference: userProvider.userReference,
            pet: widget.pet,
            interestedID: interestedUser.id,
            interestedNotificationToken: interestedUser.notificationToken,
            ownerNotificationToken: userProvider.notificationToken,
            interestedReference:
                await userController.getReferenceById(interestedUser.id),
            userPosition: interestedModel.position,
          );
          changeIsSinalizingStatus(false);
        },
        confirmText: 'Confirmo',
        denyAction: () => Navigator.pop(context),
        denyText: 'Não, escolher outro',
        message: 'Deseja doar ${widget.pet.name} para ${interestedUser.name} ?',
        title: 'Confirme doação do PET',
        warning: true,
      ),
    );
  }

  void seeInfo(InterestedModel interestedModel) {
    Navigator.pushNamed(context, Routes.INFO, arguments: {
      'petName': widget.pet.name,
      'informanteInfo': interestedModel
    });
  }

  void navigateToInterestedDetail(User interestedUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncerDetails(interestedUser),
      ),
    );
  }

  Widget badge(InterestedModel interestedModel) {
    if (widget.kind == 'Donate' && !interestedModel.sinalized) {
      return _bagde('Doar');
    } else if (widget.kind == 'Donate' && interestedModel.gaveup) {
      return _bagde('Desistiu', color: Colors.red);
    } else if (interestedModel.donated) {
      return _bagde('Adotado', color: Colors.green);
    } else if (widget.kind == 'Donate' && interestedModel.sinalized) {
      return _bagde('Aguardando confirmação', color: Colors.amber);
    } else {
      return _bagde('Ver info', color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kind == 'Donate'
            ? 'Interessados em ${widget.pet.name}'.toUpperCase()
            : 'Quem informou sobre ${widget.pet.name}'.toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: StreamBuilder<List<InterestedModel>>(
          stream: widget.kind == 'Donate'
              ? userInfoOrAdoptInterestsProvider.interested
              : userInfoOrAdoptInterestsProvider.info,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage(
                messageLoading: 'Carregando lista de interessados',
                circle: true,
              );
            }

            // if (!snapshot.hasData || snapshot.data.isEmpty) {
            //   return EmptyListScreen(
            //     text: widget.kind == 'Donate'
            //         ? 'Ninguém ainda está interessado'
            //         : 'Ninguém ainda passou informações',
            //   );
            // }
            return Stack(
              children: [
                ListView.builder(
                  itemCount: 3,//snapshot.data.length,
                  itemBuilder: (_, index) {                    
                    return InterestedInfoCard();
                    return FutureBuilder<Object>(
                      future: snapshot.data[index]?.userReference?.get(),
                      builder: (context, interestedReferenceSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (!interestedReferenceSnapshot.hasData) {
                          return Container();
                        }
                        User interestedUser = User.fromSnapshot(interestedReferenceSnapshot.data);
                        String subtitle = '${widget.kind == 'Donate' ? 'Interessou dia' : 'Informou dia'} ${DateFormat('dd/MM/y HH:mm').format(DateTime.parse(snapshot.data[index].interestedAt))}';
                        return InterestedListTile(
                          subtitle: subtitle,
                          interestedUser: interestedUser,
                          navigateToInterestedDetail: interestedUser.photoURL ==
                                  null
                              ? null
                              : () =>
                                  navigateToInterestedDetail(interestedUser),
                          trailingFunction: () {
                            if (widget.kind == 'Donate' && !snapshot.data[index].sinalized) {
                              doar(interestedUser, snapshot.data[index]);
                            } else {
                              seeInfo(snapshot.data[index]);
                            }
                          },
                          trailingChild: badge(snapshot.data[index]),
                        );
                      },
                    );
                  },
                ),
                LoadDarkScreen(
                    show: isSinalizing, message: 'Sinalizando adoção..'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _bagde(String text, {Color color = Colors.purple}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
