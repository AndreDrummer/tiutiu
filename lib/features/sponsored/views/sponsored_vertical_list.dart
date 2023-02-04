import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/features/sponsored/widget/sponsodred_tile.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class SponsoredVerticalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sponsoreds = sponsoredController.sponsoreds;

    return Scaffold(
      appBar: DefaultBasicAppBar(text: MyProfileOptionsTile.partners),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OneLineText(
              text: 'Junte-se à nossa rede de empresas apoiadoras e ajude a fazer a diferença na vida dos animais.',
              fontWeight: FontWeight.normal,
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => SponsoredTile(sponsored: sponsoreds.reversed.toList()[index]),
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              itemCount: sponsoreds.length,
            ),
          ),
          AdBanner(
            adId: systemController.getAdMobBlockID(
              blockName: AdMobBlockName.homeFooterAdBlockId,
              type: AdMobType.banner,
            ),
          ),
          SizedBox(height: 1.0.h),
        ],
      ),
    );
  }
}
