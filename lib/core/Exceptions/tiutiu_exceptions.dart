class TiuTiuException {
  TiuTiuException(this.keyException);
  final String keyException;
}

class TiuTiuAuthException extends TiuTiuException {
  TiuTiuAuthException(super.keyException);

  Map<String, String> authErrors = {
    ErrorCodes.invalidToken:
        'A sessão foi invalidada porque o usuário mudou sua senha ou o Facebook mudou a sessão por razões de segurança!',
    ErrorCodes.errorTooManyRequests: 'Muitas tentativas em curto espaço de tempo. Tente novamente mais tarde.',
    ErrorCodes.tooManyRequests: 'Muitas tentativas em curto espaço de tempo. Tente novamente mais tarde.',
    ErrorCodes.emailAlreadyInUse: 'Esse e-mail já se encontra em nossa base de dados. Tente fazer login.',
    ErrorCodes.weakPassword: 'Senha fraca. Escolha uma senha com no mínimo 6 dígitos.',
    ErrorCodes.accountExistsWithDifferentCredential:
        'Você já criou uma conta com este email. Tente fazer login com essa outra conta.',
    ErrorCodes.userNotFound: 'Nenhuma conta com esse acesso foi encontrada!',
    ErrorCodes.unavailable: 'Tipo de login indisponível no momento!',
    ErrorCodes.domainUnauthorized: 'Domínio não autorizado!',
    ErrorCodes.wrongPassword: 'Usuário ou senha incorreto!',
    ErrorCodes.operationNotAllowed: 'Ação não autorizada.',
    ErrorCodes.userDisabled: 'Usuário desativado!',
    ErrorCodes.invalidEmail: 'E-mail Inválido!',
  };

  @override
  String toString() {
    if (authErrors.containsKey(keyException)) {
      return authErrors[keyException]!;
    } else {
      return 'Ocorreu um erro inesperado!\nVerifique sua conexão com a internet.';
    }
  }
}

class ErrorCodes {
  static String get accountExistsWithDifferentCredential => 'account-exists-with-different-credential';
  static String get weakPassword => 'ERROR_WEAK_PASSWORD : Password should be at least 6 characters';
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
  static String get unavailable => 'unavailable';
}
