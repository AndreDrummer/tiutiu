import 'package:tiutiu/features/refine_search/controller/refine_search_controller.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/screen/donate_disappeared_list.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/play_store_rating.dart';
import 'package:tiutiu/screen/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final RefineSearchController _refineSearchController = Get.find();

class PetsList extends StatefulWidget {
  PetsList({
    this.petKind = FirebaseEnvPath.donate,
  });
  final String petKind;

  @override
  _PetsListState createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> {
  @override
  void didChangeDependencies() {
    petsController.loadDisappearedPETS(state: 'null');
    // petsController.loadDonatePETS(state: 'null');
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
    if (widget.petKind == FirebaseEnvPath.disappeared) {
      petsController.petKind = FirebaseEnvPath.disappeared;
      if (_refineSearchController.searchPetByTypeOnHome &&
          _refineSearchController.isHomeFilteringByDisappeared) {
        _refineSearchController.changeSearchHomePetTypeInitialValue(
            _refineSearchController.homePetTypeFilterByDisappeared);
        petsController.petType =
            _refineSearchController.homePetTypeFilterByDisappeared;
        petsController.isFiltering = true;
      } else {
        _refineSearchController.changeSearchHomePetTypeInitialValue(
            _refineSearchController.searchHomePetType.first);
        petsController.isFiltering = false;
      }

      petsController.loadDisappearedPETS(
          state: _refineSearchController.stateOfResultSearch);
      if (petsController.isFilteringByBreed || petsController.isFilteringByName)
        petsController.typingSearchResult = petsController.petsDisappeared;
    } else {
      petsController.petKind = FirebaseEnvPath.donate;
      if (_refineSearchController.searchPetByTypeOnHome &&
          _refineSearchController.isHomeFilteringByDonate) {
        _refineSearchController.changeSearchHomePetTypeInitialValue(
            _refineSearchController.homePetTypeFilterByDonate);
        petsController.petType =
            _refineSearchController.homePetTypeFilterByDonate;
        petsController.isFiltering = true;
      } else {
        _refineSearchController.changeSearchHomePetTypeInitialValue(
            _refineSearchController.searchHomePetType.first);
        petsController.isFiltering = false;
      }

      // petsController.loadDonatePETS(
      //     state: _refineSearchController.stateOfResultSearch);
      if (petsController.isFilteringByBreed || petsController.isFilteringByName)
        petsController.typingSearchResult = petsController.petsDonate;
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
          newMessagesStream: chatController.newMessages(),
          navigateToAuth: navigateToAuth,
          openSocial: openSocial,
        ),
      ),
      body: Container(
        child: DonateDisappearedList(
          petList: widget.petKind == FirebaseEnvPath.donate
              ? petsController.petsDonate
              : petsController.petsDisappeared,
        ),
      ),
    );
  }
}
