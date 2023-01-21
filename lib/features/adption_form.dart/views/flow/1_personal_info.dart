import 'package:tiutiu/core/widgets/underline_input_dropdown.dart';
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
    return Scaffold(
      body: Obx(
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
      ),
    );
  }

  OutlinedInputText _fullname() {
    return OutlinedInputText(
      textColor: AppColors.black.withOpacity(.5),
      labelText: 'Nome Completo',
      hintText: 'Nome Completo',
      initialValue: adoptionFormController.adoptionForm.fullName,
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(fullName: value),
        );
      },
      fontSize: 14,
    );
  }

  OutlinedInputText _address() {
    return OutlinedInputText(
      textColor: AppColors.black.withOpacity(.5),
      labelText: 'Endereço',
      hintText: 'Endereço',
      initialValue: adoptionFormController.adoptionForm.address,
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(address: value),
        );
      },
      fontSize: 14,
    );
  }

  OutlinedInputText phone() {
    return OutlinedInputText(
      keyboardType: TextInputType.phone,
      textColor: AppColors.black.withOpacity(.5),
      labelText: 'Telefone',
      hintText: 'Telefone',
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter(),
      ],
      initialValue: adoptionFormController.adoptionForm.phone,
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(phone: value),
        );
      },
      fontSize: 14,
    );
  }

  OutlinedInputText email() {
    return OutlinedInputText(
      keyboardType: TextInputType.emailAddress,
      textColor: AppColors.black.withOpacity(.5),
      labelText: 'E-mail',
      hintText: 'E-mail',
      initialValue: adoptionFormController.adoptionForm.email,
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(email: value),
        );
      },
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
              labelBold: true,
              initialValue: adoptionFormController.adoptionForm.age,
              onChanged: (anos) {
                adoptionFormController.setAdoptionForm(
                  adoptionFormController.adoptionForm.copyWith(age: anos),
                );
              },
              items: List.generate(99, (index) => '${index == 0 ? '-' : index}'),
              labelText: 'Idade',
              fontSize: 12.0,
            ),
          ),
          Expanded(
            child: UnderlineInputDropdown(
              labelBold: true,
              initialValue: adoptionFormController.adoptionForm.maritalStatus,
              onChanged: (maritalStatus) {
                adoptionFormController.setAdoptionForm(
                  adoptionFormController.adoptionForm.copyWith(maritalStatus: maritalStatus),
                );
              },
              items: adoptionFormController.maritalStatus,
              labelText: 'Estado Civil',
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
      labelText: 'Profissão',
      hintText: 'Profissão',
      initialValue: adoptionFormController.adoptionForm.profission,
      onChanged: (value) {
        adoptionFormController.setAdoptionForm(
          adoptionFormController.adoptionForm.copyWith(profission: value),
        );
      },
      fontSize: 14,
    );
  }
}
