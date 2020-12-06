import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:tiutiu/providers/ads_provider.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({this.messageLoading = 'Carregando aplicativo...', this.circle = false, this.textColor = Colors.white});

  final String messageLoading;
  final textColor;
  final bool circle;

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  AdsProvider adsProvider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          !widget.circle
              ? LoadingRotating.square(
                  size: 40.0,
                  borderColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                )
              : LoadingJumpingLine.circle(
                  size: 40.0,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
          SizedBox(height: 30.0),
          Text(
            widget.messageLoading,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1.copyWith(
                  color: widget.textColor,
                ),
          )
        ],
      ),
    );
  }
}
