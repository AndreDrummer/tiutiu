class LocalStorageKey {
  static const String authData = 'authDataStored';
  static const String adsData = 'adsData';
}

extension KeyString on LocalStorageKey {
  String getString() {
    return this.toString().split('.').last;
  }
}
