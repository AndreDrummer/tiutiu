class TiuTiuAuthException {
  TiuTiuAuthException(this.keyException);
  final String keyException;

  Map<String, String> authErrors = {
    ErrorCodes.weakPassword:
        'Senha fraca. Escolha uma senha com no mínimo 6 dígitos.',
    ErrorCodes.emailAlreadyInUse:
        'Esse e-mail já se encontra em nossa base de dados. Tente fazer login.',
    ErrorCodes.operationNotAllowed: 'Ação não autorizada.',
    ErrorCodes.errorTooManyRequests:
        'Muitas tentativas em curto espaço de tempo. Tente novamente mais tarde.',
    ErrorCodes.tooManyRequests:
        'Muitas tentativas em curto espaço de tempo. Tente novamente mais tarde.',
    ErrorCodes.userDisabled: 'Usuário desativado!',
    ErrorCodes.invalidToken:
        'A sessão foi invalidada porque o usuário mudou sua senha ou o Facebook mudou a sessão por razões de segurança!',
    ErrorCodes.domainUnauthorized: 'Domínio não autorizado!',
    ErrorCodes.userNotFound: 'E-mail não encontrado!',
    ErrorCodes.wrongPassword: 'Senha Incorreta!',
    ErrorCodes.invalidEmail: 'E-mail Inválido!',
  };

  @override
  String toString() {
    if (authErrors.containsKey(keyException)) {
      return authErrors[keyException]!;
    } else {
      return 'Ocorreu um erro inesperado!';
    }
  }
}

class ErrorCodes {
  static String get weakPassword =>
      'ERROR_WEAK_PASSWORD : Password should be at least 6 characters';
  static String get operationNotAllowed => 'ERROR_OPERATION_NOT_ALLOWED';
  static String get errorTooManyRequests => 'ERROR_TOO_MANY_REQUESTS';
  static String get invalidToken => 'Error validating access token';
  static String get emailAlreadyInUse => 'email-already-in-use';
  static String get domainUnauthorized => 'unauthorized-domain';
  static String get tooManyRequests => 'too-many-requests';
  static String get userDisabled => 'ERROR_USER_DISABLED';
  static String get invalidEmail => 'ERROR_INVALID_EMAIL';
  static String get wrongPassword => 'wrong-password';
  static String get userNotFound => 'user-not-found';
}
