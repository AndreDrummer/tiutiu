import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/widgets/outline_input_text.dart';
import 'package:tiutiu/core/widgets/underline_input_dropdown.dart';
import 'package:tiutiu/core/widgets/underline_text.dart';
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
      appBar: DefaultBasicAppBar(text: 'Formulário de adoção'),
      body: Obx(
        () {
          return ListView(
            children: [
              SizedBox(height: 8.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeTexts.autoSizeText12(
                      'Importante!',
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                      color: AppColors.danger,
                    ),
                    SizedBox(height: 8.0.h),
                    AutoSizeTexts.autoSizeText12(
                      'Todas as questões são opcionais. Vai de cada adotante responder às que estiver confortável.',
                    ),
                  ],
                ),
              ),
              Divider(height: 8.0.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OneLineText(
                  text: '1. Informações Pessoais',
                  fontSize: 18,
                ),
              ),
              Divider(height: 8.0.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                child: OutlinedInputText(
                  textColor: AppColors.black.withOpacity(.5),
                  labelText: 'Nome Completo',
                  hintText: 'Nome Completo',
                  initialValue: adoptionFormController.adoptionForm.fullName,
                  onChanged: (value) {
                    adoptionFormController.setAdoptionForm(
                      adoptionFormController.adoptionForm.copyWith(fullName: value),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                child: OutlinedInputText(
                  textColor: AppColors.black.withOpacity(.5),
                  labelText: 'Endereço',
                  hintText: 'Endereço',
                  initialValue: adoptionFormController.adoptionForm.address,
                  onChanged: (value) {
                    adoptionFormController.setAdoptionForm(
                      adoptionFormController.adoptionForm.copyWith(address: value),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                child: OutlinedInputText(
                  textColor: AppColors.black.withOpacity(.5),
                  labelText: 'Telefone',
                  hintText: 'Telefone',
                  initialValue: adoptionFormController.adoptionForm.phone,
                  onChanged: (value) {
                    adoptionFormController.setAdoptionForm(
                      adoptionFormController.adoptionForm.copyWith(phone: value),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                child: OutlinedInputText(
                  textColor: AppColors.black.withOpacity(.5),
                  labelText: 'E-mail',
                  hintText: 'E-mail',
                  initialValue: adoptionFormController.adoptionForm.email,
                  onChanged: (value) {
                    adoptionFormController.setAdoptionForm(
                      adoptionFormController.adoptionForm.copyWith(email: value),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                child: Row(
                  children: [
                    Expanded(
                      child: UnderlineInputDropdown(
                        initialValue: adoptionFormController.adoptionForm.age!,
                        onChanged: (anos) {
                          adoptionFormController.setAdoptionForm(
                            adoptionFormController.adoptionForm.copyWith(age: anos),
                          );
                        },
                        labelText: 'Idade',
                        fontSize: 12.0,
                        items: List.generate(99, (index) => '$index'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16.0.h),
                        child: OutlinedInputText(
                          textColor: AppColors.black.withOpacity(.5),
                          labelText: 'Estado Civil',
                          hintText: 'Estado Civil',
                          initialValue: adoptionFormController.adoptionForm.maritalStatus,
                          onChanged: (value) {
                            adoptionFormController.setAdoptionForm(
                              adoptionFormController.adoptionForm.copyWith(maritalStatus: value),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                child: OutlinedInputText(
                  textColor: AppColors.black.withOpacity(.5),
                  labelText: 'Profissão',
                  hintText: 'Profissão',
                  initialValue: adoptionFormController.adoptionForm.profission,
                  onChanged: (value) {
                    adoptionFormController.setAdoptionForm(
                      adoptionFormController.adoptionForm.copyWith(profission: value),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
