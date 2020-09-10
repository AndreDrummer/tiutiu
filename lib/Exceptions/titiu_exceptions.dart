class TiuTiuAuthException {
  TiuTiuAuthException(this.keyException);
  final String keyException;

  Map<String, String> authErrors = {        
    'ERROR_WEAK_PASSWORD : Password should be at least 6 characters': 'Senha fraca. Escolha uma senha com no mínimo 6 dígitos.',    
    'ERROR_EMAIL_ALREADY_IN_USE': 'Esse e-mail já se encontra em nossa base de dados. Tente fazer login.',
    'ERROR_OPERATION_NOT_ALLOWED': 'Ação não autorizada.',
    'ERROR_TOO_MANY_REQUESTS': 'Muitas tentativas em curto espaço de tempo. Tente novamente mais tarde.',
    'too-many-requests': 'Muitas tentativas em curto espaço de tempo. Tente novamente mais tarde.',
    'ERROR_USER_DISABLED': 'Usuário desativado!',
    'ERROR_WRONG_PASSWORD': 'Senha Incorreta!',
    'wrong-password': 'Senha Incorreta!',
    'ERROR_INVALID_EMAIL': 'E-mail Inválido!',
    'ERROR_USER_NOT_FOUND': 'E-mail não encontrado!'
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