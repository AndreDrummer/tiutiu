import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/widgets/doc_screen.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});
  @override
  Widget build(BuildContext context) {
    return DocScreen(
      docType: FirebaseEnvPath.termsandconditions,
      docTitle: AuthStrings.termsAndConditions,
    );
  }
}
