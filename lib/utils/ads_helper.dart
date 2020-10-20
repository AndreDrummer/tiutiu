// import 'package:firebase_admob/firebase_admob.dart';

// const String testDevice = 'YOUR_DEVICE_ID';

// class Ads {
//   static BannerAd homeBlock;
//   static BannerAd myPettsBlock;
//   static InterstitialAd noConnectionBlock;
//   static BannerAd myAccountBlock;  

//   static void initialize() {
//     FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
//   }

//   static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//     keywords: <String>['pets', 'cats' 'dogs', 'animais', 'gatos', 'cachorros'],
//     childDirected: false,
//   );

//   static BannerAd _createBannerAd({String adId}) {
//     return BannerAd(
//       adUnitId: BannerAd.testAdUnitId,
//       size: AdSize.banner,
//       targetingInfo: targetingInfo,
//       listener: (MobileAdEvent event) {        
//         print("BannerAd event is $event");
//       },
//     );
//   }

//   static InterstitialAd _createInterstitialAd({String adId}) {
//     return InterstitialAd(
//       adUnitId: InterstitialAd.testAdUnitId,
//       targetingInfo: targetingInfo,
//       listener: (MobileAdEvent event) {        
//         print("InterstitialAd event is $event");
//       },
//     );
//   }

//   static void showBannerAdHome() {
//     if (homeBlock == null) homeBlock = _createBannerAd(adId: 'ca-app-pub-2837828701670824/9751920293');
//     homeBlock
//       ..load()
//       ..show(
//         anchorOffset: 160,
//         anchorType: AnchorType.top,
//       );
//   }

//   static void showBannerAdMyPets() {
//     if (myPettsBlock == null)
//       myPettsBlock =
//           _createBannerAd(adId: 'ca-app-pub-2837828701670824/3311431180');
//     myPettsBlock
//       ..load()
//       ..show(
//         anchorOffset: 87,
//         anchorType: AnchorType.top,
//       );
//   }

//   static void showBannerAdNoConnection() {
//     if (noConnectionBlock == null)
//       noConnectionBlock =
//           _createInterstitialAd(adId: 'ca-app-pub-2837828701670824/9030661721');
//     noConnectionBlock
//       ..load()
//       ..show(
//         anchorOffset: 87,
//         anchorType: AnchorType.top,
//       );
//   }

//   static void showBannerAdMyAccount() {
//     if (myAccountBlock == null)
//       myAccountBlock =
//           _createBannerAd(adId: 'ca-app-pub-2837828701670824/5937594529');
//     myAccountBlock
//       ..load()
//       ..show(
//         anchorOffset: 52,
//         anchorType: AnchorType.bottom,
//       );
//   }

//   static void hideBannerAdHome() async {  
//     try {      
//       print('HOME BLOCK NULL: ${homeBlock == null}');
//       if(homeBlock != null) {
//         await homeBlock.dispose();
//       }
//       homeBlock = null;      
//       print('(AFTER) HOME BLOCK NULL: ${homeBlock == null}');
//     } catch (ex) {
//       print("Banner home dispose error");
//     }
//   }

//   static void hideBannerAdMyAccount() async {
//     try {
//       if(myAccountBlock != null) {
//         myAccountBlock.dispose();
//       }
//       myAccountBlock = null;
//     } catch (ex) {
//       print("Banner myAccount dispose error");
//     }
//   }

//   static void hideBannerAdMyPets() async {
//     try {
//       myPettsBlock?.dispose();
//       myPettsBlock = null;
//     } catch (ex) {
//       print("Banner my pets dispose error");
//     }
//   }

//   static void hideBannerAdNoConnection() async {
//     try {
//       noConnectionBlock?.dispose();
//       noConnectionBlock = null;
//     } catch (ex) {
//       print("Banner noConnection dispose error");
//     }
//   }

//   static void handleAdsBottom() async {    
//     await hideBannerAdHome();
//     await hideBannerAdMyPets();
//     await hideBannerAdNoConnection();

//     showBannerAdMyAccount();
//   }

//   static void handleAdsTop() async {
//     await hideBannerAdMyAccount();
//     await hideBannerAdMyPets();
//     await hideBannerAdNoConnection();

//     showBannerAdHome();
//   }

//   static void handleAdsTopMyPets() async {
//     await hideBannerAdMyAccount();
//     await hideBannerAdHome();
//     await hideBannerAdNoConnection();

//     showBannerAdMyPets();
//   }

//   static void closeAllAds() async {
//     await hideBannerAdMyAccount();
//     await hideBannerAdMyPets();
//     await hideBannerAdHome();
//     await hideBannerAdNoConnection();
//   }

//   static void handleNoConnectionAds() async {  
//     await hideBannerAdMyPets();
//     await hideBannerAdHome();
//     showBannerAdNoConnection();
//     showBannerAdMyAccount();
//   }

// }
