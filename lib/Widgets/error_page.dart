import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({
    this.errorText = 'Ocorreu um erro Inesperado! Tente sair e entrar novamente. Se não resolver, aguarde nova atualização do app.',
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
                child: Image.asset('assets/sad-panda.jpg'),
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              errorText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    color: Colors.white,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
