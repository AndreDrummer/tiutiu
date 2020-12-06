import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/backend/Model/chat_model.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/chat/common/functions.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/chat_provider.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/other_functions.dart';
import 'package:tiutiu/utils/routes.dart';

class MyChats extends StatefulWidget {
  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  AdsProvider adsProvider;
  ChatProvider chatProvider;
  UserProvider userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adsProvider = Provider.of(context);
    chatProvider = Provider.of(context);
    userProvider = Provider.of(context);
  }

  bool existsNewMessage(Chat chat) {
    return chat.open != null && !chat.open && chat.lastSender != null && chat.lastSender != userProvider.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search(onChanged: chatProvider.changeTextChatSearch, placeholder: 'Pesquisar uma conversa'),
          Expanded(
            child: StreamBuilder(
              stream: chatProvider.firestore.collection('Chats').orderBy('lastMessageTime', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                List<QueryDocumentSnapshot> messagesList = [];

                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

                snapshot.data.docs.forEach((element) {
                  if (User.fromMap(element.get('firstUser')).id == userProvider.uid || User.fromMap(element.get('secondUser')).id == userProvider.uid) messagesList.add(element);
                });

                List<Chat> chatList = messagesList.map((e) => Chat.fromSnapshot(e)).toList();

                if (chatList.isEmpty) {
                  return EmptyListScreen(
                    text: 'Nenhuma conversa encontrada!',
                    icon: Icons.chat,
                  );
                }

                return StreamBuilder(
                    stream: chatProvider.textChatSearch,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.data != null && snapshot.data.isNotEmpty) {
                        chatList = CommonChatFunctions.searchChat(chatList, snapshot.data, userProvider.uid);
                      }

                      return ListView.builder(
                        key: UniqueKey(),
                        itemCount: chatList.length,
                        itemBuilder: (ctx, index) {
                          return _ListTileMessage(
                            chat: chatList[index],
                            messageId: chatList[index].id,
                            myUserId: userProvider.uid,
                            chatProvider: chatProvider,
                            newMessage: existsNewMessage(chatList[index]),
                          );
                        },
                      );
                    });
              },
            ),
          ),
          // adsProvider.getCanShowAds ? adsProvider.bannerAdMob(adId: adsProvider.bottomAdId) : Container(),
        ],
      ),
    );
  }
}

class _ListTileMessage extends StatelessWidget {
  _ListTileMessage({
    this.chat,
    this.myUserId,
    this.messageId,
    this.newMessage,
    this.chatProvider,
  });

  final Chat chat;
  final String messageId;
  final bool newMessage;
  final String myUserId;
  final ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    // Determina se o usuário logado é o primeiro usuário do chat.
    bool itsMe = myUserId == chat.firstUser.id;
    Timestamp stamp = chat.lastMessageTime;
    DateTime date = stamp.toDate();

    String profilePic = itsMe ? chat.secondUser.photoURL : chat.firstUser.photoURL;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.CHAT,
          arguments: {
            'chatId': messageId,
            'chatTitle': itsMe ? chat.secondUser.name : chat.firstUser.name,
            'secondUserId': itsMe ? chat.secondUser.id : chat.firstUser.id,
            'receiverId': itsMe ? chat.secondUser.id : chat.firstUser.id,
            'receiverNotificationToken': itsMe ? chat.secondUser.notificationToken : chat.firstUser.notificationToken,
          },
        );
        chatProvider.markMessageAsRead(messageId);
      },
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: () => OtherFunctions.navigateToAnnouncerDetail(context, itsMe ? chat.secondUser : chat.firstUser, showOnlyChat: true),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: FadeInImage(
                    placeholder: AssetImage('assets/profileEmpty.png'),
                    image: profilePic != null ? NetworkImage(profilePic) : AssetImage('assets/profileEmpty.jpg'),
                    fit: BoxFit.cover,
                    width: 1000,
                    height: 100,
                  ),
                ),
              ),
            ),
            title: Text(itsMe ? chat.secondUser.name : chat.firstUser.name),
            subtitle: Text(chat.lastMessage),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    newMessage
                        ? Badge(
                            color: Colors.green,
                            text: 'Nova',
                          )
                        : Text(''),
                    Text('${DateFormat('dd/MM/y HH:mm').format(DateTime.parse(date.toIso8601String())).split(' ').last}'),
                    SizedBox(height: 2),
                    Text('${DateFormat('dd/MM/y HH:mm').format(DateTime.parse(date.toIso8601String())).split(' ').first}'),
                  ],
                )
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
