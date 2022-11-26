class AppStrings {
  static String get authError => 'Ocorreu um erro com sua autenticação.\nTente sair e entrar novamente.';
  static String get headline2 => 'Muitos Pets Lindos\nEstão Aguardando Por Você';
  static String get verifyEmailToSeeContactInfo =>
      'Verifique seu email para ver as informações de contato deste anúncio!';
  static String get doLoginWarning => 'Faça login para ter acesso a todas as funcionalidades.';
  static String get verifyAccountWarning =>
      'Sua conta ainda não foi verificada, por isso algumas funcionalidades ainda estão restritas!';
  static String get verifyFilters => 'Verifique seus filtros de busca.';
  static String get imagesWarning => 'Imagens meramente ilustrativas';
  static String get noPostFavorited => 'Nenhum PET foi favoritado.';
  static String get wannaLeave => 'Deseja realmente sair?';
  static String get loadingImage => 'Carregando imagem...';
  static String get noPostFound => 'Nenhum PET encontrado.';
  static String get jotSomethingDown => 'Escreva aqui...';
  static String get iamInterested => 'Estou interessado';
  static String get backToStart => 'Voltar ao início';
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
  static String get success => 'Sucesso!';
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
  static String get wait => 'Aguarde';
  static String get post => 'Postar';
  static String get back => 'Voltar';
  static String get send => 'Enviar';
  static String get save => 'Salvar';
  static String get leave => 'Sair';
  static String get type => 'Tipo';
  static String get chat => 'Chat';
  static String get yes => 'Sim';
  static String get no => 'Não';
  static String get ok => 'OK';
}

class AuthStrings {
  static const String deleteAccountWarning =
      'Após excluir sua conta não será possível recuperá-la.\n\nDeseja continuar?';
  static const String demandRecentLoginWarning = 'Está ação requer que você faça login novamente.\n\nDeseja deslogar?';
  static String passwordShouldBeAtLeast(String field, int length) => '$field deve ter no mínimo $length dígitos';
  static const String unableToResendEmail = 'Não foi possível reenviar o e-mail. Tente novamente mais tarde!';
  static const String verifyEmailAdvice =
      'Somente contas verificadas podem publicar um anúncio. Cheque sua caixa de spam se necessário.';
  static const String tryVerifyCodeAgain = 'Não foi possível verificar o código.\nTente novamente.';
  static const String insertCodeSentToNumber = 'Insira o código enviado para o número';
  static const String linkWasSent = 'Um link de verificação foi enviado para o email';
  static const String successfullyVerifiedCode = 'Código verificado com sucesso!';
  static const String doYouWannaPasteCodeCopied = 'Deseja colar o código copiado';
  static const String codeIsValidForMinutes = 'O código é valido por 2 minutos.';
  static const String typePasswordAgain = 'Digite a senha novamente';
  static String get authentique => 'Autentique-se para continuar.';
  static const String verifyYourNumber = 'Verifique seu número';
  static const String dontReceiveEmail = 'Não recebeu um email?';
  static const String verifyYourEmail = 'Verifique seu email';
  static String get createNewAccount => 'Crie uma nova conta.';
  static const String passwordNotMatch = 'Senhas não conferem';
  static const String forgetMyPassword = 'Esqueci minha senha';
  static String get doNotHaveAnAccount => 'Não tem uma conta?';
  static String get continueAnon => 'Continuar anônimamente';
  static const String numberVerified = 'Número verificado';
  static const String loginInProgress = 'Realizando Login';
  static String get enterAccount => 'Entrar na sua conta.';
  static String get authFailure => 'Falha na autenticação';
  static String get haveAnAccount => 'Já tem uma conta?';
  static const String authenticanting = 'Autênticando...';
  static const String deleteAccount = 'Excluir conta';
  static const String registeringUser = 'Criando conta';
  static const String invalidCode = 'Código inválido!';
  static const String invalidEmail = 'E-mail inválido';
  static const String emailSent = 'E-mail enviado!';
  static String get receiveCode => 'Receber código';
  static String get createAccount => 'Criar conta';
  static const String pasteCode = 'Colar código';
  static String get createYours => 'Crie a sua.';
  static const String doLogin = 'Faça login';
  static String get facebook => 'Facebook';
  static const String resend = 'Reenviar';
  static String get validate => 'Validar';
  static String get google => 'Google';
  static String get enter => 'Entrar';
  static String get email => 'E-mail';
  static String get apple => 'Apple';
}

