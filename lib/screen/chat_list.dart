import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/backend/Model/chat_model.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/chat_provider.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/routes.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chatProvider.firestore.collection('Chats').orderBy('lastMessageTime', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                List<QueryDocumentSnapshot> messagesList = [];

                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

                snapshot.data.docs.forEach((element) {
                  if (element.get('firstUserId') == userProvider.uid || element.get('secondUserId') == userProvider.uid) messagesList.add(element);
                });

                if (messagesList.isEmpty) {
                  return EmptyListScreen(
                    text: 'Nenhuma conversa encontrada!',
                    icon: Icons.chat,
                  );
                }

                return ListView.builder(
                  key: UniqueKey(),
                  itemCount: messagesList.length,
                  itemBuilder: (ctx, index) {
                    return _ListTileMessage(
                      chat: Chat.fromSnapshot(messagesList[index]),
                      messageId: messagesList[index].id,
                      myUserId: userProvider.uid,
                      chatProvider: chatProvider,
                      newMessage: !Chat.fromSnapshot(messagesList[index]).open && Chat.fromSnapshot(messagesList[index]).lastSender != userProvider.uid,
                    );
                  },
                );
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
    bool itsMe = myUserId == chat.firstUserId;
    Timestamp stamp = chat.lastMessageTime;
    DateTime date = stamp.toDate();

    String profilePic = itsMe ? chat.secondUserImagePath : chat.firstUserImagePath;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.CHAT,
          arguments: {
            'chatId': messageId,
            'chatTitle': itsMe ? chat.secondUserName : chat.firstUserName,
            'secondUserId': itsMe ? chat.secondUserId : chat.firstUserId,
            'receiverId': itsMe ? chat.secondUserId : chat.firstUserId,
            'receiverNotificationToken': itsMe ? chat.secondReceiverNotificationToken : chat.firstReceiverNotificationToken,
          },
        );
        chatProvider.markMessageAsRead(messageId);
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
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
            title: Text(itsMe ? chat.secondUserName : chat.firstUserName),
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
