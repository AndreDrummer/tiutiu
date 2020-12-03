import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.message, this.belongToMe, this.userImage, this.userName, this.key}) : super(key: key);

  @override
  final Key key;
  final String message;
  final bool belongToMe;
  final String userName;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: belongToMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Card(
              color: belongToMe ? Theme.of(context).primaryColor : Colors.grey[350],
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
                  crossAxisAlignment: belongToMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: belongToMe ? Colors.white : Theme.of(context).accentTextTheme.headline1.color,
                      ),
                    ),
                    Text(
                      message,
                      textAlign: belongToMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        height: 2,
                        color: belongToMe ? Colors.white : Theme.of(context).accentTextTheme.headline1.color,
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
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: FadeInImage(
                  placeholder: AssetImage('assets/profileEmpty.png'),
                  image: userImage != null ? NetworkImage(userImage) : AssetImage('assets/profileEmpty.jpg'),
                  fit: BoxFit.cover,
                  width: 1000,
                  height: 100,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
