import 'package:cloud_firestore/cloud_firestore.dart';

enum SystemEnum {
  systemStateTextFeedback,
  bottomSheetIsOpen,
  internetConnected,
  runningVersion,
  snackBarIsOpen,
  isLoading,
}

class System {
  factory System.fromMap(Map<String, dynamic> map) {
    return System(
      systemStateTextFeedback: map[SystemEnum.systemStateTextFeedback.name],
      internetConnected: map[SystemEnum.internetConnected.name],
      bottomSheetIsOpen: map[SystemEnum.bottomSheetIsOpen.name],
      runningVersion: map[SystemEnum.runningVersion.name],
      snackBarIsOpen: map[SystemEnum.snackBarIsOpen.name],
      isLoading: map[SystemEnum.isLoading.name],
    );
  }

  System({
    this.systemStateTextFeedback = '',
    this.internetConnected = false,
    this.bottomSheetIsOpen = false,
    this.snackBarIsOpen = false,
    this.runningVersion = '',
    this.isLoading = false,
  });

  System fromSnapshot(DocumentSnapshot snapshot) {
    return System(
      systemStateTextFeedback: this.systemStateTextFeedback,
      internetConnected: this.internetConnected,
      bottomSheetIsOpen: this.bottomSheetIsOpen,
      runningVersion: this.runningVersion,
      snackBarIsOpen: this.snackBarIsOpen,
      isLoading: this.isLoading,
    );
  }

  final String systemStateTextFeedback;
  final bool internetConnected;
  final bool bottomSheetIsOpen;
  final String runningVersion;
  final bool snackBarIsOpen;
  final bool isLoading;

  System copyWith({
    String? systemStateTextFeedback,
    bool? internetConnected,
    bool? bottomSheetIsOpen,
    String? runningVersion,
    bool? snackBarIsOpen,
    bool? isLoading,
  }) {
    return System(
      systemStateTextFeedback: systemStateTextFeedback ?? this.systemStateTextFeedback,
      internetConnected: internetConnected ?? this.internetConnected,
      bottomSheetIsOpen: bottomSheetIsOpen ?? this.bottomSheetIsOpen,
      snackBarIsOpen: snackBarIsOpen ?? this.snackBarIsOpen,
      runningVersion: runningVersion ?? this.runningVersion,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SystemEnum.systemStateTextFeedback.name: systemStateTextFeedback,
      SystemEnum.bottomSheetIsOpen.name: bottomSheetIsOpen,
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
      internetConnected: $internetConnected,
      bottomSheetIsOpen: $bottomSheetIsOpen,      
      runningVersion: $runningVersion,
      snackBarIsOpen: $snackBarIsOpen,      
      isLoading: $isLoading
    )''';
  }
}
