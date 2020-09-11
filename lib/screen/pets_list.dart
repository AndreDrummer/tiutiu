import 'package:flutter/material.dart';
import 'package:tiutiu/Custom/pet_detail_icons_icons.dart';
import 'package:tiutiu/screen/donate_disappeared_list.dart';

class PetsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(        
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/pata.jpg', width: 30, height: 30, color: Colors.white),
              SizedBox(width: 10),
              Text('Tiu, tiu', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600))
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(PetDetailIcons.dog), text: 'ADOTAR'),
              Tab(icon: Icon(PetDetailIcons.guidedog), text: 'DESAPARECIDOS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DonateDisappearedList(kind: 'Donate'),
            DonateDisappearedList(kind: 'Disappeared'),
          ],
        )
      ),
    );
  }
}
