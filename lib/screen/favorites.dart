import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/cards/card_ad.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  // AdsProvider adsProvider;

  @override
  void didChangeDependencies() {
    // adsProvider = Provider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: AutoSizeText(
          'Favoritos'.toUpperCase(),
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => favoritesController.loadFavoritesReference(),
        child: Stack(
          children: [
            Background(),
            Container(
              child: StreamBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingPage(messageLoading: 'Carregando favoritos');
                  }
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: AutoSizeText(
                        'Nenhum PET Favoritado',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w100,
                            ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      // adsProvider.getCanShowAds
                      // ? adsProvider.bannerAdMob(
                      // adId: adsProvider.topAdId)
                      // : Container(),
                      Expanded(
                        child: ListView.builder(
                          key: UniqueKey(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) {
                            return CardAd(pet: snapshot.data[index]);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
