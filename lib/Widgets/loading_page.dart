import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({
    this.messageLoading = 'Carregando aplicativo...',
    this.circle = false
  });
  
  final String messageLoading;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            !circle ? LoadingBouncingGrid.square(
              size: 50.0,
              backgroundColor: Theme.of(context).primaryColor,
            ) :  LoadingJumpingLine.circle(
              size: 50.0,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 30.0),
            Text(              
              messageLoading,
              textAlign: TextAlign.center,
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
