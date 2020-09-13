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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [              
              Text('Tiu, tiu', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600))
            ],
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
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
