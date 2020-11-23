import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiutiu/utils/launcher_functions.dart';

class RatingUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 3.7,
      child: Column(
        children: [
          buttons(context: context, imagePath: 'assets/playstore.png', text: 'Avalie-nos na PlayStore.', urlToOpen: 'https://cutt.ly/4gIMH8V'),
          buttons(
            context: context,
            imagePath: 'assets/insta.png',
            text: 'IG: @tiutiuapp.',
            urlToOpen: 'https://www.instagram.com/tiutiuapp/',
          ),
          buttons(
            context: context,
            imagePath: 'assets/face.png',
            text: 'FB: Tiu, Tiu App - Gratuito.',
            urlToOpen: 'fb://page/113499407192787',
          ),
        ],
      ),
    );
  }

  Widget buttons({BuildContext context, String text, String imagePath, String urlToOpen}) {
    return InkWell(
      onTap: () {
        Launcher.openBrowser(url: urlToOpen);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Container(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 38,
                    child: Image.asset(imagePath),
                  ),
                  SizedBox(width: 10),
                  Text(
                    text,
                    style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
