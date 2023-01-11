import 'package:cloud_firestore/cloud_firestore.dart';

enum AdminRemoteConfigEnum {
  adminCommunicationIsDanger,
  thereIsAdminCommunication,
  adminLinkRedirectsTo,
  mostUpdatedVersion,
  adminCommunication,
  dynamicLinkPrefix,
  showSponsoredAds,
  appInstagramLink,
  appFacebookLink,
  appleStoreLink,
  allowGoogleAds,
  playStoreLink,
  appBirthday,
  appAdminID,
  appStoreId,
  uriPrefix,
  allowPost,
}

class AdminRemoteConfig {
  factory AdminRemoteConfig.fromMap(Map<String, dynamic> map) {
    return AdminRemoteConfig(
      adminCommunicationIsDanger: map[AdminRemoteConfigEnum.adminCommunicationIsDanger.name],
      thereIsAdminCommunication: map[AdminRemoteConfigEnum.thereIsAdminCommunication.name],
      adminLinkRedirectsTo: map[AdminRemoteConfigEnum.adminLinkRedirectsTo.name],
      adminCommunication: map[AdminRemoteConfigEnum.adminCommunication.name],
      mostUpdatedVersion: map[AdminRemoteConfigEnum.mostUpdatedVersion.name],
      dynamicLinkPrefix: map[AdminRemoteConfigEnum.dynamicLinkPrefix.name],
      showSponsoredAds: map[AdminRemoteConfigEnum.showSponsoredAds.name],
      appInstagramLink: map[AdminRemoteConfigEnum.appInstagramLink.name],
      appFacebookLink: map[AdminRemoteConfigEnum.appFacebookLink.name],
      allowGoogleAds: map[AdminRemoteConfigEnum.allowGoogleAds.name],
      appleStoreLink: map[AdminRemoteConfigEnum.appleStoreLink.name],
      playStoreLink: map[AdminRemoteConfigEnum.playStoreLink.name],
      appBirthday: map[AdminRemoteConfigEnum.appBirthday.name],
      appAdminID: map[AdminRemoteConfigEnum.appAdminID.name],
      appStoreId: map[AdminRemoteConfigEnum.appStoreId.name],
      allowPost: map[AdminRemoteConfigEnum.allowPost.name],
      uriPrefix: map[AdminRemoteConfigEnum.uriPrefix.name],
    );
  }

  AdminRemoteConfig({
    this.uriPrefix = 'https://tiutiu.page.link',
    this.adminCommunicationIsDanger = false,
    this.thereIsAdminCommunication = false,
    this.adminLinkRedirectsTo = '',
    this.adminCommunication = '',
    this.showSponsoredAds = false,
    this.mostUpdatedVersion = '',
    this.allowGoogleAds = true,
    this.appInstagramLink = '',
    this.dynamicLinkPrefix = '',
    this.appFacebookLink = '',
    this.playStoreLink = '',
    this.appleStoreLink = '',
    this.allowPost = false,
    this.appBirthday = '',
    this.appStoreId = '',
    this.appAdminID = '',
  });

  AdminRemoteConfig fromSnapshot(DocumentSnapshot snapshot) {
    return AdminRemoteConfig(
      adminCommunicationIsDanger: snapshot.get(AdminRemoteConfigEnum.adminCommunicationIsDanger.name),
      thereIsAdminCommunication: snapshot.get(AdminRemoteConfigEnum.thereIsAdminCommunication.name),
      adminLinkRedirectsTo: snapshot.get(AdminRemoteConfigEnum.adminLinkRedirectsTo.name),
      adminCommunication: snapshot.get(AdminRemoteConfigEnum.adminCommunication.name),
      mostUpdatedVersion: snapshot.get(AdminRemoteConfigEnum.mostUpdatedVersion.name),
      dynamicLinkPrefix: snapshot.get(AdminRemoteConfigEnum.dynamicLinkPrefix.name),
      showSponsoredAds: snapshot.get(AdminRemoteConfigEnum.showSponsoredAds.name),
      appInstagramLink: snapshot.get(AdminRemoteConfigEnum.appInstagramLink.name),
      appFacebookLink: snapshot.get(AdminRemoteConfigEnum.appFacebookLink.name),
      appleStoreLink: snapshot.get(AdminRemoteConfigEnum.appleStoreLink.name),
      allowGoogleAds: snapshot.get(AdminRemoteConfigEnum.allowGoogleAds.name),
      playStoreLink: snapshot.get(AdminRemoteConfigEnum.playStoreLink.name),
      appBirthday: snapshot.get(AdminRemoteConfigEnum.appBirthday.name),
      appAdminID: snapshot.get(AdminRemoteConfigEnum.appAdminID.name),
      appStoreId: snapshot.get(AdminRemoteConfigEnum.appStoreId.name),
      allowPost: snapshot.get(AdminRemoteConfigEnum.allowPost.name),
      uriPrefix: snapshot.get(AdminRemoteConfigEnum.uriPrefix.name),
    );
  }

