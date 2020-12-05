import 'package:flutter/material.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
import 'package:tiutiu/utils/launcher_functions.dart';

class InterestedInfoCard extends StatefulWidget {
  InterestedInfoCard({
    this.navigateToInterestedDetail,
    this.openChat,
    this.infoOrDonateFunction,
    this.interestedUser,
    this.infoOrDonteText,
    this.subtitle,
    this.color,
  });

  final Function() navigateToInterestedDetail;
  final Function() openChat;
  final Function() infoOrDonateFunction;
  final User interestedUser;
  final String subtitle;
  final String infoOrDonteText;
  final Color color;

  @override
  _InterestedInfoCardState createState() => _InterestedInfoCardState();
}

class _InterestedInfoCardState extends State<InterestedInfoCard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    bool canMakeCallLandline = widget.interestedUser.landline != null && widget.interestedUser.landline.isNotEmpty;

    bool canOpenWhatsApp = widget.interestedUser.phoneNumber != null && widget.interestedUser.phoneNumber.isNotEmpty;

    String phoneToCall;

    if (canMakeCallLandline || canOpenWhatsApp) {
      phoneToCall = canMakeCallLandline ? widget.interestedUser.landline : widget.interestedUser.phoneNumber;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: widget.navigateToInterestedDetail,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: FadeInImage(
                        placeholder: AssetImage('assets/fundo.jpg'),
                        image: widget.interestedUser.photoURL != null
                            ? NetworkImage(widget.interestedUser.photoURL)
                            : AssetImage(
                                'assets/fundo.jpg',
                              ),
                        fit: BoxFit.fill,
                        width: 1000,
                        height: 1000,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width - 100,
                      child: Text(
                        widget.interestedUser.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                _ActionButton(
                  icon: Icons.chat,
                  onPressed: widget.openChat,
                  text: 'Chat',
                  color: Colors.purple,
                ),
                SizedBox(width: width * 0.14),
                canOpenWhatsApp
                    ? _ActionButton(
                        onPressed: () {
                          Launcher.openWhatsApp(number: widget.interestedUser.phoneNumber);
                        },
                        icon: Tiutiu.whatsapp,
                        text: 'WhatsApp',
                        color: Theme.of(context).primaryColor,
                      )
                    : Text(''),
                SizedBox(width: width * 0.14),
                phoneToCall != null
                    ? _ActionButton(
                        onPressed: () {
                          Launcher.makePhoneCall(number: phoneToCall);
                        },
                        icon: Icons.phone,
                        text: 'Ligar',
                        color: Colors.orange,
                      )
                    : Text(''),
              ],
            ),
            SizedBox(height: 5),
            _ActionButton(
              onPressed: widget.infoOrDonateFunction,
              text: widget.infoOrDonteText.toUpperCase(),
              fontSize: 22,
              color: widget.color,
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  _ActionButton({
    this.icon,
    this.text,
    this.color,
    this.isExpanded = false,
    this.fontSize,
    this.onPressed,
  });

  final IconData icon;
  final String text;
  final Color color;
  final bool isExpanded;
  final double fontSize;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: isExpanded ? double.infinity : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null ? Icon(icon, size: 18, color: Colors.white) : Container(),
              SizedBox(width: 5),
              Text(
                text,
                style: Theme.of(context).textTheme.headline1.copyWith(
                      color: Colors.white,
                      fontSize: fontSize != null ? fontSize : null,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
