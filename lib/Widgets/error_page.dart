import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingBouncingGrid.square(
              size: 100.0,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 30.0),
            Text(
              'Ocorreu um erro no aplicativo!!',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.white,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
