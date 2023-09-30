import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';

class AppNameWidget extends StatelessWidget {
  const AppNameWidget({
    this.letterSpacing,
    this.fontWeight,
    this.fontSize,
    super.key,
  });

  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      AppLocalizations.of(context)!.appName,
      textAlign: TextAlign.center,
      style: GoogleFonts.miltonianTattoo(
        textStyle: TextStyle(
          fontWeight: fontWeight ?? FontWeight.bold,
          letterSpacing: letterSpacing ?? 12,
          fontSize: fontSize ?? 32.0,
        ),
      ),
      maxFontSize: 32,
    );
  }
}