class ValidatorsStrings {
  static const String invalidPhoneNumber = 'Número inválido';
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
  static String get disappeared => 'Desaparecidos';
  static String get foundAt => 'encontrados em ';
  static String get petBreed => 'Raça do Pet';
  static String get petName => 'Nome do Pet';
  static String get distance => 'Distância';
  static String get ads => 'anúncios';
  static String get date => 'Data';
  static String get age => 'Idade';
  static String get name => 'Nome';
}

class PetTypeStrings {
  static String get exotic => 'Exótico';
  static String get dog => 'Cachorro';
  static String get bird => 'Pássaro';
  static String get all => 'Todos';
  static String get cat => 'Gato';
}

class PetHealthString {
  static String get chronicDisease => 'Doença Crônica';
  static String get palliative => 'Paliativo';
  static String get preganant => 'Prenhez';
  static String get healthy => 'Saudável';
  static String get hurted => 'Machucado';
  static String get ill => 'Doente';
}

class LocalPermissionStrings {
  static String get needsAccess => 'precisa ter acesso total a sua localização para funcionar corretamente!';
  static String get needsGPS => 'precisa que o serviço de GPS / Localização esteja ativado!';
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

class PostDetailsStrings {
  static String get lastSeen => 'Visto pela última vez em';

  static String whereIsIt({
    required String petName,
    required String petGender,
  }) {
    if (petGender == male)
      return 'Onde ele está';
    else if (petGender == female) return 'Onde ela está';
    return 'Onde está o PET';
  }

  static String get caracteristics => 'Características';
  static String get health => 'Estado de Saúde';
  static String get description => 'Descrição';
  static String get detailsOf => 'Detalhes de';
  static String get announcer => 'Anunciante';
  static String get size => 'Tamanho';
  static String get female => 'Fêmea';
  static String get male => 'Macho';
  static String get breed => 'Raça';
  static String get age => 'Idade';
  static String get color => 'Cor';
  static String get sex => 'Sexo';
}

class MyProfileStrings {
  static const String allowContactViaWhatsApp = 'Permitir contato via WhatsApp';
  static const String updatingProfile = 'Atualizando perfil...';
  static const String completeProfile = 'Completar perfil';
  static const String deleteAccount = 'Apagar minha conta';
  static const String howCallYou = 'Como devo te chamar?';
  static const String whatsapp = 'Seu número de WhatsApp';
  static const String insertAPicture = 'Insira uma foto';
  static const String editProfile = 'Editar perfil';
  static const String myProfile = 'Meu perfil';
  static const String myAds = 'Meus anúncios';
  static const String ads = 'Anúncios';
}

class MyProfileOptionsTile {
  static const String deleteAccount = 'Deletar minha conta';
  static const String about = 'Sobre o aplicativo';
  static const String talkWithUs = 'Fale conosco';
  static const String settings = 'Configurações';
  static const String myPosts = 'Meus Posts';
  static const String chat = 'Chat Online';
  static const String support = 'Apoie';
  static const String leave = 'Sair';
}

class PostFlowStrings {
  static String whereIsIt({
    required String petName,
    required String petGender,
    bool isDisappeared = false,
  }) {
    final cuttedName = petName.split(' ').first;
    if (isDisappeared) return 'Onde foi visto pela última vez?';

    if (petGender == PostDetailsStrings.male) {
      return 'Onde está o $cuttedName?';
    } else if (petGender == PostDetailsStrings.female) {
      return 'Onde está a $cuttedName?';
    }

    return 'Onde está o PET?';
  }

  static const String videoSizeExceed = 'Tamanho máximo do vídeo excedido!\nO vídeo deve ter até 1:30 min';
  static const String postCancelMessage = 'Saindo agora todos os dados serão perdidos.\nContinuar?';
  static const String otherCaracteristicsOptional = 'Outras características (Opcional)';
  static const String insertVideo = 'Insira um vídeo - máx 1:30 min (Opcional)';
  static const String reviewYourPost = 'Clique no card para revisar seu post';
  static const String describeDiseaseType = 'Descreva qual o tipo de doença';
  static const String insertAtLeastOnePicture = 'Insira pelo menos uma foto';
  static const String deletingAd = 'Deletando anúncio...';
  static const String adDeleted = 'Anúncio Excluído!';
  static String imageQty(int imagesQty) {
    return imagesQty > 1 ? 'Enviando as fotos...' : 'Enviando a foto...';
  }

