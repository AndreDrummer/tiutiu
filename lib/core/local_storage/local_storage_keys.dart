class LocalStorageKey {
  static const String authData = 'authDataStored';
}

extension KeyString on LocalStorageKey {
  String getString() {
    return this.toString().split('.').last;
  }
}
