import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/user_provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  UserProvider userProvider;
  UserController userController = UserController();
  bool confirmingAdoption = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void changeConfirmingAdoptionStatus(bool value) {
    setState(() {
      confirmingAdoption = value;
    });
  }

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context);
    userProvider.loadNotifications();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Notificações sobre adoção')),
      body: StreamBuilder<List<Pet>>(
        stream: userProvider.notificationsAboutAdoptions,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          print(snapshot.data[0].name);
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: FadeInImage(
                      placeholder: AssetImage('assets/fundo.jpg'),
                      image: snapshot.data[index].avatar != null
                          ? NetworkImage(
                              snapshot.data[index].avatar,
                            )
                          : AssetImage('assets/fundo.jpg'),
                      fit: BoxFit.cover,
                      width: 1000,
                      height: 100,
                    ),
                  ),
                ),
                title: Text(snapshot.data[index].name),
                subtitle: Text(snapshot.data[index].breed),
                trailing: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => PopUpMessage(
                        title: 'Confirmar adoção',
                        message:
                            'Tem certeza que adotou ${snapshot.data[index].name} ?',
                        denyAction: () => Navigator.pop(context),
                        denyText: 'Não',
                        confirmText: 'Sim',
                        confirmAction: () async {
                          Navigator.pop(context);
                          changeConfirmingAdoptionStatus(true);
                          await userController.confirmDonate(
                            snapshot.data[index].petReference,
                            userProvider.uid,
                          );
                          changeConfirmingAdoptionStatus(false);
                        },
                      ),
                    ).then(
                      (value) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Confirmação realizada com sucesso!'),
                          ),
                        );
                      },
                    );
                  },
                  child: _bagde('Confirmar adoção', color: Colors.green),
                ),
              );
            },
          );
        },
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
