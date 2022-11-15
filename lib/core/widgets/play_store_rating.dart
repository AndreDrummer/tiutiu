import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class RatingUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 3.6,
      child: Column(
        children: [
          buttons(
            context: context,
            imagePath: ImageAssets.playstoreLogo,
            text: 'Avalie-nos na PlayStore.',
            urlToOpen: 'https://cutt.ly/4gIMH8V',
          ),
          buttons(
            context: context,
            imagePath: ImageAssets.instaLogo,
            text: 'IG: @tiutiuapp.',
            urlToOpen: 'https://www.instagram.com/tiutiuapp/',
          ),
          buttons(
            context: context,
            imagePath: ImageAssets.face,
            text: 'FB: Tiu, Tiu App - Gratuito.',
            urlToOpen: 'fb://page/113499407192787',
          ),
        ],
      ),
    );
  }

  Widget buttons({
    required BuildContext context,
    String? urlToOpen,
    String? imagePath,
    String? text,
  }) {
    return InkWell(
      onTap: () {
        Launcher.openBrowser(urlToOpen!);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Container(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    height: 38,
                    child: Image.asset(imagePath!),
                  ),
                  SizedBox(width: 10),
                  AutoSizeText(
                    text!,
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
