import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinancialInfo extends StatefulWidget {
  const FinancialInfo({super.key});

  @override
  State<FinancialInfo> createState() => _FinancialInfoState();
}

class _FinancialInfoState extends State<FinancialInfo> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 8.0.h),
          children: [
            SizedBox(height: 16.0.h),
            _haveTimeEnough(),
            SizedBox(height: 8.0.w),
            _haveMoneyEnough(),
          ],
        );
      },
    );
  }

  Column _haveTimeEnough() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0.h),
          child: AutoSizeTexts.autoSizeText16(
            AppLocalizations.of(context)!.haveTimeEnough,
            color: AppColors.black.withOpacity(.5),
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: AutoSizeTexts.autoSizeText12(AppLocalizations.of(context)!.yes),
                onChanged: (_) {
                  adoptionFormController.setAdoptionForm(
                    adoptionFormController.adoptionForm.copyWith(haveTimeFreeToCare: true),
                  );
                },
                value: adoptionFormController.adoptionForm.haveTimeFreeToCare,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: AutoSizeTexts.autoSizeText12(AppLocalizations.of(context)!.no),
                onChanged: (_) {
                  adoptionFormController.setAdoptionForm(
                    adoptionFormController.adoptionForm.copyWith(haveTimeFreeToCare: false),
                  );
                },
                value: !adoptionFormController.adoptionForm.haveTimeFreeToCare,
              ),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }

  Column _haveMoneyEnough() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0.h),
          child: AutoSizeTexts.autoSizeText16(
            AppLocalizations.of(context)!.haveMoneyEnough,
            color: AppColors.black.withOpacity(.5),
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: AutoSizeTexts.autoSizeText12(AppLocalizations.of(context)!.yes),
                onChanged: (_) {
                  adoptionFormController.setAdoptionForm(
                    adoptionFormController.adoptionForm.copyWith(haveMoneyEnoughToCare: true),
                  );
                },
                value: adoptionFormController.adoptionForm.haveMoneyEnoughToCare,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: AutoSizeTexts.autoSizeText12(AppLocalizations.of(context)!.no),
                onChanged: (_) {
                  adoptionFormController.setAdoptionForm(
                    adoptionFormController.adoptionForm.copyWith(haveMoneyEnoughToCare: false),
                  );
                },
                value: !adoptionFormController.adoptionForm.haveMoneyEnoughToCare,
              ),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
