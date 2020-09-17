class Formatter {
  static String unmaskNumber(String number) {
    try {
      String serializedNumber = number
        .split('(')[1]
        .replaceAll(')', '')
        .replaceAll('-', '')
        .replaceAll(' ', '');
        return serializedNumber;
    } catch (error) {
      throw error;      
    }    
  }
}
