import 'package:tiutiu/features/adption_form.dart/views/flow/1_personal_info.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/material.dart';

class AdoptionFormFlow extends StatelessWidget {
  const AdoptionFormFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      PersonalInfo(),
    ];

    return WillPopScope(
      onWillPop: () async {
        adoptionFormController.previousStep();
        return false;
      },
      child: Scaffold(
        appBar: DefaultBasicAppBar(text: 'Formulário de adoção', automaticallyImplyLeading: true),
        body: steps.elementAt(adoptionFormController.formStep),
      ),
    );
  }
}
