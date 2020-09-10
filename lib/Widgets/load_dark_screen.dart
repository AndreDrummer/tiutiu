import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadDarkScreen extends StatelessWidget {
  LoadDarkScreen(this.show, this.message);
  final bool show;
  final String message;

  @override
  Widget build(BuildContext context) {
    return show
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingBumpingLine.circle(
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Aguarde',
                    style: Theme.of(context).textTheme.headline1.copyWith(),
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
