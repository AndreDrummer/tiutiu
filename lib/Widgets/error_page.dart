import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/images_assets.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({
    this.errorText =
        'Ocorreu um erro Inesperado! Tente sair e entrar novamente. Se não resolver, aguarde nova atualização do app.',
  });

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 80,
              child: ClipOval(
                child: Image.asset(ImageAssets.sadPanda),
              ),
            ),
            SizedBox(height: 30.0),
            AutoSizeText(
              errorText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: AppColors.white,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
