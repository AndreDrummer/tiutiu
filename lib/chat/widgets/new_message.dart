import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/backend/Model/chat_model.dart';
import 'package:tiutiu/backend/Model/message_model.dart';
import 'package:tiutiu/providers/chat_provider.dart';
import 'package:tiutiu/providers/user_provider.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class NewMessage extends StatefulWidget {
  NewMessage({
    this.chatId,
    this.chat,
    this.receiverNotificationToken,
    this.receiverId,
  });

  final String chatId;
  final Chat chat;
  final String receiverNotificationToken;
  final String receiverId;

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';
  final Color destakColor = Colors.purple;
  final Color whiteColor = Colors.white;

  ChatProvider chatProvider;
  UserProvider userProvider;

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    if (widget.chat != null) {
      chatProvider.createFirstMessage(widget.chatId, widget.chat);
    }

    chatProvider.sendNewMessage(
      widget.chatId,
      Message(
        text: _enteredMessage,
        createdAt: FieldValue.serverTimestamp(),
        userId: userProvider.uid,
        user: userProvider.user(),
        receiverId: widget.receiverId,
        receiverNotificationToken: widget.receiverNotificationToken,
        notificationType: 'chatNotification',
        userReference: userProvider.userReference,
      ),
    );

    chatProvider.updateLastMessage(
      widget.chatId,
      {
        'lastMessage': _enteredMessage,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'open': false,
        'lastSender': userProvider.uid,
      },
    );

    _controller.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chatProvider = Provider.of<ChatProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    topLeft: Radius.circular(12),
                  ),
                  color: whiteColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) => _sendMessage(),
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: Colors.black54),
                  decoration: InputDecoration(
                    labelText: 'Escreva sua mensagem...',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _enteredMessage = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: destakColor,
              ),
              padding: const EdgeInsets.all(6.0),
              child: IconButton(
                iconSize: 25,
                icon: Icon(
                  Icons.send_rounded,
                  color: whiteColor,
                ),
                onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              ),
            )
          ],
        ));
  }
}
