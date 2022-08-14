import 'package:flutter/material.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/utils/image_handle.dart';

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
            child: Hero(
              tag: '${interestedUser!.photoURL}',
              child: FadeInImage(
                placeholder: AssetImage('assets/fundo.jpg'),
                image: AssetHandle(interestedUser!.photoURL).build(),
                fit: BoxFit.fill,
                width: 1000,
                height: 1000,
              ),
            ),
          ),
        ),
      ),
      title: Text(interestedUser!.name!),
      subtitle: Text(subtitle!),
      trailing: InkWell(
        onTap: trailingFunction,
        child: trailingChild,
      ),
    );
  }
}
