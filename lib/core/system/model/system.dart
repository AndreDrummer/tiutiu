import 'package:cloud_firestore/cloud_firestore.dart';

enum SystemEnum {
  userChoiceRadiusDistanceToShowPets,
  systemStateTextFeedback,
  accessLocationDenied,
  internetConnected,
  userChoiceCountry,
  hasAcceptedTerms,
  runningVersion,
  snackBarIsOpen,
  isLoading,
}

class System {
  factory System.fromMap(Map<String, dynamic> map) {
    return System(
      userChoiceRadiusDistanceToShowPets: map[SystemEnum.userChoiceRadiusDistanceToShowPets.name],
      systemStateTextFeedback: map[SystemEnum.systemStateTextFeedback.name],
      accessLocationDenied: map[SystemEnum.accessLocationDenied.name],
      internetConnected: map[SystemEnum.internetConnected.name],
      userChoiceCountry: map[SystemEnum.userChoiceCountry.name],
      runningVersion: map[SystemEnum.runningVersion.name],
      snackBarIsOpen: map[SystemEnum.snackBarIsOpen.name],
      isLoading: map[SystemEnum.isLoading.name],
    );
  }

  System({
    this.userChoiceRadiusDistanceToShowPets = 10,
    this.systemStateTextFeedback = '',
    this.accessLocationDenied = false,
    this.internetConnected = false,
    this.hasAcceptedTerms = false,
    this.snackBarIsOpen = false,
    this.userChoiceCountry = '',
    this.runningVersion = '',
    this.isLoading = false,
  });

  System fromSnapshot(DocumentSnapshot snapshot) {
    return System(
      userChoiceRadiusDistanceToShowPets: this.userChoiceRadiusDistanceToShowPets,
      systemStateTextFeedback: this.systemStateTextFeedback,
      accessLocationDenied: this.accessLocationDenied,
      internetConnected: this.internetConnected,
      userChoiceCountry: this.userChoiceCountry,
      hasAcceptedTerms: this.hasAcceptedTerms,
      snackBarIsOpen: this.snackBarIsOpen,
      runningVersion: this.runningVersion,
      isLoading: this.isLoading,
    );
  }

  final double userChoiceRadiusDistanceToShowPets;
  final String systemStateTextFeedback;
  final bool accessLocationDenied;
  final String? userChoiceCountry;
  final bool internetConnected;
  final String runningVersion;
  final bool hasAcceptedTerms;
  final bool snackBarIsOpen;
  final bool isLoading;

  System copyWith({
    double? userChoiceRadiusDistanceToShowPets,
    String? systemStateTextFeedback,
    bool? accessLocationDenied,
    String? userChoiceCountry,
    bool? internetConnected,
    String? runningVersion,
    bool? hasAcceptedTerms,
    bool? snackBarIsOpen,
    bool? isLoading,
  }) {
    return System(
      userChoiceRadiusDistanceToShowPets: userChoiceRadiusDistanceToShowPets ?? this.userChoiceRadiusDistanceToShowPets,
      systemStateTextFeedback: systemStateTextFeedback ?? this.systemStateTextFeedback,
      accessLocationDenied: accessLocationDenied ?? this.accessLocationDenied,
      internetConnected: internetConnected ?? this.internetConnected,
      userChoiceCountry: userChoiceCountry ?? this.userChoiceCountry,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      snackBarIsOpen: snackBarIsOpen ?? this.snackBarIsOpen,
      runningVersion: runningVersion ?? this.runningVersion,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SystemEnum.userChoiceRadiusDistanceToShowPets.name: userChoiceRadiusDistanceToShowPets,
      SystemEnum.systemStateTextFeedback.name: systemStateTextFeedback,
      SystemEnum.accessLocationDenied.name: accessLocationDenied,
      SystemEnum.userChoiceCountry.name: userChoiceCountry,
      SystemEnum.internetConnected.name: internetConnected,
      SystemEnum.hasAcceptedTerms.name: hasAcceptedTerms,
      SystemEnum.runningVersion.name: runningVersion,
      SystemEnum.snackBarIsOpen.name: snackBarIsOpen,
      SystemEnum.isLoading.name: isLoading,
    };
  }

  @override
  String toString() {
    return '''System(      
      userChoiceRadiusDistanceToShowPets: $userChoiceRadiusDistanceToShowPets,
      systemStateTextFeedback: $systemStateTextFeedback,
      accessLocationDenied: $accessLocationDenied,  
      internetConnected: $internetConnected,
      userChoiceCountry: $userChoiceCountry,  
      hasAcceptedTerms: $hasAcceptedTerms,      
      runningVersion: $runningVersion,
      snackBarIsOpen: $snackBarIsOpen,  
      isLoading: $isLoading
    )''';
  }
}
