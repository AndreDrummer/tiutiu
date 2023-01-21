import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tiutiu/features/adption_form.dart/views/flow/1_personal_info.dart';

class InitAdoptionFormFlow extends StatelessWidget {
  const InitAdoptionFormFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersonalInfo(),
    );
  }
}
