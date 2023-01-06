import 'dart:io';

class AdMobType {
  static const String interstitial = 'interstitial';
  static const String rewarded = 'rewarded';
  static const String banner = 'banner';
}

class AdMobBlockName {
  static final isOS = Platform.isIOS;

  static final String whatsappQuoteAdBlockId =
      isOS ? _AdMobBlockNames.on_whatsapp_quote_expires_ios.name : _AdMobBlockNames.on_whatsapp_quote_expires.name;

  static final String chatQuoteAdBlockId =
      isOS ? _AdMobBlockNames.on_chat_quote_expires_ios.name : _AdMobBlockNames.on_chat_quote_expires.name;

  static final String homeFooterAdBlockId =
      isOS ? _AdMobBlockNames.home_footer_ios.name : _AdMobBlockNames.home_footer.name;

  static final String openingAdBlockId = isOS ? _AdMobBlockNames.opening_ios.name : _AdMobBlockNames.opening.name;

  static final String postDetailScreenAdBlockId =
      isOS ? _AdMobBlockNames.post_detail_screen_ios.name : _AdMobBlockNames.post_detail_screen.name;
}

enum _AdMobBlockNames {
  on_whatsapp_quote_expires,
  on_chat_quote_expires,
  post_detail_screen,
  home_footer,
  opening,

  on_whatsapp_quote_expires_ios,
  on_chat_quote_expires_ios,
  post_detail_screen_ios,
  home_footer_ios,
  opening_ios,
}
