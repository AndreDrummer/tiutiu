import 'package:flutter/material.dart';
import 'package:tiutiu/Custom/icons.dart';

class InterestedInfoCard extends StatefulWidget {
  @override
  _InterestedInfoCardState createState() => _InterestedInfoCardState();
}

class _InterestedInfoCardState extends State<InterestedInfoCard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.asset('assets/bones.jpg'),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width - 100,
                      child: Text(
                        'André Felipe Jesus do Nascimento Silva',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Interessou dia 09/10/2020 10:11',
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
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: Icons.chat,
                  text: 'Chat',
                  color: Colors.red,
                ),
                SizedBox(width: width * 0.14),
                _ActionButton(
                  icon: Tiutiu.whatsapp,
                  text: 'WhatsApp',
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(width: width * 0.14),
                _ActionButton(
                  icon: Icons.phone,
                  text: 'Ligar',
                  color: Colors.orange,
                ),
              ],
            ),
            SizedBox(height: 5),
            _ActionButton(
              text: 'VER INFO',
              fontSize: 22,
              color: Colors.blue,
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
  });

  final IconData icon;
  final String text;
  final Color color;
  final bool isExpanded;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
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
            icon != null
                ? Icon(icon, size: 18, color: Colors.white)
                : Container(),
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
    );
  }
}
