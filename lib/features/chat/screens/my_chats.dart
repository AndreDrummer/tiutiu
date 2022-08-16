import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/core/models/chat_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/chat/common/functions.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:tiutiu/providers/chat_provider.dart';
import 'package:tiutiu/utils/other_functions.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';

class MyChats extends StatefulWidget {
  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  // AdsProvider adsProvider;
  late ChatProvider chatProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // adsProvider = Provider.of(context);
    chatProvider = Provider.of(context);
  }

  bool existsNewMessage(Chat chat) {
    return chat.open != null &&
        !chat.open! &&
        chat.lastSender != null &&
        chat.lastSender != tiutiuUserController.tiutiuUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search(onChanged: chatProvider.changeTextChatSearch, placeholder: 'Pesquisar uma conversa'),
          Expanded(
            child: StreamBuilder(
              stream: chatProvider.firestore
                  .collection('Chats')
                  .orderBy('lastMessageTime', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                List<QueryDocumentSnapshot> messagesList = [];

                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                snapshot.data!.docs.forEach((element) {
                  if (TiutiuUser.fromMap(element.get('firstUser')).uid ==
                          tiutiuUserController.tiutiuUser.uid ||
                      TiutiuUser.fromMap(element.get('secondUser')).uid ==
                          tiutiuUserController.tiutiuUser.uid)
                    messagesList.add(element);
                });

                List<Chat> chatList =
                    messagesList.map((e) => Chat.fromSnapshot(e)).toList();

                if (chatList.isEmpty) {
                  return EmptyListScreen(
                    text: 'Nenhuma conversa encontrada!',
                    icon: Icons.chat,
                  );
                }

                return StreamBuilder(
                    stream: chatProvider.textChatSearch,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                        chatList = CommonChatFunctions.searchChat(
                            chatList,
                            snapshot.data!,
                            tiutiuUserController.tiutiuUser.uid!);
                      }

                      return ListView.builder(
                        key: UniqueKey(),
                        itemCount: chatList.length,
                        itemBuilder: (ctx, index) {
                          return _ListTileMessage(
                            chat: chatList[index],
                            messageId: chatList[index].id!,
                            myUserId: tiutiuUserController.tiutiuUser.uid!,
                            chatProvider: chatProvider,
                            newMessage: existsNewMessage(chatList[index]),
                          );
                        },
                      );
                    });
              },
            ),
          ),
          // TODO: Tinha um anuncio aqui
          // adsProvider.getCanShowAds
          //     ? adsProvider.bannerAdMob(adId: adsProvider.bottomAdId)
          //     : Container(),
        ],
      ),
    );
  }
}

class _ListTileMessage extends StatelessWidget {
  _ListTileMessage({
    required this.chatProvider,
    required this.newMessage,
    required this.messageId,
    required this.myUserId,
    required this.chat,
  });

  final ChatProvider chatProvider;
  final String messageId;
  final String myUserId;
  final bool newMessage;
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    // Determina se o usuário logado é o primeiro usuário do chat.
    bool itsMe = myUserId == chat.firstUser.uid;
    Timestamp stamp = chat.lastMessageTime!;
    DateTime date = stamp.toDate();

    String profilePic =
        itsMe ? chat.secondUser.photoURL! : chat.firstUser.photoURL!;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.chat,
          arguments: {
            'chatId': messageId,
            'chatTitle': itsMe
                ? OtherFunctions.firstCharacterUpper(
                    chat.secondUser.displayName!)
                : OtherFunctions.firstCharacterUpper(
                    chat.firstUser.displayName!),
            'secondUserId': itsMe ? chat.secondUser.uid : chat.firstUser.uid,
            'receiverId': itsMe ? chat.secondUser.uid : chat.firstUser.uid,
            'receiverNotificationToken': itsMe
                ? chat.secondUser.notificationToken
                : chat.firstUser.notificationToken,
          },
        );
        chatProvider.markMessageAsRead(messageId);
      },
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: () => OtherFunctions.navigateToAnnouncerDetail(
                  context, itsMe ? chat.secondUser : chat.firstUser,
                  showOnlyChat: true),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: FadeInImage(
                    placeholder: AssetImage('assets/profileEmpty.png'),
                    image: AssetHandle(profilePic).build(),
                    fit: BoxFit.cover,
                    width: 1000,
                    height: 100,
                  ),
                ),
              ),
            ),
            title: Text(itsMe
                ? OtherFunctions.firstCharacterUpper(
                    chat.secondUser.displayName!)
                : OtherFunctions.firstCharacterUpper(
                    chat.firstUser.displayName!)),
            subtitle: Text(chat.lastMessage!),
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
                    Text(
                        '${DateFormat('dd/MM/y HH:mm').format(DateTime.parse(date.toIso8601String())).split(' ').last}'),
                    SizedBox(height: 2),
                    Text(
                        '${DateFormat('dd/MM/y HH:mm').format(DateTime.parse(date.toIso8601String())).split(' ').first}'),
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
