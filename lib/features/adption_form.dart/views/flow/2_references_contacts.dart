import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/widgets/outline_input_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferenceContacts extends StatefulWidget {
  const ReferenceContacts({super.key});

  @override
  State<ReferenceContacts> createState() => _ReferenceContactsState();
}

class _ReferenceContactsState extends State<ReferenceContacts> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 8.0.h),
          children: [SizedBox(height: 8.0.h), phone1(), phone2(), phone3()],
        );
      },
    );
  }

  OutlinedInputText phone1() {
    return OutlinedInputText(
      keyboardType: TextInputType.phone,
      textColor: AppColors.black.withOpacity(.5),
      labelText: '${AppLocalizations.of(context)!.phone} 1',
      hintText: '${AppLocalizations.of(context)!.phone} 1',
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter(),
      ],
      initialValue: adoptionFormController.adoptionForm.referenceContact1,
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(referenceContact1: value),
        );
      },
      fontSize: 14,
    );
  }

  OutlinedInputText phone2() {
    return OutlinedInputText(
      keyboardType: TextInputType.phone,
      textColor: AppColors.black.withOpacity(.5),
      labelText: '${AppLocalizations.of(context)!.phone} 2',
      hintText: '${AppLocalizations.of(context)!.phone} 2',
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter(),
      ],
      initialValue: adoptionFormController.adoptionForm.referenceContact2,
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(referenceContact2: value),
        );
      },
      fontSize: 14,
    );
  }

  OutlinedInputText phone3() {
    return OutlinedInputText(
      keyboardType: TextInputType.phone,
      textColor: AppColors.black.withOpacity(.5),
      labelText: '${AppLocalizations.of(context)!.phone} 3',
      hintText: '${AppLocalizations.of(context)!.phone} 3',
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter(),
      ],
      initialValue: adoptionFormController.adoptionForm.referenceContact3,
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(referenceContact3: value),
        );
      },
      fontSize: 14,
    );
  }
}
