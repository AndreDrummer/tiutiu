class AppStrings {
  static String get verifyFilters => 'Verifique seus filtros de busca.';
  static String get imagesWarning => 'Imagens meramente ilustrativas';
  static String get authError =>
      'Ocorreu um erro com sua autenticação.\nTente sair e entrar novamente.';
  static String get wannaLeave => 'Deseja realmente sair?';
  static String get noPetFound => 'Nenhum PET encontrado';
  static String get iamInterested => 'Estou interessado';
  static String get backToStart => 'Voltar ao início';
  static String get headline2 =>
      'Muitos Pets Lindos\nEstão Aguardando Por Você';
  static String get repeatPassword => 'Repita a senha';
  static String get genericError => 'Ocorreu um erro';
  static String get headline1 => 'Faça Um Novo Amigo';
  static String get takeApicture => 'Tirar uma foto';
  static String get recordVideo => 'Gravar um vídeo';
  static String get endApp => 'Encerrar aplicação';
  static String get openGallery => 'Abrir galeria';
  static String get loadingDots => 'Carregando...';
  static String get interesteds => 'interessados';
  static String get provideInfo => 'Informar';
  static String get views => 'visualizações';
  static String get favorites => 'Favoritos';
  static String get getStarted => 'Começar';
  static String get whatsapp => 'WhatsApp';
  static String get contines => 'Continuar';
  static String get infos => 'informações';
  static String get postedAt => 'Postado';
  static String get profile => 'Perfil';
  static String get cancel => 'Cancelar';
  static String get password => 'Senha';
  static String get adopte => 'Adotar';
  static String get find => 'Encontrar';
  static String get name => 'Tiu, tiu';
  static String get email => 'E-mail';
  static String get post => 'Postar';
  static String get back => 'Voltar';
  static String get save => 'Salvar';
  static String get leave => 'Sair';
  static String get chat => 'Chat';
  static String get yes => 'Sim';
  static String get no => 'Não';
  static String get ok => 'OK';
}

class AuthStrings {
  static const String typePasswordAgain = 'Digite a senha novamente';
  static String get authentique => 'Autentique-se para continuar.';
  static String get createNewAccount => 'Crie uma nova conta.';
  static const String passwordNotMatch = 'Senhas não conferem';
  static const String forgetMyPassword = 'Esqueci minha senha';
  static String get doNotHaveAnAccount => 'Não tem uma conta?';
  static String get continueAnon => 'Continuar anônimamente';
  static const String loginInProgress = 'Realizando Login';
  static String get enterAccount => 'Entrar na sua conta.';
  static String get authFailure => 'Falha na autenticação';
  static String get haveAnAccount => 'Já tem uma conta?';
  static const String authenticanting = 'Autênticando...';
  static const String registeringUser = 'Criando conta';
  static const String invalidEmail = 'E-mail inválido';
  static String get createAccount => 'Criar conta';
  static String get createYours => 'Crie a sua.';
  static String get facebook => 'Facebook';
  static const String passwordShouldBeAtLeast6 =
      'Senha deve ter no mínimo 6 dígitos';
  static String get google => 'Google';
  static String get enter => 'Entrar';
  static String get email => 'E-mail';
  static String get apple => 'Apple';
}

class ValidatorsStrings {
  static const String requiredField = 'Campo obrigatório';
}

class HomeStrings {
  static String get searchForName => 'Digite o nome de um PET...';
}

class BottomBarStrings {
  static String get favorites => 'Favoritos';
}

class FilterStrings {
  static String get orderedBy => 'ordenados por:  ';
  static String get disappeared => 'Desaparecido';
  static String get foundAt => 'encontrados em ';
  static String get petBreed => 'Raça do Pet';
  static String get petName => 'Nome do Pet';
  static String get distance => 'Distância';
  static String get exotic => 'Exótico';
  static String get dog => 'Cachorro';
  static String get bird => 'Pássaro';
  static String get date => 'Data';
  static String get age => 'Idade';
  static String get type => 'Tipo';
  static String get name => 'Nome';
  static String get all => 'Todos';
  static String get cat => 'Gato';
}

class LocalPermissionStrings {
  static String get needsAccess =>
      'precisa ter acesso total a sua localização para funcionar corretamente!';
  static String get appBarTitle => 'Permissão para acessar sua localização';
  static String get turnOnLocalization => 'ATIVAR LOCALIZAÇÃO';
  static String get openSettings => 'IR P/ CONFIGURAÇÕES';
  static String get grantAcess => 'CONCEDER ACESSO';
}

class UserStrings {
  static String get allowContactViaWhatsApp => 'Permitir contato via WhatsApp';
  static String postsQty(int qty) => qty == 1 ? 'post' : 'posts';
  static String get userLastSeen => 'Visto por útlimo';
  static String get userSince => 'Usuário desde';
  static String get contact => 'Contato';
}

class PetDetailsString {
  static String get otherCaracteristics => 'Características';
  static String get lastSeen => 'Visto pela última vez em';
  static String get whereIsPet => 'Onde está o PET?';
  static String get announcer => 'Anunciante';
  static String get detailsOf => 'Detalhes de';
  static String get description => 'Descrição';
  static String get health => 'Saúde';
  static String get size => 'Tamanho';
  static String get female => 'Fêmea';
  static String get male => 'Macho';
  static String get breed => 'Raça';
  static String get age => 'Idade';
  static String get color => 'Cor';
  static String get type => 'Tipo';
  static String get sex => 'Sexo';
}

class MyProfileStrings {
  static const String allowContactViaWhatsApp = 'Permitir contato via WhatsApp';
  static const String howCallYou = 'Como gostaria de ser chamado?';
  static const String completeProfile = 'Completar perfil';
  static const String updatingProfile = 'Atualizando perfil';
  static const String deleteAccount = 'Apagar minha conta';
  static const String whatsapp = 'Seu número de WhatsApp';
  static const String insertAPicture = 'Insira uma foto';
  static const String editProfile = 'Editar perfil';
  static const String myAds = 'Meus anúncios';
  static const String ads = 'Anúncios';
}

class MyProfileOptionsTile {
  static const String settings = 'Configurações';
  static const String favorites = 'Favoritos';
  static const String myPosts = 'Meus Posts';
  static const String chat = 'Chat Online';
  static const String leave = 'Sair';
}

class PostFlowStrings {
  static const String fillFullAddress = 'Preencher endereço completo?';
  static const String fillAdData = 'Preencher dados do anúncio';
  static const String insertPictures = 'Insira as fotos';
  static const String typeAddress = 'Digite o endereço';
  static const String whereIsPet = 'Onde está o PET?';
  static const String petsData = 'Dados do PET';
  static const String pictures = 'Fotos';
  static const String state = 'Estado';
  static const String months = 'Meses';
  static const String local = 'Local';
  static const String city = 'Cidade';
  static const String years = 'Anos';
  static const String data = 'Dados';
  static const String name = 'Nome';
}
