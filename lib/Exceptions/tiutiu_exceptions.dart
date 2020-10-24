class TiuTiuException {
  TiuTiuException(this.keyException);
  final String keyException;

  Map<String, String> Errors = {
    'INVALID_PATH': ':Error: OPET pode ter sido excluído'
  };

  @override
  String toString() {
    if(Errors.containsKey(keyException)) {
      return Errors[keyException];
    } else {
      return 'Ocorreu um erro inesperado!';
    }
  }
}