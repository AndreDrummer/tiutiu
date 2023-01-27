import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AutoSizeTexts {
  static AutoSizeText autoSizeText(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    required double fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText8(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize = 8,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 8).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText10(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    double? fontSize = 10,
    double? height,
    FontStyle? fontStyle,
    TextAlign? textAlign,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 10).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText12(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize = 12,
    double? height,
    TextAlign? textAlign,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 12).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText14(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize = 14,
    double? height,
    TextAlign? textAlign,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 14).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText16(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    double? fontSize = 16,
    double? height,
    FontStyle? fontStyle,
    TextAlign? textAlign,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 16).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText18(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize = 18,
    double? height,
    TextAlign? textAlign,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 18).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText20(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize = 20,
    double? height,
    TextAlign? textAlign,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 20).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText22(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize = 22,
    double? height,
    TextAlign? textAlign,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 22).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText24(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize = 24,
    double? height,
    TextAlign? textAlign,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 24).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText26(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize = 26,
    double? height,
    TextAlign? textAlign,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 26).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText28(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize = 28,
    double? height,
    TextAlign? textAlign,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 28).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }

  static AutoSizeText autoSizeText32(
    String? text, {
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize = 32,
    double? height,
    TextAlign? textAlign,
    int? maxLines,
    Color? color,
  }) {
    return AutoSizeText(
      maxFontSize: (fontSize ?? 32).toPrecision(0),
      overflow: textOverflow,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: 8,
      text ?? '',
      style: TextStyle(
        decoration: textDecoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        height: height,
        color: color,
      ),
    );
  }
}
