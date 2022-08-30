import 'package:flutter/material.dart';

class CustomBottomNavigatorBar extends StatelessWidget {
  CustomBottomNavigatorBar({this.children});

  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        width: width,
        height: 100,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.pin_drop),
                  SizedBox(width: 10),
                  Text(
                    'Perto de você',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: children!.toList(),
            ),
          ],
        ),
      ),
    );
  }
}
