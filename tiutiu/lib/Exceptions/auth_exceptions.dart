class AuthException {
  AuthException(this.keyException);
  final String keyException;

  Map<String, String> authErrors = {
    'EMAIL_EXISTS': 'Esse e-mail já se encontra em nossa base de dados. Tente fazer login.',
    'OPERATION_NOT_ALLOWED': 'Ação não autorizada.',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Muitas tentativas em curto espaço de tempo. Tente novamente mais tarde.',
    'USER_DISABLED': 'Usuário desativado.',
    'TOKEN_EXPIRED': 'Sessão expirada. Autentique-se novamente.',
    'INVALID_PASSWORD': 'Senha Incorreta!',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado!'
  };

  @override
  String toString() {
    if(authErrors.containsKey(keyException)) {
      return authErrors[keyException];
    } else {
      return 'Ocorreu um erro inesperado!';
    }
  }
}