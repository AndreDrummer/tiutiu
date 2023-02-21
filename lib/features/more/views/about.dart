import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/widgets/doc_screen.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});
  @override
  Widget build(BuildContext context) {
    return DocScreen(
      docText: AppLocalizations.of(context).aboutText,
      docTitle: AppLocalizations.of(context).about,
    );
  }
}
