import 'package:cloud_firestore/cloud_firestore.dart';

enum AdminRemoteConfigEnum {
  adminCommunicationIsDanger,
  appClosedMessageDescription,
  closeInVersionsSmallerThan,
  thereIsAdminCommunication,
  appClosedMessageTitle,
  adminLinkRedirectsTo,
  mostUpdatedVersion,
  adminCommunication,
  dynamicLinkPrefix,
  showSponsoredAds,
  appInstagramLink,
  appInstagramUser,
  enableDonateTile,
  allowAdOnOpening,
  tiutiuShopLink,
  appFacebookLink,
  appFacebookUser,
  appleStoreLink,
  allowGoogleAds,
  showShopButton,
  playStoreLink,
  appTikTokUser,
  appTikTokLink,
  appBirthday,
  appIsClosed,
  appStoreId,
  appAdminID,
  uriPrefix,
  allowPost,
}

class AdminRemoteConfig {
  factory AdminRemoteConfig.fromMap(Map<String, dynamic> map) {
    return AdminRemoteConfig(
      appClosedMessageDescription: map[AdminRemoteConfigEnum.appClosedMessageDescription.name],
      adminCommunicationIsDanger: map[AdminRemoteConfigEnum.adminCommunicationIsDanger.name],
      closeInVersionsSmallerThan: map[AdminRemoteConfigEnum.closeInVersionsSmallerThan.name],
      thereIsAdminCommunication: map[AdminRemoteConfigEnum.thereIsAdminCommunication.name],
      appClosedMessageTitle: map[AdminRemoteConfigEnum.appClosedMessageTitle.name],
      adminLinkRedirectsTo: map[AdminRemoteConfigEnum.adminLinkRedirectsTo.name],
      adminCommunication: map[AdminRemoteConfigEnum.adminCommunication.name],
      mostUpdatedVersion: map[AdminRemoteConfigEnum.mostUpdatedVersion.name],
      dynamicLinkPrefix: map[AdminRemoteConfigEnum.dynamicLinkPrefix.name],
      showSponsoredAds: map[AdminRemoteConfigEnum.showSponsoredAds.name],
      allowAdOnOpening: map[AdminRemoteConfigEnum.allowAdOnOpening.name],
      appInstagramUser: map[AdminRemoteConfigEnum.appInstagramUser.name],
      appInstagramLink: map[AdminRemoteConfigEnum.appInstagramLink.name],
      enableDonateTile: map[AdminRemoteConfigEnum.enableDonateTile.name],
      appFacebookUser: map[AdminRemoteConfigEnum.appFacebookUser.name],
      appFacebookLink: map[AdminRemoteConfigEnum.appFacebookLink.name],
      allowGoogleAds: map[AdminRemoteConfigEnum.allowGoogleAds.name],
      appleStoreLink: map[AdminRemoteConfigEnum.appleStoreLink.name],
      showShopButton: map[AdminRemoteConfigEnum.showShopButton.name],
      tiutiuShopLink: map[AdminRemoteConfigEnum.tiutiuShopLink.name],
      appTikTokUser: map[AdminRemoteConfigEnum.appTikTokUser.name],
      playStoreLink: map[AdminRemoteConfigEnum.playStoreLink.name],
      appTikTokLink: map[AdminRemoteConfigEnum.appTikTokLink.name],
      appBirthday: map[AdminRemoteConfigEnum.appBirthday.name],
      appIsClosed: map[AdminRemoteConfigEnum.appIsClosed.name],
      appAdminID: map[AdminRemoteConfigEnum.appAdminID.name],
      appStoreId: map[AdminRemoteConfigEnum.appStoreId.name],
      allowPost: map[AdminRemoteConfigEnum.allowPost.name],
      uriPrefix: map[AdminRemoteConfigEnum.uriPrefix.name],
    );
  }

