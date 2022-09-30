enum EmailAndPasswordAuthEnum {
  repeatPassword,
  password,
  email,
}

class EmailAndPasswordAuth {
  factory EmailAndPasswordAuth.fromMap(Map<String, dynamic> map) {
    return EmailAndPasswordAuth(
        password: map[EmailAndPasswordAuthEnum.password.name],
        email: map[EmailAndPasswordAuthEnum.email.name],
        repeatPassword: map[EmailAndPasswordAuthEnum.repeatPassword.name]);
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
      EmailAndPasswordAuthEnum.repeatPassword.name: repeatPassword,
      EmailAndPasswordAuthEnum.password.name: password,
      EmailAndPasswordAuthEnum.email.name: email,
    };
  }
}