  final bool adminCommunicationIsDanger;
  final bool thereIsAdminCommunication;
  final String adminLinkRedirectsTo;
  final String adminCommunication;
  final String mostUpdatedVersion;
  final String dynamicLinkPrefix;
  final String appInstagramLink;
  final String appFacebookLink;
  final String appleStoreLink;
  final bool showSponsoredAds;
  final String playStoreLink;
  final bool allowGoogleAds;
  final String appBirthday;
  final String appAdminID;
  final String appStoreId;
  final String uriPrefix;
  final bool allowPost;

  AdminRemoteConfig copyWith({
    bool? adminCommunicationIsDanger,
    bool? thereIsAdminCommunication,
    String? adminLinkRedirectsTo,
    String? adminCommunication,
    String? mostUpdatedVersion,
    String? appInstagramLink,
    String? dynamicLinkPrefix,
    String? appFacebookLink,
    String? appleStoreLink,
    bool? showSponsoredAds,
    String? playStoreLink,
    bool? allowGoogleAds,
    String? appBirthday,
    String? appAdminID,
    String? appStoreId,
    String? uriPrefix,
    bool? allowPost,
  }) {
    return AdminRemoteConfig(
      adminCommunicationIsDanger: adminCommunicationIsDanger ?? this.adminCommunicationIsDanger,
      thereIsAdminCommunication: thereIsAdminCommunication ?? this.thereIsAdminCommunication,
      adminLinkRedirectsTo: adminLinkRedirectsTo ?? this.adminLinkRedirectsTo,
      adminCommunication: adminCommunication ?? this.adminCommunication,
      mostUpdatedVersion: mostUpdatedVersion ?? this.mostUpdatedVersion,
      dynamicLinkPrefix: dynamicLinkPrefix ?? this.dynamicLinkPrefix,
      appInstagramLink: appInstagramLink ?? this.appInstagramLink,
      showSponsoredAds: showSponsoredAds ?? this.showSponsoredAds,
      appFacebookLink: appFacebookLink ?? this.appFacebookLink,
      appleStoreLink: appleStoreLink ?? this.appleStoreLink,
      allowGoogleAds: allowGoogleAds ?? this.allowGoogleAds,
      playStoreLink: playStoreLink ?? this.playStoreLink,
      appBirthday: appBirthday ?? this.appBirthday,
      appAdminID: appAdminID ?? this.appAdminID,
      appStoreId: appStoreId ?? this.appStoreId,
      uriPrefix: uriPrefix ?? this.uriPrefix,
      allowPost: allowPost ?? this.allowPost,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AdminRemoteConfigEnum.adminCommunicationIsDanger.name: adminCommunicationIsDanger,
      AdminRemoteConfigEnum.thereIsAdminCommunication.name: thereIsAdminCommunication,
      AdminRemoteConfigEnum.adminLinkRedirectsTo.name: adminLinkRedirectsTo,
      AdminRemoteConfigEnum.adminCommunication.name: adminCommunication,
      AdminRemoteConfigEnum.mostUpdatedVersion.name: mostUpdatedVersion,
      AdminRemoteConfigEnum.dynamicLinkPrefix.name: dynamicLinkPrefix,
      AdminRemoteConfigEnum.appInstagramLink.name: appInstagramLink,
      AdminRemoteConfigEnum.showSponsoredAds.name: showSponsoredAds,
      AdminRemoteConfigEnum.appFacebookLink.name: appFacebookLink,
      AdminRemoteConfigEnum.allowGoogleAds.name: allowGoogleAds,
      AdminRemoteConfigEnum.appleStoreLink.name: appleStoreLink,
      AdminRemoteConfigEnum.playStoreLink.name: playStoreLink,
      AdminRemoteConfigEnum.appBirthday.name: appBirthday,
      AdminRemoteConfigEnum.appAdminID.name: appAdminID,
      AdminRemoteConfigEnum.appStoreId.name: appStoreId,
      AdminRemoteConfigEnum.uriPrefix.name: uriPrefix,
      AdminRemoteConfigEnum.allowPost.name: allowPost,
    };
  }

  @override
  String toString() {
    return '''AdminRemoteConfig(
      adminCommunicationIsDanger: $adminCommunicationIsDanger,
      thereIsAdminCommunication: $thereIsAdminCommunication,
      adminLinkRedirectsTo: $adminLinkRedirectsTo,
      mostUpdatedVersion: $mostUpdatedVersion,
      adminCommunication: $adminCommunication,
      dynamicLinkPrefix: $dynamicLinkPrefix,      
      appInstagramLink: $appInstagramLink,
      showSponsoredAds: $showSponsoredAds,      
      appFacebookLink: $appFacebookLink,      
      appleStoreLink: $appleStoreLink,      
      allowGoogleAds: $allowGoogleAds,
      playStoreLink: $playStoreLink,      
      appBirthday: $appBirthday,
      appStoreId: $appStoreId,
      appAdminID: $appAdminID,
      uriPrefix: $uriPrefix,
      allowPost: $allowPost,
    )''';
  }
}
