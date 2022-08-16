import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/card_list.dart';
import 'package:tiutiu/Widgets/loading_screen.dart';
import 'package:tiutiu/features/system/controllers.dart';

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
        title: Text(
          'Favoritos'.toUpperCase(),
          style: Theme.of(context).textTheme.headline1!.copyWith(
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
                    return LoadingScreen(text: 'Carregando favoritos');
                  }
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhum PET Favoritado',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline1!.copyWith(
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
                            return CardList(
                              petInfo: snapshot.data[index],
                              kind: snapshot.data[index].kind,
                              favorite: true,
                            );
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
