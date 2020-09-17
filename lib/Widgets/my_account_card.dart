import 'package:flutter/material.dart';

class MyAccountCard extends StatelessWidget {
  MyAccountCard({this.icone, this.onTap, this.text});

  final String text;
  final IconData icone;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width * 0.485
        ),
        child: Card(
          elevation: 6.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icone, color: Colors.grey, size: 30),
                SizedBox(height: 10),                
                Text(
                  text,
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: 22,
                        color: Colors.blueGrey[400],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
