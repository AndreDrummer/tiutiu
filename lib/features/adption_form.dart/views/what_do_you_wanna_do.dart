import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/widgets/custom_list_tile.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhatDoYouWannaDo extends StatelessWidget {
  const WhatDoYouWannaDo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: AppLocalizations.of(context)!.adoptioinForm),
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
              child: OneLineText(text: AppLocalizations.of(context)!.whatYouWannaDo),
            ),
            _myForm(),
            Divider(),
            CustomListTile(
              text: AppLocalizations.of(context)!.generateAndShareEmptyFormTXT,
              icon: Icons.text_snippet_outlined,
              onTap: () async {
                await adoptionFormController.shareEmptyFormText();
              },
            ),
            CustomListTile(
              text: AppLocalizations.of(context)!.generateAndShareEmptyFormPDF,
              icon: Icons.picture_as_pdf_outlined,
              onTap: () async {
                await adoptionFormController.shareEmptyFormPDF();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _myForm() {
    return FutureBuilder(
      future: adoptionFormController.formExists(),
      builder: (context, snapshot) {
        return Visibility(
          visible: snapshot.data ?? true,
          child: Column(
            children: [
              CustomListTile(
                text: AppLocalizations.of(context)!.shareMyFormTXT,
                icon: Icons.text_snippet_outlined,
                onTap: () async {
                  await adoptionFormController.shareFormText();
                },
              ),
              CustomListTile(
                text: AppLocalizations.of(context)!.shareMyFormPDF,
                icon: Icons.picture_as_pdf_outlined,
                onTap: () async {
                  await adoptionFormController.shareFormPDF();
                },
              ),
              Divider(),
              CustomListTile(
                text: AppLocalizations.of(context)!.editMyForm,
                icon: Icons.edit_outlined,
                onTap: () async {
                  adoptionFormController.isEditing = true;
                  await adoptionFormController.loadForm();
                  Get.toNamed(Routes.adoptionForm);
                },
              ),
            ],
          ),
          replacement: CustomListTile(
            text: AppLocalizations.of(context)!.fillForm,
            icon: Icons.edit_note_outlined,
            onTap: () {
              Get.toNamed(Routes.adoptionForm);
            },
          ),
        );
      },
    );
  }
}
