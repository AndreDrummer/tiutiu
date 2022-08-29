import 'package:flutter/material.dart';

class AuthErrorPage extends StatelessWidget {
  const AuthErrorPage({
    Key? key,
    this.onErrorCallback,
    this.error,
  }) : super(key: key);

  final void Function()? onErrorCallback;
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ocorreu um erro!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  style: BorderStyle.solid,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/newLogo.webp'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '$error',
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            TextButton.icon(
              icon: Icon(Icons.exit_to_app),
              onPressed: onErrorCallback,
              label: Text('Deslogar'),
            )
          ],
        ),
      ),
    );
  }
}