  static const String isThisPetDisappeared = 'Este PET está desaparecido?';
  static const String fillFullAddress = 'Preencher endereço completo?';
  static const String deleteForever = 'Excluir anúncio em definitivo?';
  static const String otherCaracteristics = 'Outras caracteristicas';
  static const String provideMoreDetails = 'Fornecer mais detalhes';
  static const String selectPetType = 'Selecione o tipo de PET';
  static const String addVideo = 'Se quiser, adicione um vídeo.';
  static const String moreDetails = 'Mais detalhes e descrição';
  static const String addDescription = 'Adicione uma descrição';
  static const String fillAdData = 'Preencher dados do anúncio';
  static const String addMorePictures = 'Adicionar mais fotos';
  static const String postCancelTitle = 'Cancelar postagem?';
  static const String sendingVideo = 'Enviando o vídeo...';
  static const String typeAddress = 'Digite o endereço';
  static const String sendingData = 'Enviando dados...';
  static const String postUpdate = 'Atualizar anúncio';
  static const String reward = 'Recompensa (Opcional)';
  static const String finalizing = 'Finalizando...';
  static const String removeVideo = 'Remover vídeo';
  static const String deleteAd = 'Apagar Anúncio';
  static const String picTime = 'Hora das fotos!';
  static const String editAd = 'Editar Anúncio';
  static const String petsData = 'Dados do PET';
  static const String allDone = 'Tudo pronto!';
  static const String reviewButton = 'Revisar';
  static const String size = 'Tamanho do PET';
  static const String petType = 'Tipo de PET';
  static const String posting = 'Postando...';
  static const String details = 'Detalhes';
  static const String pictures = 'Fotos';
  static const String videos = 'Videos';
  static const String review = 'Revisar';
  static const String petName = 'Nome';
  static const String state = 'Estado';
  static const String delete = 'Apagar';
  static const String months = 'Meses';
  static const String local = 'Local';
  static const String city = 'Cidade';
  static const String post = 'Postar';
  static const String years = 'Anos';
  static const String data = 'Dados';
  static const String age = 'Idade';
}

class ChatStrings {
  static const String writeYourMessage = 'Escreva sua mensagem...';
  static const String startConversation = 'Incie a conversa';
  static const String noContact = 'Nenhum contato ainda';
  static const String myContacts = 'Meus Contatos';
  static const String news = 'Nova';
}

class DeleteAccountStrings {
  static const String deletingAccountStarting = 'Inicializando exclusão de conta';
  static const String foreverDeletedAccount = 'Conta excluída pra sempre!';
  static const String noPetInMyRegion = 'Nenhum PET na minha região';
  static const String alreadyFoundPet = 'Já encontrei meu PET';
  static const String tellUsTheMotive = 'Conte-nos o motivo';
  static const String whichBugs = 'Quais bugs aconteceram?';
  static const String cannotUse = 'Não consigo usar o app';
  static const String alreadyAdopted = 'Já adotei um PET';
  static const String alreadyDonated = 'Já doei meu PET';
  static const String deletingAds = 'Excluíndo anúncios';
  static const String deleteAccount = 'Excluir conta';
  static const String muchAds = 'Muitos anúncios';
  static const String finishing = 'Finalizando';
  static const String other = 'Outro';
  static const String bugs = 'Bugs';
}

class FeedbackStrings {
  static const String sendingYourMessage = 'Enviando sua mensagem para o administrador';
  static const String wannaAnnounceOnApp = 'Quero anunciar minha empresa no Tiu, tiu';
  static const String failureWarning = 'Algo deu errado ao enviar seu feedback.';
  static const String successSent = 'Sua mensagem foi enviada com sucesso!';
  static const String anotherUserIssue = 'Problema com outro usuário';
  static const String writeYourMessage = 'Escreva sua mensagem';
  static const String dificultsUse = 'Dificuldade ao usar o app';
  static const String subject = 'Sobre o quê você quer falar';
  static const String tryingAgain = 'Tentando de novo';
  static const String addImages = 'Adicionar fotos';
  static const String tryAgain = 'Tentar novamente';
  static const String partnership = 'Parceria';
  static const String failure = 'Falha';
}

class SupportUsStrings {
  static const String helpMaintainTheApp = 'Ajude-nos a manter este aplicativo!';
  static const String keyPixCopied = 'Chave copiada!';
  static const String copyKey = 'Copiar chave';
  static const String keyPIX = 'Chave PIX';
}
