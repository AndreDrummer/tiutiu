import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
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
        width: 128.0.w,
        height: 72.0.h,
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 32.0.w,
                child: Opacity(
                  opacity: 0.4,
                  child: Icon(
                    color: Theme.of(context).primaryColor,
                    size: 16.0.h,
                    icon,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 72.0.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: AutoSizeTexts.autoSizeText12(
                          title!.toUpperCase(),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 10),
                      FittedBox(
                        child: AutoSizeTexts.autoSizeText12(
                          textOverflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w700,
                          '$content',
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
