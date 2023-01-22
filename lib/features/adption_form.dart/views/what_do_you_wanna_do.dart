import 'package:get/get.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
import 'package:tiutiu/core/widgets/custom_list_tile.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:flutter/material.dart';

class WhatDoYouWannaDo extends StatelessWidget {
  const WhatDoYouWannaDo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: 'Formulário de adoção'),
      body: Card(
        child: ListView(
          children: [
            AdBanner(
              adId: systemController.getAdMobBlockID(
                blockName: AdMobBlockName.homeFooterAdBlockId,
                type: AdMobType.banner,
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OneLineText(text: 'O que você quer fazer?'),
            ),
            CustomListTile(
              text: 'Editar',
              icon: Icons.edit,
              onTap: () async {
                await adoptionFormController.loadFormToUpdate();
                Get.toNamed(Routes.adoptionForm);
              },
            ),
            Divider(),
            CustomListTile(
              text: 'Compartilhar',
              icon: Icons.share,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
