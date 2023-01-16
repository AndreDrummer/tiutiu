import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';

class PostIsSavedStream extends StatelessWidget {
  const PostIsSavedStream({super.key, required this.post, required this.builder});

  final Widget Function(IconData icon, bool isActive) builder;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: savedsController.postIsSaved(post),
      builder: (context, snapshot) {
        final isActive = snapshot.data ?? false;

        final icon = isActive ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark;

        return builder(icon, isActive);
      },
    );
  }
}
