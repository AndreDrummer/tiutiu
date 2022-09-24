import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PetOtherCaracteristicsCard extends StatelessWidget {
  PetOtherCaracteristicsCard({
    this.content,
    this.title,
    this.icon,
  });

  final String? content;
  final IconData? icon;
  final String? title;

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
                        child: AutoSizeText(
                          title!.toUpperCase(),
                          style: TextStyle(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FittedBox(
                        child: AutoSizeText(
                          content!,
                          style: TextStyles.fontSize(
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
                  ? Icon(icon, color: AppColors.white, size: 60)
                  : imageN != null
                      ? AssetHandle.getImage(imageN)
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
