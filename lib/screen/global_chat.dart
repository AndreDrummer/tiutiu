import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/chat_provider.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/other_functions.dart';
import 'package:tiutiu/utils/routes.dart';

class GlobalChat extends StatefulWidget {
  @override
  _GlobalChatState createState() => _GlobalChatState();
}

class _GlobalChatState extends State<GlobalChat> {
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

  int orderByName(User a, User b) {
    List<int> aname = a.name.trim().codeUnits;
    List<int> bname = b.name.trim().codeUnits;

    if (a.name.isEmpty) {
      aname = 'z'.codeUnits;
    }
    if (b.name.isEmpty) {
      bname = 'z'.codeUnits;
    }

    int i = 0;
    while (i < bname.length) {
      if (bname[i] < aname[i]) {
        return 1;
      } else if (bname[i] == aname[i]) {
        i++;
        if (i >= aname.length) {
          return 1;
        }
      } else {
        return -1;
      }
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chatProvider.firestore.collection('Users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

                List<User> messagesList = snapshot.data.docs.map((e) => User.fromSnapshot(e)).toList();

                messagesList.sort(orderByName);

                if (messagesList.isEmpty) {
                  return EmptyListScreen(
                    text: 'Ninguém entrou para o chat ainda!',
                    icon: Icons.chat,
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            '${messagesList.length} ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black26,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              'usuário encontrados',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        key: UniqueKey(),
                        itemCount: messagesList.length,
                        itemBuilder: (ctx, index) {
                          return _ListTileMessage(
                            user: messagesList[index],
                          );
                        },
                      ),
                    ),
                  ],
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
    this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    String name = OtherFunctions.firstCharacterUpper(user.name);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.CHAT,
          arguments: {
            'chatTitle': OtherFunctions.firstCharacterUpper(user.name),
            'secondUserId': user.id,
            'receiverId': user.id,
            'receiverNotificationToken': user.notificationToken,
          },
        );
      },
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: () {
                OtherFunctions.navigateToAnnouncerDetail(context, user, showOnlyChat: true);
              },
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: FadeInImage(
                    placeholder: AssetImage('assets/profileEmpty.png'),
                    image: user.photoURL != null ? NetworkImage(user.photoURL) : AssetImage('assets/profileEmpty.jpg'),
                    fit: BoxFit.cover,
                    width: 1000,
                    height: 100,
                  ),
                ),
              ),
            ),
            title: Text(name.isEmpty ? 'Usuário sem nome' : name),
            subtitle: Text(
              'Usuário desde ${DateFormat('dd/MM/y HH:mm').format(DateTime.parse(user.createdAt)).split(' ').first}',
              style: TextStyle(fontSize: 10),
            ),
            trailing: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              width: 10,
              height: 10,
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
