import 'package:cloud_firestore/cloud_firestore.dart';

const String defaultCountry = 'brazil';

enum SystemEnum {
  userChoiceRadiusDistanceToShowPets,
  systemStateTextFeedback,
  userHasChosenCountry,
  accessLocationDenied,
  internetConnected,
  userCountryChoice,
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
      userHasChosenCountry: map[SystemEnum.userHasChosenCountry.name],
      accessLocationDenied: map[SystemEnum.accessLocationDenied.name],
      internetConnected: map[SystemEnum.internetConnected.name],
      userCountryChoice: map[SystemEnum.userCountryChoice.name],
      runningVersion: map[SystemEnum.runningVersion.name],
      snackBarIsOpen: map[SystemEnum.snackBarIsOpen.name],
      isLoading: map[SystemEnum.isLoading.name],
    );
  }

  System({
    this.userChoiceRadiusDistanceToShowPets = 10,
    this.userCountryChoice = defaultCountry,
    this.systemStateTextFeedback = '',
    this.accessLocationDenied = false,
    this.userHasChosenCountry = false,
    this.internetConnected = false,
    this.hasAcceptedTerms = false,
    this.snackBarIsOpen = false,
    this.runningVersion = '',
    this.isLoading = false,
  });

  System fromSnapshot(DocumentSnapshot snapshot) {
    return System(
      userChoiceRadiusDistanceToShowPets: this.userChoiceRadiusDistanceToShowPets,
      systemStateTextFeedback: this.systemStateTextFeedback,
      userHasChosenCountry: this.userHasChosenCountry,
      accessLocationDenied: this.accessLocationDenied,
      internetConnected: this.internetConnected,
      userCountryChoice: this.userCountryChoice,
      hasAcceptedTerms: this.hasAcceptedTerms,
      snackBarIsOpen: this.snackBarIsOpen,
      runningVersion: this.runningVersion,
      isLoading: this.isLoading,
    );
  }

  final double userChoiceRadiusDistanceToShowPets;
  final String systemStateTextFeedback;
  final bool accessLocationDenied;
  final bool userHasChosenCountry;
  final String? userCountryChoice;
  final bool internetConnected;
  final String runningVersion;
  final bool hasAcceptedTerms;
  final bool snackBarIsOpen;
  final bool isLoading;

  System copyWith({
    double? userChoiceRadiusDistanceToShowPets,
    String? systemStateTextFeedback,
    bool? accessLocationDenied,
    bool? userHasChosenCountry,
    String? userCountryChoice,
    bool? internetConnected,
    String? runningVersion,
    bool? hasAcceptedTerms,
    bool? snackBarIsOpen,
    bool? isLoading,
  }) {
    return System(
      userChoiceRadiusDistanceToShowPets: userChoiceRadiusDistanceToShowPets ?? this.userChoiceRadiusDistanceToShowPets,
      systemStateTextFeedback: systemStateTextFeedback ?? this.systemStateTextFeedback,
      userHasChosenCountry: userHasChosenCountry ?? this.userHasChosenCountry,
      accessLocationDenied: accessLocationDenied ?? this.accessLocationDenied,
      internetConnected: internetConnected ?? this.internetConnected,
      userCountryChoice: userCountryChoice ?? this.userCountryChoice,
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
      SystemEnum.userHasChosenCountry.name: userHasChosenCountry,
      SystemEnum.userCountryChoice.name: userCountryChoice,
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
      userHasChosenCountry: $userHasChosenCountry,
      accessLocationDenied: $accessLocationDenied,        
      internetConnected: $internetConnected,
      userCountryChoice: $userCountryChoice,  
      hasAcceptedTerms: $hasAcceptedTerms,      
      runningVersion: $runningVersion,
      snackBarIsOpen: $snackBarIsOpen,  
      isLoading: $isLoading
    )''';
  }
}
