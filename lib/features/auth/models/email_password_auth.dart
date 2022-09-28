import 'package:tiutiu/core/extensions/enum_tostring.dart';

enum EmailAndPasswordAuthEnum {
  repeatPassword,
  password,
  email,
}

class EmailAndPasswordAuth {
  factory EmailAndPasswordAuth.fromMap(Map<String, dynamic> map) {
    return EmailAndPasswordAuth(
        password: map[EmailAndPasswordAuthEnum.password.tostring()],
        email: map[EmailAndPasswordAuthEnum.email.tostring()],
        repeatPassword:
            map[EmailAndPasswordAuthEnum.repeatPassword.tostring()]);
  }
  EmailAndPasswordAuth({
    this.repeatPassword,
    this.password,
    this.email,
  });

  String? repeatPassword;
  String? password;
  String? email;

  EmailAndPasswordAuth copyWith({
    String? repeatPassword,
    String? password,
    String? email,
  }) {
    return EmailAndPasswordAuth(
      repeatPassword: repeatPassword ?? this.repeatPassword,
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      EmailAndPasswordAuthEnum.repeatPassword.tostring(): repeatPassword,
      EmailAndPasswordAuthEnum.password.tostring(): password,
      EmailAndPasswordAuthEnum.email.tostring(): email,
    };
  }
}
