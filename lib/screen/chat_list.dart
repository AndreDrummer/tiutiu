import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/backend/Model/messages_model.dart';
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
      appBar: AppBar(
        title: Text(
          'Mensagens',
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: Column(
        children: [
          adsProvider.getCanShowAds ? adsProvider.bannerAdMob(adId: adsProvider.bottomAdId) : Container(),
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
                    itemCount: messagesList.length,
                    itemBuilder: (ctx, index) {
                      return _ListTileMessage(
                        message: Messages.fromSnapshot(messagesList[index]),
                        messageId: messagesList[index].id,
                        myUserId: userProvider.uid,
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class _ListTileMessage extends StatelessWidget {
  _ListTileMessage({
    this.message,
    this.myUserId,
    this.messageId,
  });

  final Messages message;
  final String messageId;
  final String myUserId;

  @override
  Widget build(BuildContext context) {
    // Determina se o usuário logado é o primeiro usuário do chat.
    bool itsMe = myUserId == message.firstUserId;
    Timestamp stamp = message.lastMessageTime;
    DateTime date = stamp.toDate();

    String profilePic = itsMe ? message.secondUserImagePath : message.firstUserImagePath;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.CHAT,
          arguments: {
            'chatId': messageId,
            'chatTitle': itsMe ? message.secondUserName : message.firstUserName,
            'secondUserId': itsMe ? message.secondUserId : message.firstUserId,
            'receiverId': itsMe ? message.secondUserId : message.firstUserId,
            'receiverNotificationToken': itsMe ? message.secondReceiverNotificationToken : message.firstReceiverNotificationToken,
          },
        );
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
            title: Text(itsMe ? message.secondUserName : message.firstUserName),
            subtitle: Text(message.lastMessage),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
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
