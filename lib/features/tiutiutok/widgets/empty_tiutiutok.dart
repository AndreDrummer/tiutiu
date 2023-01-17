import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class EmptyTiuTiuTokScreen extends StatelessWidget {
  const EmptyTiuTiuTokScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 96.0.h,
          width: 96.0.h,
          decoration: BoxDecoration(
            color: AppColors.black,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0.h),
            child: AssetHandle.getImage(ImageAssets.noTiutiutok),
          ),
        ),
        SizedBox(height: 32.0.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: AutoSizeTexts.autoSizeText12('Nenhum ', color: AppColors.black),
            ),
            AutoSizeText('Tiutiu Tok', style: GoogleFonts.miltonianTattoo(color: AppColors.black)),
            Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: AutoSizeTexts.autoSizeText12(' encontrado ', color: AppColors.black),
            ),
          ],
        )
      ],
    );
  }
}
