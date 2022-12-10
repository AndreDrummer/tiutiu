import 'package:cloud_firestore/cloud_firestore.dart';

enum AppPropertiesEnum {
  isShowingDeveloperWarning,
  systemStateTextFeedback,
  mostUpdatedVersion,
  internetConnected,
  bottomSheetIsOpen,
  previousVersion,
  snackBarIsOpen,
  appBirthday,
  appAdminID,
  isLoading,
  allowPost,
}

class AppProperties {
  factory AppProperties.fromMap(Map<String, dynamic> map) {
    return AppProperties(
      isShowingDeveloperWarning: map[AppPropertiesEnum.isShowingDeveloperWarning.name],
      systemStateTextFeedback: map[AppPropertiesEnum.systemStateTextFeedback.name],
      mostUpdatedVersion: map[AppPropertiesEnum.mostUpdatedVersion.name],
      internetConnected: map[AppPropertiesEnum.internetConnected.name],
      bottomSheetIsOpen: map[AppPropertiesEnum.bottomSheetIsOpen.name],
      previousVersion: map[AppPropertiesEnum.previousVersion.name],
      snackBarIsOpen: map[AppPropertiesEnum.snackBarIsOpen.name],
      appBirthday: map[AppPropertiesEnum.appBirthday.name],
      appAdminID: map[AppPropertiesEnum.appAdminID.name],
      allowPost: map[AppPropertiesEnum.allowPost.name],
      isLoading: map[AppPropertiesEnum.isLoading.name],
    );
  }

  AppProperties({
    this.appBirthday = '2020-10-28T18:54:56.905834',
    this.isShowingDeveloperWarning = false,
    this.systemStateTextFeedback = '',
    this.internetConnected = false,
    this.bottomSheetIsOpen = false,
    this.mostUpdatedVersion = '',
    this.previousVersion = '',
    this.snackBarIsOpen = false,
    this.allowPost = false,
    this.isLoading = false,
    this.appAdminID = '',
  });

  AppProperties fromSnapshot(DocumentSnapshot snapshot) {
    return AppProperties(
      isShowingDeveloperWarning: snapshot.get(AppPropertiesEnum.isShowingDeveloperWarning.name),
      mostUpdatedVersion: snapshot.get(AppPropertiesEnum.mostUpdatedVersion.name),
      previousVersion: snapshot.get(AppPropertiesEnum.previousVersion.name),
      appAdminID: snapshot.get(AppPropertiesEnum.appAdminID.name),
      allowPost: snapshot.get(AppPropertiesEnum.allowPost.name),
      systemStateTextFeedback: this.systemStateTextFeedback,
      internetConnected: this.internetConnected,
      bottomSheetIsOpen: this.bottomSheetIsOpen,
      snackBarIsOpen: this.snackBarIsOpen,
      appBirthday: this.appBirthday,
      isLoading: this.isLoading,
    );
  }

  final bool isShowingDeveloperWarning;
  final String systemStateTextFeedback;
  final String mostUpdatedVersion;
  final String previousVersion;
  final bool internetConnected;
  final bool bottomSheetIsOpen;
  final bool snackBarIsOpen;
  final String appBirthday;
  final String appAdminID;
  final bool allowPost;
  final bool isLoading;

  AppProperties copyWith({
    bool? isShowingDeveloperWarning,
    String? systemStateTextFeedback,
    String? mostUpdatedVersion,
    String? previousVersion,
    bool? internetConnected,
    bool? bottomSheetIsOpen,
    bool? snackBarIsOpen,
    String? appBirthday,
    String? appAdminID,
    bool? allowPost,
    bool? isLoading,
  }) {
    return AppProperties(
      isShowingDeveloperWarning: isShowingDeveloperWarning ?? this.isShowingDeveloperWarning,
      systemStateTextFeedback: systemStateTextFeedback ?? this.systemStateTextFeedback,
      mostUpdatedVersion: mostUpdatedVersion ?? this.mostUpdatedVersion,
      internetConnected: internetConnected ?? this.internetConnected,
      bottomSheetIsOpen: bottomSheetIsOpen ?? this.bottomSheetIsOpen,
      previousVersion: previousVersion ?? this.previousVersion,
      snackBarIsOpen: snackBarIsOpen ?? this.snackBarIsOpen,
      appBirthday: appBirthday ?? this.appBirthday,
      appAdminID: appAdminID ?? this.appAdminID,
      allowPost: allowPost ?? this.allowPost,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppPropertiesEnum.isShowingDeveloperWarning.name: isShowingDeveloperWarning,
      AppPropertiesEnum.systemStateTextFeedback.name: systemStateTextFeedback,
      AppPropertiesEnum.mostUpdatedVersion.name: mostUpdatedVersion,
      AppPropertiesEnum.mostUpdatedVersion.name: mostUpdatedVersion,
      AppPropertiesEnum.previousVersion.name: previousVersion,
      AppPropertiesEnum.internetConnected.name: internetConnected,
      AppPropertiesEnum.bottomSheetIsOpen.name: bottomSheetIsOpen,
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
      isShowingDeveloperWarning: $isShowingDeveloperWarning,
      systemStateTextFeedback: $systemStateTextFeedback,
      mostUpdatedVersion: $mostUpdatedVersion,      
      internetConnected: $internetConnected,
      bottomSheetIsOpen: $bottomSheetIsOpen,
      previousVersion: $previousVersion,
      snackBarIsOpen: $snackBarIsOpen,
      appBirthday: $appBirthday,
      appAdminID: $appAdminID,
      allowPost: $allowPost,
      isLoading: $isLoading
    )''';
  }
}
