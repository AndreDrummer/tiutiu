import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiutiu/Widgets/interested_info_card.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/models/interested_model.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/chat/common/functions.dart';
import 'package:tiutiu/providers/user_infos_interests.dart';
import 'package:tiutiu/screen/announcer_datails.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';

class InterestedList extends StatefulWidget {
  InterestedList({
    this.pet,
    this.kind,
  });

  final String? kind;
  final Pet? pet;

  @override
  _InterestedListState createState() => _InterestedListState();
}

class _InterestedListState extends State<InterestedList> {
  UserInfoOrAdoptInterestsProvider? userInfoOrAdoptInterestsProvider;

  int timeToSendNotificationAgain = 120;

  bool isOpeningChat = false;
  bool isSinalizing = false;

  void changeIsSinalizingStatus(bool value) {
    setState(() {
      isSinalizing = value;
    });
  }

  void changeIsOpenningChatStatus(bool value) {
    setState(() {
      isOpeningChat = value;
    });
  }

  Future<void> donatePetToSomeone({
    DocumentReference? interestedReference,
    DocumentReference? ownerReference,
    String? interestedNotificationToken,
    String? ownerNotificationToken,
    String? interestedName,
    String? interestedID,
    int? userPosition,
    Pet? pet,
  }) async {}

  void doar(TiutiuUser interestedUser, InterestedModel interestedModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopUpMessage(
        confirmAction: () async {},
        confirmText: 'Confirmo',
        denyAction: () => Navigator.pop(context),
        denyText: 'Não, escolher outro',
        message:
            'Deseja doar ${widget.pet!.name} para ${interestedUser.displayName} ?',
        title: 'Confirme doação do PET',
        warning: true,
      ),
    );
  }

  void seeInfo(InterestedModel interestedModel) {
    Navigator.pushNamed(context, Routes.info, arguments: {
      'petName': widget.pet!.name,
      'informanteInfo': interestedModel
    });
  }

  void navigateToInterestedDetail(TiutiuUser interestedUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncerDetails(interestedUser),
      ),
    );
  }

  Color color(InterestedModel interestedModel) {
    int hoursSinceLastNotification = DateTime.now()
        .difference(DateTime.parse(interestedModel.lastNotificationSend))
        .inMinutes;
    switch (widget.kind) {
      case FirebaseEnvPath.donate:
        if (interestedModel.donated) return Colors.green;
        if (interestedModel.gaveup) return Colors.red;
        if (hoursSinceLastNotification >= timeToSendNotificationAgain)
          return Colors.purple;
        if (hoursSinceLastNotification < timeToSendNotificationAgain)
          return Colors.amber;
        break;
    }
    return Colors.blue;
  }

  String text(InterestedModel interestedModel) {
    int hoursSinceLastNotification = DateTime.now()
        .difference(DateTime.parse(interestedModel.lastNotificationSend))
        .inMinutes;

    switch (widget.kind) {
      case FirebaseEnvPath.donate:
        if (interestedModel.donated) return 'Adotado';
        if (interestedModel.gaveup) return 'Desistiu';
        if (hoursSinceLastNotification >= timeToSendNotificationAgain &&
            interestedModel.sinalized) return 'REENVIAR DOAÇÃO';
        if (hoursSinceLastNotification >= timeToSendNotificationAgain)
          return 'Doar';
        if (hoursSinceLastNotification < timeToSendNotificationAgain)
          return 'Aguardando confirmação';
        break;
    }
    return 'Ver info';
  }

  Widget badge(InterestedModel interestedModel) {
    int hoursSinceLastNotification = DateTime.now()
        .difference(DateTime.parse(interestedModel.lastNotificationSend))
        .inMinutes;
    switch (widget.kind) {
      case FirebaseEnvPath.donate:
        if (interestedModel.donated)
          return _bagde('Adotado', color: Colors.green);
        if (interestedModel.gaveup)
          return _bagde('Desistiu', color: Colors.red);
        if (hoursSinceLastNotification >= timeToSendNotificationAgain)
          return _bagde('Doar');
        if (hoursSinceLastNotification < timeToSendNotificationAgain)
          return _bagde('Aguardando confirmação', color: Colors.amber);
        break;
    }
    return _bagde('Ver info', color: Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(widget.kind == FirebaseEnvPath.donate
            ? 'Interessados em ${widget.pet!.name}'.toUpperCase()
            : 'Quem informou sobre ${widget.pet!.name}'.toUpperCase()),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: StreamBuilder<List<InterestedModel>>(
              stream: widget.kind == FirebaseEnvPath.donate
                  ? userInfoOrAdoptInterestsProvider!.interested
                  : userInfoOrAdoptInterestsProvider!.info,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingPage(
                    messageLoading: 'Carregando lista de interessados',
                    circle: true,
                  );
                }

                List<InterestedModel> interesteds = snapshot.data!;
                interesteds.sort((a, b) {
                  return DateTime.parse(b.interestedAt).millisecondsSinceEpoch -
                      DateTime.parse(a.interestedAt).millisecondsSinceEpoch;
                });

                return Stack(
                  children: [
                    ListView.builder(
                      key: UniqueKey(),
                      itemCount: interesteds.length,
                      itemBuilder: (_, index) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: interesteds[index].userReference.get(),
                          builder: (context, interestedReferenceSnapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            if (!interestedReferenceSnapshot.hasData ||
                                interestedReferenceSnapshot.data!.data() ==
                                    null) {
                              return Container();
                            }

                            TiutiuUser interestedUser = TiutiuUser.fromSnapshot(
                              interestedReferenceSnapshot.data!,
                            );
                            String subtitle =
                                '${widget.kind == FirebaseEnvPath.donate ? 'Interessou dia' : 'Informou dia'} ${DateFormat('dd/MM/y HH:mm').format(DateTime.parse(interesteds[index].interestedAt))}';

                            return InterestedInfoCard(
                              subtitle: subtitle,
                              interestedUser: interestedUser,
                              navigateToInterestedDetail:
                                  interestedUser.avatar == null
                                      ? null
                                      : () => navigateToInterestedDetail(
                                            interestedUser,
                                          ),
                              infoOrDonateFunction: () {
                                int hoursSinceLastNotification = DateTime.now()
                                    .difference(DateTime.parse(
                                        interesteds[index]
                                            .lastNotificationSend))
                                    .inMinutes;
                                bool canSendNewNotification =
                                    widget.kind == FirebaseEnvPath.donate &&
                                        hoursSinceLastNotification >=
                                            timeToSendNotificationAgain &&
                                        (!interesteds[index].donated &&
                                            !interesteds[index].gaveup);

                                if (canSendNewNotification) {
                                  doar(interestedUser, interesteds[index]);
                                } else if (widget.kind ==
                                    FirebaseEnvPath.disappeared) {
                                  seeInfo(interesteds[index]);
                                }
                              },
                              openChat: () => CommonChatFunctions.openChat(
                                context: context,
                                firstUser: tiutiuUserController.tiutiuUser,
                                secondUser: interestedUser,
                              ),
                              infoOrDonteText: text(interesteds[index]),
                              color: color(
                                interesteds[index],
                              ),
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
          LoadDarkScreen(
            message: 'Abrindo chat...',
            show: isOpeningChat,
          )
        ],
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
        child: AutoSizeText(
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
