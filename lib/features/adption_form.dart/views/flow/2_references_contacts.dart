import 'package:tiutiu/core/widgets/outline_input_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
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
    return Scaffold(
      body: Obx(
        () {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 8.0.h),
            children: [phone1(), phone2(), phone3()],
          );
        },
      ),
    );
  }

  OutlinedInputText phone1() {
    return OutlinedInputText(
      keyboardType: TextInputType.phone,
      textColor: AppColors.black.withOpacity(.5),
      labelText: '${AdoptionFormQuestionsStrings.phone} 1',
      hintText: '${AdoptionFormQuestionsStrings.phone} 1',
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

  OutlinedInputText phone2() {
    return OutlinedInputText(
      keyboardType: TextInputType.phone,
      textColor: AppColors.black.withOpacity(.5),
      labelText: '${AdoptionFormQuestionsStrings.phone} 2',
      hintText: '${AdoptionFormQuestionsStrings.phone} 2',
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

  OutlinedInputText phone3() {
    return OutlinedInputText(
      keyboardType: TextInputType.phone,
      textColor: AppColors.black.withOpacity(.5),
      labelText: '${AdoptionFormQuestionsStrings.phone} 3',
      hintText: '${AdoptionFormQuestionsStrings.phone} 3',
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
}
