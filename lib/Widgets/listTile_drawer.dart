import 'package:flutter/material.dart';

class ListTileDrawer extends StatelessWidget {
  ListTileDrawer({this.imageAsset, this.tileName, this.callback, this.icon});

  final String imageAsset;
  final String tileName;
  final IconData icon;
  final Function() callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: icon == null
                ? Container(
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(icon, color: Colors.black, size: 30),
            title: Text(
              tileName,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
