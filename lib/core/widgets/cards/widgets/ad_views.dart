import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';

class AdViews extends StatelessWidget {
  const AdViews({
    required this.post,
    super.key,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        initialData: post.views,
        stream: postsController.postViews(post.uid!),
        builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.0.h),
            child: Row(
              children: [
                Icon(
                  color: Colors.grey[700],
                  FontAwesomeIcons.solidEye,
                  size: 7.0.h,
                ),
                Padding(
                  child: AutoSizeTexts.autoSizeText10(
                    color: Colors.grey[700],
                    '${snapshot.data ?? post.views} ${AppLocalizations.of(context)!.views}',
                    fontWeight: FontWeight.w400,
                  ),
                  padding: EdgeInsets.only(left: 4.0.w),
                ),
              ],
            ),
          );
        });
  }
}
