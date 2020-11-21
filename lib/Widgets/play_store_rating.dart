import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiutiu/utils/launcher_functions.dart';

class RatingUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Launcher.openBrowser(url: 'https://cutt.ly/4gIMH8V');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 38,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/icone.png'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      height: 38,
                      child: Image.asset('assets/playstore.png'),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Clique aqui e avalie-nos na PlayStore.',
                      style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
