import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/backend/Model/interested_model.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/providers/user_infos_interests.dart';
import 'package:tiutiu/providers/user_provider.dart';
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
  User user;
  UserController userController = UserController();
  bool isSinalizing = false;

  void changeIsSinalizingStatus(bool value) {
    setState(() {
      isSinalizing = value;
    });
  }

  Future<void> donatePetToSomeone({
    String userDonateId,
    String userAdoptId,
    String userName,
    DocumentReference petReference,
    DocumentReference userThatDonate,
    int userPosition,
  }) async {
    await userController
        .donatePetToSomeone(
      petReference: widget.pet.petReference,
      userAdoptId: user.id,
      userDonateId: userProvider.uid,
      userPosition: userPosition,
    )
        .then(
      (_) {
        _showDialogCard(
          title: 'Sucesso',
          message: '$userName será notificado sobre a adoção!',
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
    userController.getUserByReference(widget.pet.ownerReference).then((value) {
      user = value;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pessoas interessadas em ${widget.pet.name}'),
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

            if (!snapshot.hasData || snapshot.data.isEmpty) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.kind == 'Donate'
                          ? 'Ninguém ainda está interessado'
                          : 'Ninguém ainda passou informações',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                          ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.sentiment_dissatisfied)
                  ],
                ),
              );
            }
            return Stack(
              children: [
                ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    return FutureBuilder<Object>(
                      future: snapshot.data[index].userReference.get(),
                      builder: (context, userReferenceSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (!userReferenceSnapshot.hasData) {
                          return LoadingBumpingLine.circle(size: 30);
                        }
                        User user =
                            User.fromSnapshot(userReferenceSnapshot.data);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: FadeInImage(
                                placeholder: AssetImage('assets/fundo.jpg'),
                                image: user.photoURL != null
                                    ? NetworkImage(user.photoURL)
                                    : AssetImage(
                                        'assets/fundo.jpg',
                                      ),
                                fit: BoxFit.fill,
                                width: 1000,
                                height: 1000,
                              ),
                            ),
                          ),
                          title: Text(user.name),
                          subtitle: Text(
                              '${widget.kind == 'Donate' ? 'Se interessou dia' : 'Informou dia'} ${DateFormat('dd/MM/y hh:mm').format(DateTime.parse(snapshot.data[index].interestedAt))}'),
                          trailing: InkWell(
                            onTap: widget.kind == 'Donate'
                                ? snapshot.data[index].sinalized
                                    ? () {}
                                    : () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => PopUpMessage(
                                            confirmAction: () async {
                                              Navigator.pop(context);
                                              changeIsSinalizingStatus(true);
                                              await donatePetToSomeone(
                                                userName: user.name,
                                                petReference:
                                                    widget.pet.petReference,
                                                userAdoptId: user.id,
                                                userDonateId: userProvider.uid,
                                                userPosition: snapshot
                                                    .data[index].position,
                                              );
                                              changeIsSinalizingStatus(false);
                                            },
                                            confirmText: 'Confirmo',
                                            denyAction: () =>
                                                Navigator.pop(context),
                                            denyText: 'Não, escolher outro',
                                            message:
                                                'Deseja doar ${widget.pet.name} para ${user.name} ?',
                                            title: 'Confirme doação do PET',
                                            warning: true,
                                          ),
                                        );
                                      }
                                : () {
                                    Navigator.pushNamed(context, Routes.INFO,
                                        arguments: {'petName': widget.pet.name, 'informanteInfo': snapshot.data[index]});
                                  },
                            child: widget.kind == 'Donate'
                                ? !snapshot.data[index].sinalized
                                    ? _bagde('Doar')
                                    : snapshot.data[index].gaveup
                                        ? _bagde('Desistiu', color: Colors.red)
                                        : _bagde('Aguardando confirmação',
                                            color: Colors.green)
                                : _bagde('Ver info', color: Colors.blue),
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
