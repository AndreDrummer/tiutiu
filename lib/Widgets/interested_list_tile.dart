import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class InterestedListTile extends StatelessWidget {
  InterestedListTile({
    this.navigateToInterestedDetail,
    this.trailingFunction,
    this.interestedUser,
    this.trailingChild,
    this.subtitle,
  });

  final Function()? navigateToInterestedDetail;
  final Function()? trailingFunction;
  final Widget? trailingChild;
  final TiutiuUser? interestedUser;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
        onTap: navigateToInterestedDetail,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: AssetHandle.getImage(interestedUser!.avatar),
          ),
        ),
      ),
      title: AutoSizeText(interestedUser!.displayName!),
      subtitle: AutoSizeText(subtitle!),
      trailing: InkWell(
        onTap: trailingFunction,
        child: trailingChild,
      ),
    );
  }
}
