import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.favorite_border, color: Colors.white, size: 50),
            AutoSizeText(
              'FAVORITAR',
              style:
                  Theme.of(context).textTheme.headline4!.copyWith(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
