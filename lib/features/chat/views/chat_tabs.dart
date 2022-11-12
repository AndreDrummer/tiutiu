import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/chat/views/global_chat.dart';
import 'package:tiutiu/features/chat/views/my_contacts.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ChatTab extends StatefulWidget {
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> with SingleTickerProviderStateMixin {
  Color inputColor = AppColors.white;
  late TabController _controller;

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

  void onTabChange() {
    initialIndex = _controller.index;
    chatController.textChatSearch = '';
    chatController.textGlobalChatSearch = '';
    chatController.currentlyTabChat = _controller.index;
  }

  void onTextSearchChanged(String value) {
    if (chatController.currentlyTabChat == 0) {
      chatController.textChatSearch = value.removeAccent();
    } else {
      chatController.textGlobalChatSearch = value.removeAccent();
    }
  }

  Widget _textFieldSearch() {
    final _textSearchController = TextEditingController(
        text:
            chatController.currentlyTabChat == 0 ? chatController.textChatSearch : chatController.textGlobalChatSearch);
    return TextField(
      controller: _textSearchController,
      onSubmitted: (value) => chatController.isSearching = false,
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
              chatController.textGlobalChatSearch = '';
              chatController.currentlyTabChat = 0;
              chatController.isSearching = false;
              chatController.textChatSearch = '';
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!chatController.isSearching)
                AutoSizeText(
                  'chat',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              if (chatController.isSearching)
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _textFieldSearch(),
                  ),
                ),
              IconButton(
                onPressed: () {
                  chatController.isSearching = !chatController.isSearching;
                },
                icon: Icon(
                  chatController.isSearching ? Icons.done : Icons.search_outlined,
                  color: AppColors.white,
                ),
              )
            ],
          ),
          bottom: TabBar(
            controller: _controller,
            indicatorColor: AppColors.secondary,
            tabs: [
              Tab(icon: Icon(Icons.chat_bubble), text: 'MINHAS CONVERSAS'),
              Tab(icon: Icon(Icons.chat_sharp), text: 'TIU, TIU chat'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            MyContacts(),
            GlobalChat(),
          ],
        ),
      ),
    );
  }
}
