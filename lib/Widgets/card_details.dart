import 'package:flutter/material.dart';
import 'package:tiutiu/core/utils/image_handle.dart';

class CardDetails extends StatelessWidget {
  CardDetails({
    this.title,
    this.icon,
    this.text,
  });

  final IconData? icon;
  final String? title;
  final String? text;

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
            children: [
              SizedBox(width: 8.0),
              Opacity(
                opacity: 0.4,
                child:
                    Icon(icon, color: Theme.of(context).primaryColor, size: 35),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          title!.toUpperCase(),
                          style: TextStyle(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FittedBox(
                        child: Text(
                          text!,
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
    this.launchIcon,
    this.callback,
    this.imageN,
    this.title,
    this.image,
    this.text,
    this.icon,
    this.color,
  });

  final Function()? callback;
  final IconData? launchIcon;
  final String? imageN;
  final IconData? icon;
  final String? title;
  final String? image;
  final String? text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback?.call();
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
                          placeholder: AssetImage('assets/profileEmpty.webp'),
                          image: AssetHandle(
                            imageN,
                          ).build(),
                          fit: BoxFit.cover,
                          width: 1000,
                          height: 100,
                        )
                      : Image.asset(
                          image!,
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