  AdminRemoteConfig({
    this.appFacebookLink = 'https://www.facebook.com/profile.php?id=100087589894761',
    this.appInstagramLink = 'https://www.instagram.com/tiutiuapp/',
    this.tiutiuShopLink = 'https://tiutiu-shop.myshopify.com/',
    this.appTikTokLink = 'https://www.tiktok.com/@tiutiuapp',
    this.uriPrefix = 'https://tiutiu.page.link',
    this.closeInVersionsSmallerThan = '1.0.0',
    this.adminCommunicationIsDanger = false,
    this.thereIsAdminCommunication = false,
    this.appClosedMessageDescription = '',
    this.appInstagramUser = '@tiutiuapp',
    this.appTikTokUser = '@tiutiuapp',
    this.appFacebookUser = 'Tiutiu',
    this.appClosedMessageTitle = '',
    this.adminLinkRedirectsTo = '',
    this.adminCommunication = '',
    this.showSponsoredAds = false,
    this.mostUpdatedVersion = '',
    this.allowAdOnOpening = false,
    this.enableDonateTile = false,
    this.allowGoogleAds = true,
    this.showShopButton = true,
    this.dynamicLinkPrefix = '',
    this.playStoreLink = '',
    this.appIsClosed = false,
    this.appleStoreLink = '',
    this.allowPost = false,
    this.appBirthday = '',
    this.appStoreId = '',
    this.appAdminID = '',
  });

  AdminRemoteConfig fromSnapshot(DocumentSnapshot snapshot) {
    return AdminRemoteConfig(
      appFacebookLink: snapshot.get(AdminRemoteConfigEnum.appFacebookLink.name) ??
          'https://www.facebook.com/profile.php?id=100087589894761',
      appInstagramLink:
          snapshot.get(AdminRemoteConfigEnum.appInstagramLink.name) ?? 'https://www.instagram.com/tiutiuapp/',
      appTikTokLink: snapshot.get(AdminRemoteConfigEnum.appTikTokLink.name) ?? 'https://www.tiktok.com/@tiutiuapp',
      appClosedMessageDescription: snapshot.get(AdminRemoteConfigEnum.appClosedMessageDescription.name),
      closeInVersionsSmallerThan: snapshot.get(AdminRemoteConfigEnum.closeInVersionsSmallerThan.name),
      adminCommunicationIsDanger: snapshot.get(AdminRemoteConfigEnum.adminCommunicationIsDanger.name),
      thereIsAdminCommunication: snapshot.get(AdminRemoteConfigEnum.thereIsAdminCommunication.name),
      appInstagramUser: snapshot.get(AdminRemoteConfigEnum.appInstagramUser.name) ?? '@tiutiuapp',
      appFacebookUser: snapshot.get(AdminRemoteConfigEnum.appFacebookUser.name) ?? 'Tiutiu',
      appTikTokUser: snapshot.get(AdminRemoteConfigEnum.appTikTokUser.name) ?? '@tiutiuapp',
      appClosedMessageTitle: snapshot.get(AdminRemoteConfigEnum.appClosedMessageTitle.name),
      adminLinkRedirectsTo: snapshot.get(AdminRemoteConfigEnum.adminLinkRedirectsTo.name),
      showShopButton: snapshot.get(AdminRemoteConfigEnum.showShopButton.name) ?? true,
      adminCommunication: snapshot.get(AdminRemoteConfigEnum.adminCommunication.name),
      mostUpdatedVersion: snapshot.get(AdminRemoteConfigEnum.mostUpdatedVersion.name),
      dynamicLinkPrefix: snapshot.get(AdminRemoteConfigEnum.dynamicLinkPrefix.name),
      showSponsoredAds: snapshot.get(AdminRemoteConfigEnum.showSponsoredAds.name),
      enableDonateTile: snapshot.get(AdminRemoteConfigEnum.enableDonateTile.name),
      allowAdOnOpening: snapshot.get(AdminRemoteConfigEnum.allowAdOnOpening.name),
      appleStoreLink: snapshot.get(AdminRemoteConfigEnum.appleStoreLink.name),
      allowGoogleAds: snapshot.get(AdminRemoteConfigEnum.allowGoogleAds.name),
      tiutiuShopLink: snapshot.get(AdminRemoteConfigEnum.tiutiuShopLink.name),
      playStoreLink: snapshot.get(AdminRemoteConfigEnum.playStoreLink.name),
      appIsClosed: snapshot.get(AdminRemoteConfigEnum.appIsClosed.name),
      appBirthday: snapshot.get(AdminRemoteConfigEnum.appBirthday.name),
      appAdminID: snapshot.get(AdminRemoteConfigEnum.appAdminID.name),
      appStoreId: snapshot.get(AdminRemoteConfigEnum.appStoreId.name),
      allowPost: snapshot.get(AdminRemoteConfigEnum.allowPost.name),
      uriPrefix: snapshot.get(AdminRemoteConfigEnum.uriPrefix.name),
    );
  }

