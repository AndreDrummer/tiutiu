import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/backend/Model/messages_model.dart';
import 'package:tiutiu/providers/user_provider.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class NewMessage extends StatefulWidget {
  NewMessage({
    this.chatId,
    this.message,
    this.receiverNotificationToken,
    this.receiverId,
  });

  final String chatId;
  final Messages message;
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

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    if (widget.message != null) {
      print('Vazio');
      firestore.collection('Chats').doc(widget.chatId).set(widget.message.toJson(), SetOptions(merge: true));
    }

    firestore.collection('Chats').doc(widget.chatId).collection('messages').add(
      {
        'text': _enteredMessage,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': userProvider.uid,
        'userName': userProvider.displayName,
        'userImage': userProvider.photoURL,
        'receiverId': widget.receiverId,
        'receiverNotificationToken': widget.receiverNotificationToken,
        'notificationType': 'chatNotification'
      },
    );

    firestore.collection('Chats').doc(widget.chatId).set({
      'lastMessage': _enteredMessage,
      'lastMessageTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    _controller.clear();
  }

  UserProvider userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of(context);
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
