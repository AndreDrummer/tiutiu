import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RatingUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 96.0.h,
      child: Column(
        children: [
          Divider(),
          buttons(
            context: context,
            imagePath: Platform.isAndroid ? ImageAssets.playstoreLogo : ImageAssets.applestoreLogo,
            urlToOpen: Platform.isAndroid ? 'https://cutt.ly/4gIMH8V' : 'https://cutt.ly/4gIMH8V',
            text: 'Avalie-nos na ${Platform.isAndroid ? 'PlayStore' : 'Apple Store'}.',
          ),
          buttons(
            urlToOpen: 'https://www.instagram.com/tiutiuapp/',
            imagePath: ImageAssets.instaLogo,
            text: 'IG: @tiutiuapp.',
            context: context,
          ),
          buttons(
            urlToOpen: 'https://www.facebook.com/profile.php?id=100087589894761',
            text: 'FB: Tiu, Tiu App - Gratuito.',
            imagePath: ImageAssets.face,
            context: context,
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
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 16.0.h,
                  child: Image.asset(imagePath!),
                ),
                SizedBox(width: 10),
                AutoSizeText(
                  text!,
                  style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
