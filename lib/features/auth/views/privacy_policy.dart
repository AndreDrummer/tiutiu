import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/widgets/doc_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});
  @override
  Widget build(BuildContext context) {
    return DocScreen(
      docType: FirebaseEnvPath.privacypolicy,
      docTitle: AppLocalizations.of(context).privacyPolicy,
    );
  }
}
