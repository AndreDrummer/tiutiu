import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/chat/screens/my_chats.dart';
import 'package:tiutiu/chat/screens/global_chat.dart';
import 'package:tiutiu/providers/chat_provider.dart';
import 'package:tiutiu/utils/string_extension.dart';

class ChatTab extends StatefulWidget {
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> with SingleTickerProviderStateMixin {
  TabController _controller;
  ChatProvider chatProvider;
  Color inputColor = Colors.white;
  int initialIndex = 0;

  @override
  void initState() {
    _controller = TabController(
      vsync: this,
      length: 2,
      initialIndex: initialIndex,
    );

    _controller.addListener(onTabChange);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    chatProvider = Provider.of<ChatProvider>(context);
    super.didChangeDependencies();
  }

  void onTabChange() {
    initialIndex = _controller.index;
    chatProvider.changeCurrentlyTabChat(_controller.index);
  }

  void onTextSearchChanged(String value) {
    if (chatProvider.getCurrentlyTabChat == 0) {
      chatProvider.changeTextChatSearch(value.removeAccent());
    } else {
      chatProvider.changeTextGlobalChatSearch(value.removeAccent());
    }
  }

  Widget _textFieldSearch() {
    final _textSearchController = TextEditingController(text: chatProvider.getCurrentlyTabChat == 0 ? chatProvider.getTextChatSearch : chatProvider.getTextGlobalChatSearch);
    return TextField(
      controller: _textSearchController,
      onSubmitted: (value) => chatProvider.changeIsSearching(false),
      onChanged: onTextSearchChanged,
      cursorColor: inputColor,
      style: TextStyle(color: inputColor),
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              chatProvider.changeIsSearching(false);
              chatProvider.changeTextChatSearch('');
              chatProvider.changeTextGlobalChatSearch('');
              chatProvider.changeCurrentlyTabChat(0);
              Navigator.pop(context);
            },
          ),
          title: StreamBuilder<bool>(
              stream: chatProvider.isSearching,
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (snapshot.data == null || !snapshot.data)
                      Text(
                        'CHAT',
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    if (snapshot.data != null && snapshot.data)
                      Container(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _textFieldSearch(),
                        ),
                      ),
                    IconButton(
                      onPressed: () {
                        chatProvider.changeIsSearching(!chatProvider.getIsSearching);
                      },
                      icon: Icon(chatProvider.getIsSearching ? Icons.done : Icons.search_outlined, color: Colors.white),
                    )
                  ],
                );
              }),
          bottom: TabBar(
            controller: _controller,
            indicatorColor: Colors.purple,
            tabs: [
              Tab(icon: Icon(Icons.chat_bubble), text: 'MINHAS CONVERSAS'),
              Tab(icon: Icon(Icons.chat_sharp), text: 'TIU, TIU CHAT'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            MyChats(),
            GlobalChat(),
          ],
        ),
      ),
    );
  }
}
