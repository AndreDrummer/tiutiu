import 'package:flutter/material.dart';

class MyAccountCard extends StatelessWidget {
  MyAccountCard({
    this.textIcon = '',
    this.icone,
    this.onTap,
    this.text,
    this.isToExpand = false,
    this.isToCenterText = false,
  });

  final String text;
  final String textIcon;
  final IconData icone;
  final Function onTap;
  final bool isToExpand;
  final bool isToCenterText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: isToExpand
            ? MediaQuery.of(context).size.width - 10
            : MediaQuery.of(context).size.width * 0.485,
        child: Card(
          elevation: 6.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: isToCenterText ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icone, color: Colors.grey, size: 30),                    
                    Container(
                      width: 100,
                      child: Text(
                        textIcon,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 20,
                              color: Colors.blueGrey[400],
                            ),
                      ),
                    ),
                  ],
                ),
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
