import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.belongToMe,
    required this.message,
    required this.user,
    required this.time,
    Key? key,
  }) : super(key: key);

  final bool belongToMe;
  final String message;
  final String time;
  final TiutiuUser user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              belongToMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Card(
              color: belongToMe
                  ? Theme.of(context).primaryColor
                  : Colors.grey[350],
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(belongToMe ? 12 : 0),
                  bottomRight: Radius.circular(belongToMe ? 0 : 12),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(),
                width: 140,
                margin: EdgeInsets.only(top: 15, left: 8, right: 8),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  crossAxisAlignment: belongToMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: belongToMe ? 8.0 : 0.0,
                          right: belongToMe ? 0.0 : 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            DateFormat('dd/MM/y HH:mm')
                                .format(DateTime.parse(time))
                                .split(' ')
                                .last,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: belongToMe
                                  ? AppColors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .color,
                            ),
                          ),
                          Spacer(),
                          AutoSizeText(
                            belongToMe
                                ? 'Eu'
                                : user.displayName!.split(' ').first,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: belongToMe
                                  ? AppColors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 0.2, color: AppColors.white),
                    AutoSizeText(
                      message,
                      textAlign: belongToMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        height: 2,
                        fontWeight: FontWeight.w600,
                        color: belongToMe
                            ? AppColors.white
                            : Theme.of(context).textTheme.headline4!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: belongToMe ? null : 130,
          right: belongToMe ? 130 : null,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: InkWell(
              onTap: () {
                OtherFunctions.navigateToAnnouncerDetail(user);
              },
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: AssetHandle.getImage(user.avatar),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
