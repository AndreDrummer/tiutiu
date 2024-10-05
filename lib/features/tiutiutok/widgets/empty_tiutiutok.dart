import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyTiuTiuTokScreen extends StatelessWidget {
  const EmptyTiuTiuTokScreen({super.key, this.endOfList = false, this.onEndOfPage});

  final Function()? onEndOfPage;
  final bool endOfList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Container(
          height: 96.0.h,
          width: 96.0.h,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0.h),
            child: AssetHandle.getImage(ImageAssets.noTiutiutok),
          ),
        ),
        SizedBox(height: 16.0.h),
        Column(
          children: [
            Visibility(
              replacement: _endOfList(),
              visible: !endOfList,
              child: _emptyList(),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.width / 4),
              child: TextButton(
                child: AutoSizeTexts.autoSizeText12('Postar ${!endOfList ? 'um ' : ''}agora', color: Colors.white),
                style: TextButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () {
                  homeController.setPostIndex();
                },
              ),
            ),
          ],
        ),
        Spacer(),
        AdBanner(
          adId: systemController.getAdMobBlockID(
            blockName: AdMobBlockName.homeFooterAdBlockId,
            type: AdMobType.banner,
          ),
        ),
        SizedBox(height: 32.0.h)
      ],
    );
  }

  Row _emptyList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: AutoSizeTexts.autoSizeText12('Nenhum ', color: Colors.white),
        ),
        AutoSizeText('TiuTok', style: GoogleFonts.miltonianTattoo(color: Colors.white)),
        Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: AutoSizeTexts.autoSizeText12(' encontrado ', color: Colors.white),
        ),
      ],
    );
  }

  Column _endOfList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: AutoSizeTexts.autoSizeText12('Isso é tudo! Quer adicionar mais ', color: Colors.white),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText('TiuTok', style: GoogleFonts.miltonianTattoo(color: Colors.white)),
              AutoSizeTexts.autoSizeText12('\'s ?', color: Colors.white),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: AutoSizeTexts.autoSizeText12('Clique no botão abaixo.', color: Colors.white),
        ),
      ],
    );
  }
}
