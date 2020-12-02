import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() {
    final user = FirebaseAuth.instance.currentUser;

    FocusScope.of(context).unfocus();
    firestore.collection('Chats').doc('NmCCTS278fS56PzdutXj').collection('messages').add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': 'b', //user.uid,
        'userName': 'André',
        'userImage': ''
      },
    );

    _controller.clear();
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
