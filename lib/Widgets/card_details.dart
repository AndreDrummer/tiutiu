import 'package:flutter/material.dart';

class CardDetails extends StatelessWidget {
  CardDetails({
    this.icon,
    this.title,
    this.text,
  });

  final String title;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 75,
        width: 170,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 8.0),
              Opacity(
                opacity: 0.4,
                child: Icon(icon, color: Theme.of(context).primaryColor, size: 35),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          title.toUpperCase(),
                          style: TextStyle(
                            letterSpacing: 1.2,
                            // fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FittedBox(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCardInfo extends StatelessWidget {
  UserCardInfo({
    this.imageN,
    this.image,
    this.text,
    this.title,
    this.icon,
    this.color,
    this.callback,
    this.launchIcon,
  });

  final String text;
  final String title;
  final String image;
  final String imageN;
  final IconData icon;
  final IconData launchIcon;
  final Function() callback;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 20,
          child: ClipOval(
            child: Container(
              color: color,
              child: icon != null
                  ? Icon(icon, color: Colors.white, size: 60)
                  : imageN != null
                      ? FadeInImage(
                          placeholder: AssetImage('assets/profileEmpty.png'),
                          image: imageN != null
                              ? NetworkImage(
                                  imageN,
                                )
                              : AssetImage('assets/profileEmpty.png'),
                          fit: BoxFit.cover,
                          width: 1000,
                          height: 100,
                        )
                      : Image.asset(
                          image,
                          fit: BoxFit.fill,
                          width: 105,
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
