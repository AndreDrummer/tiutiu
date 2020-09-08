import 'package:flutter/material.dart';

class CardDetails extends StatelessWidget {
  CardDetails({this.icon, this.title, this.text});

  final String title;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        // height: 75,
        width: 170,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 8.0),
              Opacity(
                opacity: 0.4,
                child: Icon(icon, color: Colors.green, size: 35),
              ),            
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          title.toUpperCase(),
                          style: TextStyle(
                            letterSpacing: 1.2,
                            // fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FittedBox(
                        child: Text(
                          text,
                          style: TextStyle(                        
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCardInfo extends StatelessWidget {
  UserCardInfo({
    this.imageN,
    this.image,
    this.text,
    this.title,
    this.icon,
    this.color
  });

  final String text;
  final String title;
  final String image;
  final String imageN;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        child: Column(
          children: [
              Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    title,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      // fontSize: 10,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 100,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                // borderRadius: BorderRadius.only(
                //   topRight: Radius.circular(12),
                //   topLeft: Radius.circular(12),
                // ),
                child: Container(
                  color: color,
                  child: icon != null
                    ? Icon(icon, color: Colors.white, size: 60)
                    : imageN != null
                        ? Image.network(
                            imageN,
                            fit: BoxFit.cover,
                            width: 105,
                          )
                        : Image.asset(
                            image,
                            fit: BoxFit.cover,
                            width: 105,
                          )
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    text,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      // fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
