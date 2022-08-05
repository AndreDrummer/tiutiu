List<Binding> bindings = [
  UserBindings(),
  AuthBindings(),
  HomeBinding(),
  PriceBinding(),
  AdFlowsBindindg(),
  AuctionBinding(),
  AreaPremiumBinding(),
  ProfileBinding(),
  SystemGeneralSettingsBindings(),
];

Future<void> initServices() async {
  for (var controller in bindings) {
    controller.init();
  }

  final PriceController _priceController = Get.find();
  final SystemGeneralSettings _system = Get.find();
  _system.setLoginWithAppleIsAvailableStatus(
    isAvailable: await SignInWithApple.isAvailable(),
  );

  _priceController.loadCepeaProducts();

  await DataLocalStrings().getUFAndCities();
}
