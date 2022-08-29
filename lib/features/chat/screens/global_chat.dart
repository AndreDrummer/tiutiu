import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/chat/common/functions.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:tiutiu/utils/other_functions.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalChat extends StatefulWidget {
  @override
  _GlobalChatState createState() => _GlobalChatState();
}

class _GlobalChatState extends State<GlobalChat> {
  // AdsProvider adsProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // adsProvider = Provider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search(onChanged: chatController.textGlobalChatSearch, placeholder: 'Pesquisar uma pessoa'),
          Expanded(
            child: StreamBuilder(
              stream: chatController.globalChatList(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                List<TiutiuUser> messagesList = snapshot.data!.docs
                    .map((e) => TiutiuUser.fromSnapshot(e))
                    .toList();

                if (messagesList.isEmpty) {
                  return EmptyListScreen(
                    text: 'Ninguém entrou para o chat ainda!',
                    icon: Icons.chat,
                  );
                }

                return Builder(
                  builder: (context) {
                    if (chatController.textGlobalChatSearch.isNotEmpty) {
                      messagesList = CommonChatFunctions.searchUser(
                          messagesList, chatController.textGlobalChatSearch);
                      messagesList.sort(CommonChatFunctions.orderByName);
                    } else {
                      messagesList.sort(CommonChatFunctions.orderByName);
                    }

                    messagesList.removeWhere(
                      (element) =>
                          element.uid == tiutiuUserController.tiutiuUser.uid,
                    );

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
                                  'usuários encontrados',
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
                                myUser: tiutiuUserController.tiutiuUser,
                                user: messagesList[index],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ListTileMessage extends StatelessWidget {
  _ListTileMessage({
    required this.myUser,
    required this.user,
  });

  final TiutiuUser myUser;
  final TiutiuUser user;

  @override
  Widget build(BuildContext context) {
    String name = OtherFunctions.firstCharacterUpper(user.displayName!);
    return InkWell(
      onTap: () {
        CommonChatFunctions.openChat(
          context: context,
          firstUser: myUser,
          secondUser: user,
        );
      },
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: () {
                OtherFunctions.navigateToAnnouncerDetail(context, user,
                    showOnlyChat: true);
              },
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: FadeInImage(
                    placeholder: AssetImage('assets/profileEmpty.webp'),
                    image: AssetHandle(user.photoURL).build(),
                    fit: BoxFit.cover,
                    width: 1000,
                    height: 100,
                  ),
                ),
              ),
            ),
            title: Text(name.isEmpty ? 'Usuário sem nome' : name),
            subtitle: Text(
              'Usuário desde ${DateFormat('dd/MM/y HH:mm').format(DateTime.parse(user.createdAt!)).split(' ').first}',
              style: TextStyle(fontSize: 10),
            ),
            trailing: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
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
