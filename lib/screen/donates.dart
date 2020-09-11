import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/card_list.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/my_pets_provider.dart';

class Donate extends StatefulWidget {
  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  MyPetsProvider myPetsProvider;
  Authentication auth;

  @override
  void didChangeDependencies() {
    myPetsProvider = Provider.of<MyPetsProvider>(context);
    auth = Provider.of<Authentication>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Meus PETS',
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => myPetsProvider.loadMyPets(auth.firebaseUser.uid),      
        child: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (_, index) {
                return CardList();
              },
            );
          }
        ),
      ),
    );
  }
}
