import 'package:cloud_firestore/cloud_firestore.dart';

enum AdminRemoteConfigEnum {
  adminCommunicationIsDanger,
  thereIsAdminCommunication,
  adminLinkRedirectsTo,
  mostUpdatedVersion,
  adminCommunication,
  showSponsoredAds,
  appBirthday,
  appAdminID,
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
      showSponsoredAds: map[AdminRemoteConfigEnum.showSponsoredAds.name],
      appBirthday: map[AdminRemoteConfigEnum.appBirthday.name],
      appAdminID: map[AdminRemoteConfigEnum.appAdminID.name],
      allowPost: map[AdminRemoteConfigEnum.allowPost.name],
    );
  }

  AdminRemoteConfig({
    this.adminCommunicationIsDanger = false,
    this.thereIsAdminCommunication = false,
    this.adminLinkRedirectsTo = '',
    this.adminCommunication = '',
    this.showSponsoredAds = false,
    this.mostUpdatedVersion = '',
    this.allowPost = false,
    this.appBirthday = '',
    this.appAdminID = '',
  });

  AdminRemoteConfig fromSnapshot(DocumentSnapshot snapshot) {
    return AdminRemoteConfig(
      adminCommunicationIsDanger: snapshot.get(AdminRemoteConfigEnum.adminCommunicationIsDanger.name),
      thereIsAdminCommunication: snapshot.get(AdminRemoteConfigEnum.thereIsAdminCommunication.name),
      adminLinkRedirectsTo: snapshot.get(AdminRemoteConfigEnum.adminLinkRedirectsTo.name),
      adminCommunication: snapshot.get(AdminRemoteConfigEnum.adminCommunication.name),
      mostUpdatedVersion: snapshot.get(AdminRemoteConfigEnum.mostUpdatedVersion.name),
      showSponsoredAds: snapshot.get(AdminRemoteConfigEnum.showSponsoredAds.name),
      appBirthday: snapshot.get(AdminRemoteConfigEnum.appBirthday.name),
      appAdminID: snapshot.get(AdminRemoteConfigEnum.appAdminID.name),
      allowPost: snapshot.get(AdminRemoteConfigEnum.allowPost.name),
    );
  }

  final bool adminCommunicationIsDanger;
  final bool thereIsAdminCommunication;
  final String adminLinkRedirectsTo;
  final String adminCommunication;
  final String mostUpdatedVersion;
  final bool showSponsoredAds;
  final String appBirthday;
  final String appAdminID;
  final bool allowPost;

  AdminRemoteConfig copyWith({
    bool? adminCommunicationIsDanger,
    bool? thereIsAdminCommunication,
    String? adminLinkRedirectsTo,
    String? adminCommunication,
    String? mostUpdatedVersion,
    bool? showSponsoredAds,
    String? appBirthday,
    String? appAdminID,
    bool? allowPost,
  }) {
    return AdminRemoteConfig(
      adminCommunicationIsDanger: adminCommunicationIsDanger ?? this.adminCommunicationIsDanger,
      thereIsAdminCommunication: thereIsAdminCommunication ?? this.thereIsAdminCommunication,
      adminLinkRedirectsTo: adminLinkRedirectsTo ?? this.adminLinkRedirectsTo,
      adminCommunication: adminCommunication ?? this.adminCommunication,
      mostUpdatedVersion: mostUpdatedVersion ?? this.mostUpdatedVersion,
      showSponsoredAds: showSponsoredAds ?? this.showSponsoredAds,
      appBirthday: appBirthday ?? this.appBirthday,
      appAdminID: appAdminID ?? this.appAdminID,
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
      AdminRemoteConfigEnum.mostUpdatedVersion.name: mostUpdatedVersion,
      AdminRemoteConfigEnum.showSponsoredAds.name: showSponsoredAds,
      AdminRemoteConfigEnum.appBirthday.name: appBirthday,
      AdminRemoteConfigEnum.appAdminID.name: appAdminID,
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
      showSponsoredAds: $showSponsoredAds,      
      appBirthday: $appBirthday,
      appAdminID: $appAdminID,
      allowPost: $allowPost,
    )''';
  }
}
