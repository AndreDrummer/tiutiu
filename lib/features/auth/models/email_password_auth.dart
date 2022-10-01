import 'package:tiutiu/core/models/mapper.dart';

enum EmailAndPasswordAuthEnum {
  repeatPassword,
  password,
  email,
}

class EmailAndPasswordAuth implements Mapper {
  EmailAndPasswordAuth({
    this.repeatPassword,
    this.password,
    this.email,
  });

  @override
  EmailAndPasswordAuth fromMap(Map<String, dynamic> map) {
    return EmailAndPasswordAuth(
      repeatPassword: map[EmailAndPasswordAuthEnum.repeatPassword.name],
      password: map[EmailAndPasswordAuthEnum.password.name],
      email: map[EmailAndPasswordAuthEnum.email.name],
    );
  }

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

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      EmailAndPasswordAuthEnum.repeatPassword.name: repeatPassword,
      EmailAndPasswordAuthEnum.password.name: password,
      EmailAndPasswordAuthEnum.email.name: email,
    };
  }
}
