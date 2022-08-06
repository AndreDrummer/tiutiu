import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/play_store_rating.dart';
import 'package:tiutiu/features/refine_search/controller/refine_search_controller.dart';
import 'package:tiutiu/providers/chat_provider.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/screen/appBar.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/screen/donate_disappeared_list.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';

final RefineSearchController _refineSearchController = Get.find();

class PetsList extends StatefulWidget {
  PetsList({
    this.petKind = Constantes.DONATE,
  });
  final String petKind;

  @override
  _PetsListState createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> {
  PetsProvider? petsProvider;
  ChatProvider? chatProvider;

  @override
  void didChangeDependencies() {
    petsProvider = Provider.of<PetsProvider>(context);
    chatProvider = Provider.of<ChatProvider>(context);

    petsProvider!.loadDisappearedPETS(
      state: 'null',
    );
    petsProvider!.loadDonatePETS(
      state: 'null',
    );
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
      if (_refineSearchController.searchPetByTypeOnHome &&
          _refineSearchController.isHomeFilteringByDisappeared) {
        _refineSearchController.changeSearchHomePetTypeInitialValue(
            _refineSearchController.homePetTypeFilterByDisappeared);
        petsProvider!.changePetType(
            _refineSearchController.homePetTypeFilterByDisappeared);
        petsProvider!.changeIsFiltering(true);
      } else {
        _refineSearchController.changeSearchHomePetTypeInitialValue(
            _refineSearchController.searchHomePetType.first);
        petsProvider!.changeIsFiltering(false);
      }

      petsProvider!.loadDisappearedPETS(
          state: _refineSearchController.stateOfResultSearch);
      if (petsProvider!.getIsFilteringByBreed ||
          petsProvider!.getIsFilteringByName)
        petsProvider!
            .changeTypingSearchResult(petsProvider!.getPetsDisappeared);
    } else {
      petsProvider!.changePetKind(Constantes.DONATE);
      if (_refineSearchController.searchPetByTypeOnHome &&
          _refineSearchController.isHomeFilteringByDonate) {
        _refineSearchController.changeSearchHomePetTypeInitialValue(
            _refineSearchController.homePetTypeFilterByDonate);
        petsProvider!
            .changePetType(_refineSearchController.homePetTypeFilterByDonate);
        petsProvider!.changeIsFiltering(true);
      } else {
        _refineSearchController.changeSearchHomePetTypeInitialValue(
            _refineSearchController.searchHomePetType.first);
        petsProvider!.changeIsFiltering(false);
      }

      petsProvider!
          .loadDonatePETS(state: _refineSearchController.stateOfResultSearch);
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
            TextButton(
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
      Navigator.pushNamed(context, Routes.auth, arguments: true);
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