  final String appClosedMessageDescription;
  final String closeInVersionsSmallerThan;
  final bool adminCommunicationIsDanger;
  final bool thereIsAdminCommunication;
  final String appClosedMessageTitle;
  final String adminLinkRedirectsTo;
  final String adminCommunication;
  final String mostUpdatedVersion;
  final String dynamicLinkPrefix;
  final String appInstagramUser;
  final String appInstagramLink;
  final String appFacebookLink;
  final String appFacebookUser;
  final String appleStoreLink;
  final bool allowAdOnOpening;
  final bool enableDonateTile;
  final bool showSponsoredAds;
  final String tiutiuShopLink;
  final String playStoreLink;
  final String appTikTokUser;
  final String appTikTokLink;
  final bool allowGoogleAds;
  final bool showShopButton;
  final String appBirthday;
  final bool appIsClosed;
  final String appAdminID;
  final String appStoreId;
  final String uriPrefix;
  final bool allowPost;

  AdminRemoteConfig copyWith({
    String? appClosedMessageDescription,
    String? closeInVersionsSmallerThan,
    bool? adminCommunicationIsDanger,
    bool? thereIsAdminCommunication,
    String? appClosedMessageTitle,
    String? adminLinkRedirectsTo,
    String? adminCommunication,
    String? mostUpdatedVersion,
    String? dynamicLinkPrefix,
    String? appInstagramLink,
    String? appInstagramUser,
    String? appFacebookLink,
    String? appFacebookUser,
    String? appTikTokLink,
    String? appTikTokUser,
    String? appleStoreLink,
    bool? showSponsoredAds,
    bool? enableDonateTile,
    bool? allowAdOnOpening,
    String? tiutiuShopLink,
    String? playStoreLink,
    bool? allowGoogleAds,
    String? appBirthday,
    String? appAdminID,
    bool? appIsClosed,
    bool? showShopButton,
    String? appStoreId,
    String? uriPrefix,
    bool? allowPost,
  }) {
    return AdminRemoteConfig(
      appClosedMessageDescription: appClosedMessageDescription ?? this.appClosedMessageDescription,
      adminCommunicationIsDanger: adminCommunicationIsDanger ?? this.adminCommunicationIsDanger,
      closeInVersionsSmallerThan: closeInVersionsSmallerThan ?? this.closeInVersionsSmallerThan,
      thereIsAdminCommunication: thereIsAdminCommunication ?? this.thereIsAdminCommunication,
      appClosedMessageTitle: appClosedMessageTitle ?? this.appClosedMessageTitle,
      adminLinkRedirectsTo: adminLinkRedirectsTo ?? this.adminLinkRedirectsTo,
      adminCommunication: adminCommunication ?? this.adminCommunication,
      mostUpdatedVersion: mostUpdatedVersion ?? this.mostUpdatedVersion,
      dynamicLinkPrefix: dynamicLinkPrefix ?? this.dynamicLinkPrefix,
      appInstagramUser: appInstagramUser ?? this.appInstagramUser,
      appInstagramLink: appInstagramLink ?? this.appInstagramLink,
      showSponsoredAds: showSponsoredAds ?? this.showSponsoredAds,
      allowAdOnOpening: allowAdOnOpening ?? this.allowAdOnOpening,
      enableDonateTile: enableDonateTile ?? this.enableDonateTile,
      appFacebookUser: appFacebookUser ?? this.appFacebookUser,
      appFacebookLink: appFacebookLink ?? this.appFacebookLink,
      showShopButton: showShopButton ?? this.showShopButton,
      tiutiuShopLink: tiutiuShopLink ?? this.tiutiuShopLink,
      appleStoreLink: appleStoreLink ?? this.appleStoreLink,
      allowGoogleAds: allowGoogleAds ?? this.allowGoogleAds,
      playStoreLink: playStoreLink ?? this.playStoreLink,
      appTikTokLink: appTikTokLink ?? this.appTikTokLink,
      appTikTokUser: appTikTokUser ?? this.appTikTokUser,
      appIsClosed: appIsClosed ?? this.appIsClosed,
      appBirthday: appBirthday ?? this.appBirthday,
      appAdminID: appAdminID ?? this.appAdminID,
      appStoreId: appStoreId ?? this.appStoreId,
      uriPrefix: uriPrefix ?? this.uriPrefix,
      allowPost: allowPost ?? this.allowPost,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AdminRemoteConfigEnum.appClosedMessageDescription.name: appClosedMessageDescription,
      AdminRemoteConfigEnum.closeInVersionsSmallerThan.name: closeInVersionsSmallerThan,
      AdminRemoteConfigEnum.adminCommunicationIsDanger.name: adminCommunicationIsDanger,
      AdminRemoteConfigEnum.thereIsAdminCommunication.name: thereIsAdminCommunication,
      AdminRemoteConfigEnum.appClosedMessageTitle.name: appClosedMessageTitle,
      AdminRemoteConfigEnum.adminLinkRedirectsTo.name: adminLinkRedirectsTo,
      AdminRemoteConfigEnum.adminCommunication.name: adminCommunication,
      AdminRemoteConfigEnum.mostUpdatedVersion.name: mostUpdatedVersion,
      AdminRemoteConfigEnum.dynamicLinkPrefix.name: dynamicLinkPrefix,
      AdminRemoteConfigEnum.appInstagramUser.name: appInstagramUser,
      AdminRemoteConfigEnum.appInstagramLink.name: appInstagramLink,
      AdminRemoteConfigEnum.showSponsoredAds.name: showSponsoredAds,
      AdminRemoteConfigEnum.enableDonateTile.name: enableDonateTile,
      AdminRemoteConfigEnum.allowAdOnOpening.name: allowAdOnOpening,
      AdminRemoteConfigEnum.appFacebookUser.name: appFacebookUser,
      AdminRemoteConfigEnum.appFacebookLink.name: appFacebookLink,
      AdminRemoteConfigEnum.tiutiuShopLink.name: tiutiuShopLink,
      AdminRemoteConfigEnum.allowGoogleAds.name: allowGoogleAds,
      AdminRemoteConfigEnum.showShopButton.name: showShopButton,
      AdminRemoteConfigEnum.appleStoreLink.name: appleStoreLink,
      AdminRemoteConfigEnum.playStoreLink.name: playStoreLink,
      AdminRemoteConfigEnum.appTikTokLink.name: appTikTokLink,
      AdminRemoteConfigEnum.appTikTokUser.name: appTikTokUser,
      AdminRemoteConfigEnum.appBirthday.name: appBirthday,
      AdminRemoteConfigEnum.appIsClosed.name: appIsClosed,
      AdminRemoteConfigEnum.appAdminID.name: appAdminID,
      AdminRemoteConfigEnum.appStoreId.name: appStoreId,
      AdminRemoteConfigEnum.uriPrefix.name: uriPrefix,
      AdminRemoteConfigEnum.allowPost.name: allowPost,
    };
  }

