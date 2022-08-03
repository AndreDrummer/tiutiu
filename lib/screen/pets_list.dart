import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/play_store_rating.dart';
import 'package:tiutiu/providers/chat_provider.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/screen/appBar.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/providers/refine_search.dart';
import 'package:tiutiu/screen/donate_disappeared_list.dart';
import 'package:tiutiu/utils/routes.dart';

class PetsList extends StatefulWidget {
  PetsList({
    this.petKind = Constantes.DONATE,
  });
  final String petKind;

  @override
  _PetsListState createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> {
  RefineSearchProvider? refineSearchProvider;
  PetsProvider? petsProvider;
  ChatProvider? chatProvider;

  @override
  void didChangeDependencies() {
    petsProvider = Provider.of<PetsProvider>(context);
    chatProvider = Provider.of<ChatProvider>(context);
    refineSearchProvider = Provider.of<RefineSearchProvider>(context);
    petsProvider!.loadDisappearedPETS(
        state: refineSearchProvider!.getStateOfResultSearch);
    petsProvider!
        .loadDonatePETS(state: refineSearchProvider!.getStateOfResultSearch);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(PetsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.petKind != oldWidget.petKind) {
      onPetTypeChange();
    }
  }

  void onPetTypeChange() {
    print(widget.petKind);
    if (widget.petKind == Constantes.DISAPPEARED) {
      petsProvider!.changePetKind(Constantes.DISAPPEARED);
      if (refineSearchProvider!.getSearchPetByTypeOnHome &&
          refineSearchProvider!.getIsHomeFilteringByDisappeared) {
        refineSearchProvider!.changeSearchHomePetTypeInitialValue(
            refineSearchProvider!.getHomePetTypeFilterByDisappeared);
        petsProvider!.changePetType(
            refineSearchProvider!.getHomePetTypeFilterByDisappeared);
        petsProvider!.changeIsFiltering(true);
      } else {
        refineSearchProvider!.changeSearchHomePetTypeInitialValue(
            refineSearchProvider!.getSearchHomePetType.first);
        petsProvider!.changeIsFiltering(false);
      }

      petsProvider!.loadDisappearedPETS(
          state: refineSearchProvider!.getStateOfResultSearch);
      if (petsProvider!.getIsFilteringByBreed ||
          petsProvider!.getIsFilteringByName)
        petsProvider!
            .changeTypingSearchResult(petsProvider!.getPetsDisappeared);
    } else {
      petsProvider!.changePetKind(Constantes.DONATE);
      if (refineSearchProvider!.getSearchPetByTypeOnHome &&
          refineSearchProvider!.getIsHomeFilteringByDonate) {
        refineSearchProvider!.changeSearchHomePetTypeInitialValue(
            refineSearchProvider!.getHomePetTypeFilterByDonate);
        petsProvider!
            .changePetType(refineSearchProvider!.getHomePetTypeFilterByDonate);
        petsProvider!.changeIsFiltering(true);
      } else {
        refineSearchProvider!.changeSearchHomePetTypeInitialValue(
            refineSearchProvider!.getSearchHomePetType.first);
        petsProvider!.changeIsFiltering(false);
      }

      petsProvider!
          .loadDonatePETS(state: refineSearchProvider!.getStateOfResultSearch);
      if (petsProvider!.getIsFilteringByBreed ||
          petsProvider!.getIsFilteringByName)
        petsProvider!.changeTypingSearchResult(petsProvider!.getPetsDonate);
    }
  }

  void openSocial() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: RatingUs(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void navigateToAuth() {
      Navigator.pushNamed(context, Routes.AUTH, arguments: true);
    }

    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: TitleAppBar(
          navigateToAuth: navigateToAuth,
          openSocial: openSocial,
          newMessagesStream: chatProvider!.newMessages(),
        ),
      ),
      body: Container(
        child: DonateDisappearedList(
          stream: widget.petKind == Constantes.DONATE
              ? petsProvider!.petsDonate
              : petsProvider!.petsDisappeared,
        ),
      ),
    );
  }
}
