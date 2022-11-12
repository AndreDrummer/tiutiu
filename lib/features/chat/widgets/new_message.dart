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
    required this.chatId,
  });

  final String receiverNotificationToken;
  final String receiverId;
  final Contact contact;
  final String chatId;

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';
  final Color destakColor = AppColors.secondary;
  final Color whiteColor = AppColors.white;

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    chatController.createFirstMessage(widget.chatId, widget.contact);

    chatController.sendNewMessage(
      widget.chatId,
      Message(
        text: _enteredMessage,
        createdAt: FieldValue.serverTimestamp(),
        senderId: tiutiuUserController.tiutiuUser.uid!,
        id: Uuid().v4(),
      ),
    );

    chatController.updateLastMessage(
      widget.chatId,
      {
        'lastSender': tiutiuUserController.tiutiuUser.uid,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessage': _enteredMessage,
        'open': false,
      },
    );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0.w),
              color: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 8.0.w),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) => _sendMessage(),
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: Colors.black54),
                  decoration: InputDecoration(
                    labelText: 'Escreva sua mensagem...',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
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
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: destakColor,
              ),
              padding: const EdgeInsets.all(14.0),
              child: Padding(
                child: Icon(Icons.send_rounded, color: whiteColor),
                padding: const EdgeInsets.only(left: 4.0),
              ),
            ),
            onTap: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