  @override
  String toString() {
    return '''AdminRemoteConfig(
      appClosedMessageDescription: $appClosedMessageDescription,
      closeInVersionsSmallerThan: $closeInVersionsSmallerThan,
      adminCommunicationIsDanger: $adminCommunicationIsDanger,
      thereIsAdminCommunication: $thereIsAdminCommunication,
      appClosedMessageTitle: $appClosedMessageTitle,
      adminLinkRedirectsTo: $adminLinkRedirectsTo,
      mostUpdatedVersion: $mostUpdatedVersion,
      adminCommunication: $adminCommunication,
      dynamicLinkPrefix: $dynamicLinkPrefix,      
      appInstagramLink: $appInstagramLink,
      appInstagramUser: $appInstagramUser,
      allowAdOnOpening: $allowAdOnOpening,
      showSponsoredAds: $showSponsoredAds,      
      enableDonateTile: $enableDonateTile,
      appFacebookLink: $appFacebookLink,      
      appFacebookUser: $appFacebookUser,      
      tiutiuShopLink: $tiutiuShopLink,      
      appleStoreLink: $appleStoreLink,            
      allowGoogleAds: $allowGoogleAds,
      showShopButton: $showShopButton,
      playStoreLink: $playStoreLink,      
      appTikTokLink: $appTikTokLink,      
      appTikTokUser: $appTikTokUser,      
      appIsClosed: $appIsClosed,
      appBirthday: $appBirthday,
      appStoreId: $appStoreId,
      appAdminID: $appAdminID,
      uriPrefix: $uriPrefix,
      allowPost: $allowPost,
    )''';
  }
}
