import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class NewMessage extends StatefulWidget {
  NewMessage({
    required this.receiverNotificationToken,
    required this.receiverId,
    required this.contact,
  });

  final String receiverNotificationToken;
  final String receiverId;
  final Contact contact;

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final Color destakColor = AppColors.secondary;
  final _controller = TextEditingController();
  final Color whiteColor = AppColors.white;
  String _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    chatController.createFirstMessage(widget.contact.id!, widget.contact);

    chatController.sendNewMessage(
      widget.contact.id!,
      Message(
        senderId: tiutiuUserController.tiutiuUser.uid!,
        createdAt: FieldValue.serverTimestamp(),
        text: _enteredMessage,
        id: Uuid().v4(),
      ),
    );

    chatController.updateContactLastMessage(
      widget.contact.copyWith(
        lastMessageTime: FieldValue.serverTimestamp(),
        lastSenderId: tiutiuUserController.tiutiuUser.uid,
        lastMessage: _enteredMessage,
      ),
    );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Platform.isIOS ? 8.0.h : 0.0),
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 16.0,
              color: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16.0.w),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) => _sendMessage(),
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: Colors.black54),
                  decoration: InputDecoration(
                    hintText: 'Escreva sua mensagem...',
                    hintStyle: TextStyle(color: Colors.grey),
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
          ),
          GestureDetector(
            child: SizedBox(
              height: 56.0,
              width: 56.0,
              child: Card(
                elevation: 16.0,
                color: destakColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(1000)),
                ),
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  margin: EdgeInsets.only(left: 8.0.w),
                  child: Padding(
                    child: Icon(Icons.send_rounded, color: whiteColor),
                    padding: EdgeInsets.only(right: 4.0.w),
                  ),
                ),
              ),
            ),
            onTap: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
