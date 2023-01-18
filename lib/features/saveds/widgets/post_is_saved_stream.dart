import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';

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
        print('Post is saved $isActive');

        return builder(Icons.bookmark, isActive);
      },
    );
  }
}
