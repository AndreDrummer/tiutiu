import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/card_list.dart';
import 'package:tiutiu/Widgets/error_page.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/providers/refine_search.dart';
import 'package:tiutiu/utils/math_functions.dart';
import 'package:tiutiu/utils/routes.dart';

class DonateDisappearedList extends StatefulWidget {
  DonateDisappearedList({this.kind});
  final String kind;

  @override
  _DonateDisappearedListState createState() => _DonateDisappearedListState();
}

class _DonateDisappearedListState extends State<DonateDisappearedList> {
  bool filtering = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PetsProvider petsProvider;
  RefineSearchProvider refineSearchProvider;
  Location location;
  AdsProvider adsProvider;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  void showFilter() {
    setState(() {
      filtering = !filtering;
    });
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  void initState() {
    petsProvider = Provider.of(context, listen: false);
    if (widget.kind == 'Donate' && petsProvider.getListDonatesPETS == null) {
      petsProvider.loadDonatedPETS();
    } else if (widget.kind != 'Donate' &&
        petsProvider.getListDisappearedPETS == null) {
      petsProvider.loadDisappearedPETS();
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    adsProvider = Provider.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isFiltering() {
    return filtering;
  }

  List<Pet> filterResultsByDistancie(List<Pet> petsListResult) {
    List<Pet> newPetList = [];
    location = Provider.of<Location>(context);
    refineSearchProvider = Provider.of<RefineSearchProvider>(context);

    if (petsListResult != null) {
      for (int i = 0; i < petsListResult.length; i++) {
        String distance = MathFunctions.distanceMatrix(
          latX: location.getLocation.latitude,
          longX: location.getLocation.longitude,
          latY: petsListResult[i].latitude,
          longY: petsListResult[i].longitude,
        );

        String distancieSelected = refineSearchProvider.getDistancieSelected
            ?.split('Km')
            ?.first
            ?.split('Até')
            ?.last;
        double distanceRefineSelected =
            double.tryParse(distancieSelected) ?? 1000;

        if (double.parse(distance) < distanceRefineSelected * 1000) {
          newPetList.add(petsListResult[i]);
        }
      }
    }

    return newPetList;
  }

  @override
  Widget build(BuildContext context) {
    final marginTop = MediaQuery.of(context).size.height / 1.2;

    final kind = widget.kind;

    return RefreshIndicator(
      onRefresh: () => widget.kind == 'Donate'
          ? petsProvider.loadDonatedPETS()
          : petsProvider.loadDisappearedPETS(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blueGrey[50],
        body: StreamBuilder<List<Pet>>(
          stream: kind == 'Donate'
              ? petsProvider.listDonatesPETS
              : petsProvider.listDisappearedPETS,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List petsList = filterResultsByDistancie(snapshot.data);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage(
                messageLoading:
                    'Carregando ${kind == 'Donate' ? 'doação de PETS' : 'desaparecidos'} perto de você...',
                circle: true,
              );
            } else if (snapshot.hasError) {
              return ErrorPage();
            } else {
              if (petsList.isEmpty) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.SEARCH_REFINE);
                  },
                  child: Column(
                    mainAxisAlignment: adsProvider.getCanShowAds ? MainAxisAlignment.start : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,                    
                    children: [
                      SizedBox(height: 10),
                      adsProvider.getCanShowAds
                          ? adsProvider.bannerAdMob(medium_banner: true, adId: adsProvider.topAdId)
                          : Container(),
                      SizedBox(height: 40),
                      Text(
                        'Nenhum PET ${kind == 'Donate' ? 'para adoção' : 'encontrado'}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              color: Colors.black,
                            ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Verifique seus filtros de busca.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              color: Colors.blueAccent,
                            ),
                      ),
                    ],
                  ),
                );
              }
            }
            return Container(
              height: marginTop,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      adsProvider.getCanShowAds
                          ? adsProvider.bannerAdMob(adId: adsProvider.homeAdId)
                          : Container(
                              color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Você está utilizando Tiu, tiu em fase de teste. Os dados podem ser fictícios.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: petsList.length + 1,
                      itemBuilder: (_, index) {
                        if (index == petsList.length) {
                          return SizedBox(height: 50);
                        }
                        return CardList(
                          kind: kind,
                          petInfo: petsList[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
