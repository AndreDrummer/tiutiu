import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/widgets/doc_screen.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});
  @override
  Widget build(BuildContext context) => DocScreen(docTitle: MyProfileOptionsTile.about, docType: FirebaseEnvPath.about);
}
