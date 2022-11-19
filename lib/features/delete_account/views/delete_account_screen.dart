import 'package:flutter/material.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: AuthStrings.deleteAccount),
      body: Center(
        child: Text('Excluir conta!'),
      ),
    );
  }
}
