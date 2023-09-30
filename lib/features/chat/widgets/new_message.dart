import 'package:tiutiu/core/widgets/no_connection_text_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final Color destakColor = AppColors.secondary;
  final _controller = TextEditingController();
  final Color whiteColor = AppColors.white;
  String _enteredMessage = '';

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await chatController.sendNewMessage(
        Message(
          receiver: chatController.userChatingWith,
          sender: tiutiuUserController.tiutiuUser,
          createdAt: FieldValue.serverTimestamp(),
          text: _enteredMessage.trim(),
          id: Uuid().v4(),
        ),
      );
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        replacement: Container(
          child: Padding(
            padding: EdgeInsets.all(8.0.h),
            child: NoConnectionTextInfo(),
          ),
          color: AppColors.white,
        ),
        visible: systemController.properties.internetConnected,
        child: Container(
          margin: EdgeInsets.only(
            bottom: Dimensions.getDimensBasedOnDeviceHeight(
              smaller: 0.0.h,
              medium: 0.0.h,
              bigger: 8.0.h,
            ),
          ),
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
                    padding: EdgeInsets.only(left: 8.0.w, right: 4.0.w),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) async => await _sendMessage(),
                      style: TextStyle(color: Colors.black54),
                      controller: _controller,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                        disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: AppLocalizations.of(context)!.writeYourMessage,
                      ),
                      textInputAction: TextInputAction.send,
                      maxLines: 4,
                      minLines: 1,
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
                      margin: EdgeInsets.only(left: Get.height > 999 ? 4.0.w : 8.0.w),
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
        ),
      ),
    );
  }
}
