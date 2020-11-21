import 'package:flutter/material.dart';
import 'package:tiutiu/backend/Model/user_model.dart';

class InterestedListTile extends StatelessWidget {
  InterestedListTile({
    this.navigateToInterestedDetail,
    this.trailingFunction,
    this.interestedUser,
    this.trailingChild,
    this.subtitle,
  });

  final Function() navigateToInterestedDetail;
  final Function() trailingFunction;
  final User interestedUser;
  final String subtitle;
  final Widget trailingChild;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
        onTap: navigateToInterestedDetail,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: Hero(
              tag: '${interestedUser.photoURL}',
              child: FadeInImage(
                placeholder: AssetImage('assets/fundo.jpg'),
                image: interestedUser.photoURL != null
                    ? NetworkImage(interestedUser.photoURL)
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
      ),
      title: Text(interestedUser.name),
      subtitle: Text(subtitle),
      trailing: InkWell(
        onTap: trailingFunction,
        child: trailingChild,
      ),
    );
  }
}
