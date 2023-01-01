void main() {
  String texto = 'comeco 87 123456 fim ';

  print('Texto entrada $texto');

  print('Texto saida ${replacePhoneNumber(texto)}');
}

String replacePhoneNumber(String description) {
  String phoneNumber = description;

  phoneNumber = phoneNumber
      .split(phoneNumber.split(RegExp(r"[0-9]")).first)
      .last
      .split(phoneNumber.split(phoneNumber.split(RegExp(r"[0-9]")).first).last.split(RegExp(r"[0-9]")).last)
      .first;

  String stars = '';
  final starList = List.generate(phoneNumber.length, ((index) => '*'));
  starList.forEach((star) => stars += star);

  description = description.replaceAll(phoneNumber, stars);

  return description;
}
