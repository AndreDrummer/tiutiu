import 'package:flutter/material.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/screen/donate_disappeared_list.dart';

class PetsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final indexTab = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
      length: 2,
      initialIndex: indexTab ?? 0,
      child: Scaffold(        
        appBar: AppBar(          
          leading: null,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [              
              Text('Tiu, tiu', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600))
            ],
          ),
          bottom: TabBar(            
            indicatorColor: Colors.white,            
            labelColor: Colors.white,
            
            tabs: [              
              Tab(icon: Icon(Tiutiu.dog), text: 'ADOTAR'),
              Tab(icon: Icon(Tiutiu.exclamation), text: 'DESAPARECIDOS'),
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
