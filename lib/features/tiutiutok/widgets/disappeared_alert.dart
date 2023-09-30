import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/features/tiutiutok/widgets/text_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:flutter/material.dart';

class DisappearedAlertAnimation extends StatefulWidget {
  const DisappearedAlertAnimation({super.key, required this.post});

  final Post post;

  @override
  State<DisappearedAlertAnimation> createState() => _DisappearedAlertAnimationState();
}

class _DisappearedAlertAnimationState extends State<DisappearedAlertAnimation> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (widget.post as Pet).disappeared,
      child: Column(
        children: [
          LottieAnimation(
            animationPath: AnimationsAssets.alert,
            size: 48.0.h,
          ),
          TextButtonCount(
            text: AppLocalizations.of(context)!.petDisappeared,
            padding: EdgeInsets.only(top: 2.0.h),
            fontSize: 8.0.sp,
          ),
          SizedBox(height: 8.0.h),
        ],
      ),
    );
  }
}
