import 'package:cloud_firestore/cloud_firestore.dart';

enum SystemEnum {
  systemStateTextFeedback,
  accessLocationDenied,
  internetConnected,
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
    this.snackBarIsOpen = false,
    this.runningVersion = '',
    this.isLoading = false,
  });

  System fromSnapshot(DocumentSnapshot snapshot) {
    return System(
      systemStateTextFeedback: this.systemStateTextFeedback,
      accessLocationDenied: this.accessLocationDenied,
      internetConnected: this.internetConnected,
      runningVersion: this.runningVersion,
      snackBarIsOpen: this.snackBarIsOpen,
      isLoading: this.isLoading,
    );
  }

  final String systemStateTextFeedback;
  final bool accessLocationDenied;
  final bool internetConnected;
  final String runningVersion;
  final bool snackBarIsOpen;
  final bool isLoading;

  System copyWith({
    String? systemStateTextFeedback,
    bool? accessLocationDenied,
    bool? internetConnected,
    String? runningVersion,
    bool? snackBarIsOpen,
    bool? isLoading,
  }) {
    return System(
      systemStateTextFeedback: systemStateTextFeedback ?? this.systemStateTextFeedback,
      accessLocationDenied: accessLocationDenied ?? this.accessLocationDenied,
      internetConnected: internetConnected ?? this.internetConnected,
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
      runningVersion: $runningVersion,
      snackBarIsOpen: $snackBarIsOpen,      
      isLoading: $isLoading
    )''';
  }
}
