import 'package:cloud_firestore/cloud_firestore.dart';

enum AppPropertiesEnum {
  isShowingDeveloperWarning,
  systemStateTextFeedback,
  internetConnected,
  bottomSheetIsOpen,
  snackBarIsOpen,
  allowPost,
  isLoading,
}

class AppProperties {
  factory AppProperties.fromMap(Map<String, dynamic> map) {
    return AppProperties(
      isShowingDeveloperWarning: map[AppPropertiesEnum.isShowingDeveloperWarning.name],
      systemStateTextFeedback: map[AppPropertiesEnum.systemStateTextFeedback.name],
      internetConnected: map[AppPropertiesEnum.internetConnected.name],
      bottomSheetIsOpen: map[AppPropertiesEnum.bottomSheetIsOpen.name],
      snackBarIsOpen: map[AppPropertiesEnum.snackBarIsOpen.name],
      allowPost: map[AppPropertiesEnum.allowPost.name],
      isLoading: map[AppPropertiesEnum.isLoading.name],
    );
  }

  AppProperties({
    this.isShowingDeveloperWarning = false,
    this.systemStateTextFeedback = '',
    this.internetConnected = false,
    this.bottomSheetIsOpen = false,
    this.snackBarIsOpen = false,
    this.allowPost = false,
    this.isLoading = false,
  });

  AppProperties fromSnapshot(DocumentSnapshot snapshot) {
    return AppProperties(
      isShowingDeveloperWarning: snapshot.get(AppPropertiesEnum.isShowingDeveloperWarning.name),
      allowPost: snapshot.get(AppPropertiesEnum.allowPost.name),
      systemStateTextFeedback: this.systemStateTextFeedback,
      internetConnected: this.internetConnected,
      bottomSheetIsOpen: this.bottomSheetIsOpen,
      snackBarIsOpen: this.snackBarIsOpen,
      isLoading: this.isLoading,
    );
  }

  final bool isShowingDeveloperWarning;
  final String systemStateTextFeedback;
  final bool internetConnected;
  final bool bottomSheetIsOpen;
  final bool snackBarIsOpen;
  final bool allowPost;
  final bool isLoading;

  AppProperties copyWith({
    bool? isShowingDeveloperWarning,
    String? systemStateTextFeedback,
    bool? internetConnected,
    bool? bottomSheetIsOpen,
    bool? snackBarIsOpen,
    bool? allowPost,
    bool? isLoading,
  }) {
    return AppProperties(
      isShowingDeveloperWarning: isShowingDeveloperWarning ?? this.isShowingDeveloperWarning,
      systemStateTextFeedback: systemStateTextFeedback ?? this.systemStateTextFeedback,
      internetConnected: internetConnected ?? this.internetConnected,
      bottomSheetIsOpen: bottomSheetIsOpen ?? this.bottomSheetIsOpen,
      snackBarIsOpen: snackBarIsOpen ?? this.snackBarIsOpen,
      allowPost: allowPost ?? this.allowPost,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppPropertiesEnum.isShowingDeveloperWarning.name: isShowingDeveloperWarning,
      AppPropertiesEnum.systemStateTextFeedback.name: systemStateTextFeedback,
      AppPropertiesEnum.internetConnected.name: internetConnected,
      AppPropertiesEnum.bottomSheetIsOpen.name: bottomSheetIsOpen,
      AppPropertiesEnum.snackBarIsOpen.name: snackBarIsOpen,
      AppPropertiesEnum.isLoading.name: isLoading,
      AppPropertiesEnum.allowPost.name: allowPost,
    };
  }

  @override
  String toString() {
    return '''AppProperties(
      isShowingDeveloperWarning: $isShowingDeveloperWarning,
      systemStateTextFeedback: $systemStateTextFeedback,
      internetConnected: $internetConnected,
      bottomSheetIsOpen: $bottomSheetIsOpen,
      snackBarIsOpen: $snackBarIsOpen,
      allowPost: $allowPost,
      isLoading: $isLoading
    )''';
  }
}
