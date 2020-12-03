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
  });

  final String chatId;
  final Messages message;

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    var docs = await firestore.collection('Chats').doc(widget.chatId).collection('messages').get();

    firestore.collection('Chats').doc(widget.chatId).collection('messages').add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': userProvider.uid,
        'userName': userProvider.displayName,
        'userImage': userProvider.photoURL,
      },
    );

    firestore.collection('Chats').doc(widget.chatId).set({
      'lastMessage': _enteredMessage,
      'lastMessageTime': Timestamp.now(),
    }, SetOptions(merge: true));

    _controller.clear();

    if (docs.docs.isEmpty) {
      print('Vazio');
      firestore.collection('Chats').doc(widget.chatId).set(widget.message.toJson(), SetOptions(merge: true));
    }
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
        child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Enviar mensagem'),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
        )
      ],
    ));
  }
}
