import 'package:flutter/material.dart';

class MyAccountCard extends StatelessWidget {
  MyAccountCard({
    this.isToCenterText = false,
    this.isToExpand = false,
    this.textIcon = '',
    this.icone,
    this.onTap,
    this.text,
  });

  final bool? isToCenterText;
  final bool? isToExpand;
  final String? textIcon;
  final IconData? icone;
  final Function? onTap;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        width: isToExpand!
            ? MediaQuery.of(context).size.width - 10
            : MediaQuery.of(context).size.width * 0.485,
        child: Card(
          elevation: 6.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: isToCenterText!
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icone, color: Colors.grey, size: 22),
                    Container(
                      width: 100,
                      child: Text(
                        textIcon!,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontSize: 18,
                              color: Colors.blueGrey[400],
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  text!,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontSize: 18,
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
