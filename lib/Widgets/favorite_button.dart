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
            Text(
              'FAVORITAR',
              style:
                  Theme.of(context).textTheme.headline1.copyWith(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
