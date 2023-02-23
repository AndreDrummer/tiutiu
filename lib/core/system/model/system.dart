import 'package:cloud_firestore/cloud_firestore.dart';

enum SystemEnum {
  systemStateTextFeedback,
  accessLocationDenied,
  internetConnected,
  hasAcceptedTerms,
  runningVersion,
  snackBarIsOpen,
  isLoading,
}

class System {
  factory System.fromMap(Map<String, dynamic> map) {
    return System(
      systemStateTextFeedback: map[SystemEnum.systemStateTextFeedback.name],
      accessLocationDenied: map[SystemEnum.accessLocationDenied.name],
      internetConnected: map[SystemEnum.internetConnected.name],
      runningVersion: map[SystemEnum.runningVersion.name],
      snackBarIsOpen: map[SystemEnum.snackBarIsOpen.name],
      isLoading: map[SystemEnum.isLoading.name],
    );
  }

  System({
    this.systemStateTextFeedback = '',
    this.accessLocationDenied = false,
    this.internetConnected = false,
    this.hasAcceptedTerms = false,
    this.snackBarIsOpen = false,
    this.runningVersion = '',
    this.isLoading = false,
  });

  System fromSnapshot(DocumentSnapshot snapshot) {
    return System(
      systemStateTextFeedback: this.systemStateTextFeedback,
      accessLocationDenied: this.accessLocationDenied,
      internetConnected: this.internetConnected,
      hasAcceptedTerms: this.hasAcceptedTerms,
      snackBarIsOpen: this.snackBarIsOpen,
      runningVersion: this.runningVersion,
      isLoading: this.isLoading,
    );
  }

  final String systemStateTextFeedback;
  final bool accessLocationDenied;
  final bool internetConnected;
  final String runningVersion;
  final bool hasAcceptedTerms;
  final bool snackBarIsOpen;
  final bool isLoading;

  System copyWith({
    String? systemStateTextFeedback,
    bool? accessLocationDenied,
    bool? internetConnected,
    bool? hasAcceptedTerms,
    String? runningVersion,
    bool? snackBarIsOpen,
    bool? isLoading,
  }) {
    return System(
      systemStateTextFeedback: systemStateTextFeedback ?? this.systemStateTextFeedback,
      accessLocationDenied: accessLocationDenied ?? this.accessLocationDenied,
      internetConnected: internetConnected ?? this.internetConnected,
      hasAcceptedTerms: hasAcceptedTerms ?? this.hasAcceptedTerms,
      snackBarIsOpen: snackBarIsOpen ?? this.snackBarIsOpen,
      runningVersion: runningVersion ?? this.runningVersion,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SystemEnum.systemStateTextFeedback.name: systemStateTextFeedback,
      SystemEnum.accessLocationDenied.name: accessLocationDenied,
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
      systemStateTextFeedback: $systemStateTextFeedback,        
      accessLocationDenied: $accessLocationDenied,        
      internetConnected: $internetConnected,      
      hasAcceptedTerms: $hasAcceptedTerms,        
      runningVersion: $runningVersion,
      snackBarIsOpen: $snackBarIsOpen,      
      isLoading: $isLoading
    )''';
  }
}
