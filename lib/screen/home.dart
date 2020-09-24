import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/favorites_provider.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/favorites.dart';
import 'package:tiutiu/screen/my_account.dart';
import 'package:tiutiu/screen/pets_list.dart';
import '../Widgets/floating_button_option.dart';
import '../utils/routes.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final ACTIVED_COLOR = Color(0XFF32CD32);
  final DESACTIVED_COLOR = Color(0XFF808080);

  UserProvider userProvider;
  FavoritesProvider favoritesProvider;
  Authentication auth;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    auth = Provider.of<Authentication>(context, listen: false);
    favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    setUserMetaData();
    super.didChangeDependencies();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> leaveApplication() async {
    var answer = false;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Consumer<Authentication>(
        builder: (context, auth, child) {
          return PopUpMessage(
            title: 'Logout',
            message: 'Deseja realmente sair?',
            confirmAction: () {
              setState(() {
                answer = true;
              });
              Navigator.pop(context);
              auth.signOut();
            },
            confirmText: 'Sim',
            denyAction: () {
              Navigator.pop(context);
            },
            denyText: 'Não',
          );
        },
      ),
    ).then((value) {
      print('Answer: $answer');
      return answer;
    });
  }

  void setUserMetaData() async {
    final CollectionReference usersEntrepreneur =
        FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot doc =
        await usersEntrepreneur.doc(auth.firebaseUser.uid).get();

    userProvider.changeUserReference(doc.reference);
    userProvider.changeUid(auth.firebaseUser.uid);
    userProvider.changePhotoUrl(doc.data()['photoURL']);
    userProvider.changePhotoBack(doc.data()['photoBACK']);
    userProvider.changeWhatsapp(doc.data()['phoneNumber']);
    userProvider.changeDisplayName(doc.data()['displayName']);
    userProvider.changeTelefone(doc.data()['landline']);
    userProvider.changeBetterContact(doc.data()['betterContact']);
    userProvider.calculateTotals();

    favoritesProvider.loadFavoritesReference();
  }

  @override
  Widget build(BuildContext context) {
    var _screens = <Widget>[PetsList(), Favorites(), MyAccount()];

    return WillPopScope(
      onWillPop: leaveApplication,
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            _screens.elementAt(_selectedIndex),
           _selectedIndex == 0 ? Positioned(
              bottom: 0.0,
              child: ButtonWide(
                action: (){
                  Navigator.pushNamed(context, Routes.SEARCH_REFINE);
                },
                icon: Tiutiu.params,
                rounded: false,
                isToExpand: true,
                text: 'REFINAR BUSCA',
              ),
            ) : SizedBox()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          backgroundColor: Colors.black,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Tiutiu.pets),
              title: Text('PETS'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              title: Text('Favoritos'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Tiutiu.user, size: 18),
              title: Text('Eu'),
            )
          ],
        ),
        floatingActionButton: _selectedIndex != 0
            ? null
            : SpeedDial(
                marginRight: 18,
                marginBottom: 20,
                animatedIcon: AnimatedIcons.add_event,
                animatedIconTheme: IconThemeData(size: 22.0),
                visible:
                    MediaQuery.of(context).orientation == Orientation.portrait,
                closeManually: false,
                curve: Curves.bounceIn,
                overlayOpacity: 0.5,
                onOpen: () {
                  print('OPENING DIAL');
                },
                onClose: () {
                  print('DIAL CLOSED');
                },
                tooltip: 'Adicionar PET',
                heroTag: 'speed-dial-hero-tag',
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                    child: FloatingButtonOption(image: 'assets/dogCat2.png'),
                    label: 'Adicionar Desaparecido',
                    backgroundColor: Theme.of(context).accentColor,
                    labelStyle: TextStyle(fontSize: 14.0),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.CHOOSE_LOCATION,
                          arguments: {'kind': 'Disappeared'});
                    },
                  ),
                  SpeedDialChild(
                    child: FloatingButtonOption(image: 'assets/pata2.jpg'),
                    label: 'Doar PET',
                    backgroundColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(fontSize: 14.0),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.CHOOSE_LOCATION,
                          arguments: {'kind': 'Donate'});
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
