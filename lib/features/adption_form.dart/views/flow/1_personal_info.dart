import 'package:tiutiu/core/widgets/underline_input_dropdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/widgets/outline_input_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 8.0.h),
          children: [
            _fullname(),
            _address(),
            phone(),
            email(),
            _ageAndMaritalStatus(),
            _profission(),
          ],
        );
      },
    );
  }

  OutlinedInputText _fullname() {
    return OutlinedInputText(
      initialValue: adoptionFormController.adoptionForm.fullName,
      labelText: AppLocalizations.of(context).fullname,
      hintText: AppLocalizations.of(context).fullname,
      textColor: AppColors.black.withOpacity(.5),
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(fullName: value),
        );
      },
      showCounterText: true,
      maxLength: 70,
      fontSize: 14,
    );
  }

  OutlinedInputText _address() {
    return OutlinedInputText(
      initialValue: adoptionFormController.adoptionForm.address,
      labelText: AppLocalizations.of(context).address,
      hintText: AppLocalizations.of(context).address,
      textColor: AppColors.black.withOpacity(.5),
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(address: value),
        );
      },
      showCounterText: true,
      maxLength: 70,
      fontSize: 14,
    );
  }

  OutlinedInputText phone() {
    return OutlinedInputText(
      initialValue: adoptionFormController.adoptionForm.phone,
      labelText: AppLocalizations.of(context).phone,
      hintText: AppLocalizations.of(context).phone,
      textColor: AppColors.black.withOpacity(.5),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter(),
      ],
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(phone: value),
        );
      },
      showCounterText: true,
      maxLength: 70,
      fontSize: 14,
    );
  }

  OutlinedInputText email() {
    return OutlinedInputText(
      initialValue: adoptionFormController.adoptionForm.email,
      labelText: AppLocalizations.of(context).email,
      hintText: AppLocalizations.of(context).email,
      textColor: AppColors.black.withOpacity(.5),
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(email: value),
        );
      },
      showCounterText: true,
      maxLength: 70,
      fontSize: 14,
    );
  }

  Padding _ageAndMaritalStatus() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0.h, bottom: 4.0.h),
      child: Row(
        children: [
          Expanded(
            child: UnderlineInputDropdown(
              color: AppColors.black.withOpacity(.5),
              onChanged: (anos) {
                adoptionFormController.setAdoptionForm(
                  adoptionFormController.adoptionForm.copyWith(age: anos),
                );
              },
              items: List.generate(99, (index) => '${index == 0 ? '-' : index}'),
              initialValue: adoptionFormController.adoptionForm.age,
              labelText: AppLocalizations.of(context).age,
              labelBold: true,
              fontSize: 12.0,
            ),
          ),
          Expanded(
            child: UnderlineInputDropdown(
              color: AppColors.black.withOpacity(.5),
              onChanged: (maritalStatus) {
                adoptionFormController.setAdoptionForm(
                  adoptionFormController.adoptionForm.copyWith(maritalStatus: maritalStatus),
                );
              },
              initialValue: adoptionFormController.adoptionForm.maritalStatus,
              labelText: AppLocalizations.of(context).maritalStatus,
              items: adoptionFormController.maritalStatus,
              labelBold: true,
              fontSize: 12.0,
            ),
          )
        ],
      ),
    );
  }

  OutlinedInputText _profission() {
    return OutlinedInputText(
      textColor: AppColors.black.withOpacity(.5),
      initialValue: adoptionFormController.adoptionForm.profission,
      labelText: AppLocalizations.of(context).profession,
      hintText: AppLocalizations.of(context).profession,
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(profission: value),
        );
      },
      showCounterText: true,
      maxLength: 70,
      fontSize: 14,
    );
  }
}
