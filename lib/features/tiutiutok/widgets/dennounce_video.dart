import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/tiutiu_snackbar.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class DennounceVideoButton extends StatelessWidget with TiuTiuPopUp {
  const DennounceVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8.0.w,
      top: 72.0.h,
      child: PopupMenuButton<String>(
        icon: Icon(
          Platform.isIOS ? Icons.more_horiz_outlined : Icons.more_vert_outlined,
          color: AppColors.white,
        ),
        onSelected: (String item) {
          if (item == AppLocalizations.of(context).dennounceVideo) {
            ScaffoldMessenger.of(context).showSnackBar(
              TiuTiuSnackBar(message: AppLocalizations.of(context).dennounceSentSuccessfully),
            );
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            child: Text(AppLocalizations.of(context).dennounceVideo),
            value: AppLocalizations.of(context).dennounceVideo,
          ),
        ],
      ),
    );
  }
}
