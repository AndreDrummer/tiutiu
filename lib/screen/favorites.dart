import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/card_list.dart';
import 'package:tiutiu/Widgets/loading_screen.dart';
import 'package:tiutiu/providers/favorites_provider.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  FavoritesProvider favoritesProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    favoritesProvider = Provider.of(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          'Favoritos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => favoritesProvider.loadFavoritesReference(),
        child: Consumer<FavoritesProvider>(
          builder: (ctx, favoritesConsumer, _) {
            return Stack(
              children: [
                Background(),
                Container(
                  child: StreamBuilder(
                    stream: favoritesProvider.favoritesPETSList,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingScreen(text: 'Carregando favoritos');
                      }
                      if (snapshot.data.isEmpty) {
                        return Center(
                          child: Text(
                            'Nenhum PET Favoritado',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.headline1.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w100,
                                    ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return CardList(
                            petInfo: snapshot.data[index],
                            kind: snapshot.data[index].kind,
                            favorite: true,
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
