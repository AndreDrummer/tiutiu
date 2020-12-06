import 'package:flutter/material.dart';
import 'package:tiutiu/chat/screens/my_chats.dart';
import 'package:tiutiu/chat/screens/global_chat.dart';

class ChatTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CHAT',
                style: Theme.of(context).textTheme.headline1.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.search_outlined, color: Colors.white),
              // )
            ],
          ),
          bottom: TabBar(
            indicatorColor: Colors.purple,
            tabs: [
              Tab(icon: Icon(Icons.chat_bubble), text: 'MINHAS CONVERSAS'),
              Tab(icon: Icon(Icons.chat_sharp), text: 'TIU, TIU CHAT'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyChats(),
            GlobalChat(),
          ],
        ),
      ),
    );
  }
}
