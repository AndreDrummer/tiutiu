import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:tiutiu/providers/ads_provider.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage(
      {this.messageLoading = 'Carregando aplicativo...', this.circle = false});

  final String messageLoading;
  final bool circle;

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  AdsProvider adsProvider;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            !widget.circle
                ? LoadingRotating.square(
                    size: 50.0,
                    borderColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                  )
                : LoadingJumpingLine.circle(
                    size: 50.0,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
            SizedBox(height: 30.0),
            Text(
              widget.messageLoading,
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
