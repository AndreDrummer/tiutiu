import 'package:cloud_firestore/cloud_firestore.dart';

enum AppPropertiesEnum {
  thereIsDeveloperCommunication,
  developerLinkRedirection,
  systemStateTextFeedback,
  developerCommunication,
  mostUpdatedVersion,
  internetConnected,
  bottomSheetIsOpen,
  previousVersion,
  runningVersion,
  snackBarIsOpen,
  appBirthday,
  appAdminID,
  isLoading,
  allowPost,
}

class AppProperties {
  factory AppProperties.fromMap(Map<String, dynamic> map) {
    return AppProperties(
      thereIsDeveloperCommunication: map[AppPropertiesEnum.thereIsDeveloperCommunication.name],
      developerLinkRedirection: map[AppPropertiesEnum.developerLinkRedirection.name],
      systemStateTextFeedback: map[AppPropertiesEnum.systemStateTextFeedback.name],
      developerCommunication: map[AppPropertiesEnum.developerCommunication.name],
      mostUpdatedVersion: map[AppPropertiesEnum.mostUpdatedVersion.name],
      internetConnected: map[AppPropertiesEnum.internetConnected.name],
      bottomSheetIsOpen: map[AppPropertiesEnum.bottomSheetIsOpen.name],
      previousVersion: map[AppPropertiesEnum.previousVersion.name],
      runningVersion: map[AppPropertiesEnum.runningVersion.name],
      snackBarIsOpen: map[AppPropertiesEnum.snackBarIsOpen.name],
      appBirthday: map[AppPropertiesEnum.appBirthday.name],
      appAdminID: map[AppPropertiesEnum.appAdminID.name],
      allowPost: map[AppPropertiesEnum.allowPost.name],
      isLoading: map[AppPropertiesEnum.isLoading.name],
    );
  }

  AppProperties({
    this.appBirthday = '2020-10-28T18:54:56.905834',
    this.thereIsDeveloperCommunication = false,
    this.developerLinkRedirection = '',
    this.systemStateTextFeedback = '',
    this.developerCommunication = '',
    this.internetConnected = false,
    this.bottomSheetIsOpen = false,
    this.mostUpdatedVersion = '',
    this.snackBarIsOpen = false,
    this.previousVersion = '',
    this.runningVersion = '',
    this.allowPost = false,
    this.isLoading = false,
    this.appAdminID = '',
  });

  AppProperties fromSnapshot(DocumentSnapshot snapshot) {
    return AppProperties(
      thereIsDeveloperCommunication: snapshot.get(AppPropertiesEnum.thereIsDeveloperCommunication.name),
      developerLinkRedirection: snapshot.get(AppPropertiesEnum.developerLinkRedirection.name),
      developerCommunication: snapshot.get(AppPropertiesEnum.developerCommunication.name),
      mostUpdatedVersion: snapshot.get(AppPropertiesEnum.mostUpdatedVersion.name),
      previousVersion: snapshot.get(AppPropertiesEnum.previousVersion.name),
      appAdminID: snapshot.get(AppPropertiesEnum.appAdminID.name),
      allowPost: snapshot.get(AppPropertiesEnum.allowPost.name),
      systemStateTextFeedback: this.systemStateTextFeedback,
      internetConnected: this.internetConnected,
      bottomSheetIsOpen: this.bottomSheetIsOpen,
      runningVersion: this.runningVersion,
      snackBarIsOpen: this.snackBarIsOpen,
      appBirthday: this.appBirthday,
      isLoading: this.isLoading,
    );
  }

  final bool thereIsDeveloperCommunication;
  final String developerLinkRedirection;
  final String systemStateTextFeedback;
  final String developerCommunication;
  final String mostUpdatedVersion;
  final bool internetConnected;
  final bool bottomSheetIsOpen;
  final String previousVersion;
  final String runningVersion;
  final bool snackBarIsOpen;
  final String appBirthday;
  final String appAdminID;
  final bool allowPost;
  final bool isLoading;

  AppProperties copyWith({
    bool? thereIsDeveloperCommunication,
    String? developerLinkRedirection,
    String? systemStateTextFeedback,
    String? developerCommunication,
    String? mostUpdatedVersion,
    String? previousVersion,
    bool? internetConnected,
    bool? bottomSheetIsOpen,
    String? runningVersion,
    bool? snackBarIsOpen,
    String? appBirthday,
    String? appAdminID,
    bool? allowPost,
    bool? isLoading,
  }) {
    return AppProperties(
      thereIsDeveloperCommunication: thereIsDeveloperCommunication ?? this.thereIsDeveloperCommunication,
      developerLinkRedirection: developerLinkRedirection ?? this.developerLinkRedirection,
      systemStateTextFeedback: systemStateTextFeedback ?? this.systemStateTextFeedback,
      developerCommunication: developerCommunication ?? this.developerCommunication,
      mostUpdatedVersion: mostUpdatedVersion ?? this.mostUpdatedVersion,
      internetConnected: internetConnected ?? this.internetConnected,
      bottomSheetIsOpen: bottomSheetIsOpen ?? this.bottomSheetIsOpen,
      previousVersion: previousVersion ?? this.previousVersion,
      snackBarIsOpen: snackBarIsOpen ?? this.snackBarIsOpen,
      runningVersion: runningVersion ?? this.runningVersion,
      appBirthday: appBirthday ?? this.appBirthday,
      appAdminID: appAdminID ?? this.appAdminID,
      allowPost: allowPost ?? this.allowPost,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppPropertiesEnum.thereIsDeveloperCommunication.name: thereIsDeveloperCommunication,
      AppPropertiesEnum.developerLinkRedirection.name: developerLinkRedirection,
      AppPropertiesEnum.systemStateTextFeedback.name: systemStateTextFeedback,
      AppPropertiesEnum.developerCommunication.name: developerCommunication,
      AppPropertiesEnum.mostUpdatedVersion.name: mostUpdatedVersion,
      AppPropertiesEnum.mostUpdatedVersion.name: mostUpdatedVersion,
      AppPropertiesEnum.bottomSheetIsOpen.name: bottomSheetIsOpen,
      AppPropertiesEnum.internetConnected.name: internetConnected,
      AppPropertiesEnum.runningVersion.name: runningVersion,
      AppPropertiesEnum.snackBarIsOpen.name: snackBarIsOpen,
      AppPropertiesEnum.appBirthday.name: appBirthday,
      AppPropertiesEnum.appAdminID.name: appAdminID,
      AppPropertiesEnum.isLoading.name: isLoading,
      AppPropertiesEnum.allowPost.name: allowPost,
    };
  }

  @override
  String toString() {
    return '''AppProperties(
      thereIsDeveloperCommunication: $thereIsDeveloperCommunication,
      developerLinkRedirection: $developerLinkRedirection,
      systemStateTextFeedback: $systemStateTextFeedback,
      developerCommunication: $developerCommunication,
      mostUpdatedVersion: $mostUpdatedVersion,      
      internetConnected: $internetConnected,
      bottomSheetIsOpen: $bottomSheetIsOpen,
      previousVersion: $previousVersion,
      runningVersion: $runningVersion,
      snackBarIsOpen: $snackBarIsOpen,
      appBirthday: $appBirthday,
      appAdminID: $appAdminID,
      allowPost: $allowPost,
      isLoading: $isLoading
    )''';
  }
}
