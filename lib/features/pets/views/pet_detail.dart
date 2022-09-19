import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/Widgets/pet_other_caracteristics_card.dart';
import 'package:tiutiu/core/models/pet_caracteristics_model.dart';
import 'package:tiutiu/features/pets/widgets/card_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/dots_indicator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pet pet = petsController.pet;
    final petCaracteristics = PetCaracteristics.petCaracteristics(pet);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Background(dark: true),
            Column(
              children: [
                _showImages(
                  boxHeight: Get.height / 2.5,
                  photos: pet.photos!,
                  context: context,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _petCaracteristics(petCaracteristics),
                      _description(pet.details!),
                      _address(pet),
                      _ownerAdcontact(
                        whatsappMessage: 'whatsappMessage',
                        emailMessage: 'emailMessage',
                        emailSubject: 'emailSubject',
                        user: pet.owner!,
                      )
                    ],
                  ),
                )
              ],
            ),
            Positioned(child: _appBar(pet.name!)),
            LoadDarkScreen(
              message: petsController.loadingText,
              show: petsController.isLoading,
            )
          ],
        ),
      ),
    );
  }

  Container _appBar(String petName) {
    return Container(
      color: Colors.black26.withOpacity(.3),
      height: 56.0.h,
      child: Row(
        children: [
          BackButton(color: Colors.white),
          Spacer(),
          AutoSizeText(
            '${PetDetailsString.detailsOf} $petName',
            style: TextStyles.fontSize20(
                fontWeight: FontWeight.w600, color: Colors.white),
          ),
          Spacer(),
          authController.firebaseUser == null
              ? Container()
              : IconButton(
                  onPressed: petsController.handleChatButtonPressed,
                  icon: Icon(FontAwesomeIcons.comments),
                  color: Colors.white,
                ),
          IconButton(
            icon: Icon(
              color: Colors.white,
              Icons.share,
            ),
            onPressed: () {},
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _showImages({
    required BuildContext context,
    required double boxHeight,
    required List photos,
  }) {
    final PageController _pageController = PageController();

    return Stack(
      children: [
        InkWell(
          onTap: () {
            fullscreenController.openFullScreenMode(photos);
          },
          child: _images(
            boxHeight: boxHeight,
            pageController: _pageController,
            photos: photos,
          ),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          left: 0.0,
          child: _dotsIndicator(
            pageController: _pageController,
            length: photos.length,
          ),
        ),
        Positioned(
          bottom: 24.0.h,
          right: 8.0.w,
          child: InkWell(
            onTap: () {
              OtherFunctions.navigateToAnnouncerDetail(
                petsController.pet.owner!,
              );
            },
            child: _announcerBadge(),
          ),
        )
      ],
    );
  }

  Container _announcerBadge() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.0, 0.8),
          end: Alignment(0.0, 0.0),
          colors: [
            Color.fromRGBO(0, 0, 0, 0),
            Color.fromRGBO(0, 0, 0, 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(48.0.h),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 18.0.h,
              left: 8.0.h,
            ),
            child: AutoSizeText(
              OtherFunctions.firstCharacterUpper(
                petsController.pet.owner!.displayName!,
              ).trim(),
              style: TextStyles.fontSize(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: AssetHandle.getImage(
                petsController.pet.owner!.avatar,
                isUserImage: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _images({
    required PageController pageController,
    required List<dynamic> photos,
    required double boxHeight,
  }) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      height: boxHeight,
      child: PageView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: pageController,
        itemCount: photos.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: AssetHandle.getImage(photos.elementAt(index)),
            width: double.infinity,
          );
        },
      ),
    );
  }

  Widget _dotsIndicator({
    required PageController pageController,
    required int length,
  }) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: FittedBox(
          child: Container(
            child: DotsIndicator(
              controller: pageController,
              itemCount: length,
              onPageSelected: (int page) {
                pageController.animateToPage(
                  page,
                  duration: Duration(
                    milliseconds: 500,
                  ),
                  curve: Curves.ease,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Container _petCaracteristics(List<PetCaracteristics> petCaracteristics) {
    return Container(
      height: 80.0.h,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListView.builder(
          key: UniqueKey(),
          scrollDirection: Axis.horizontal,
          itemCount: petCaracteristics.length,
          itemBuilder: (_, int index) {
            return PetOtherCaracteristicsCard(
              content: petCaracteristics[index].content,
              title: petCaracteristics[index].title,
              icon: petCaracteristics[index].icon,
            );
          },
        ),
      ),
    );
  }

  CardContent _description(String description) {
    return CardContent(
      title: PetDetailsString.description,
      content: description,
    );
  }

  CardContent _address(Pet pet) {
    return CardContent(
      icon: pet.disappeared ? null : Icons.launch,
      content:
          pet.disappeared ? pet.lastSeenDetails : '${pet.city} - ${pet.state}',
      title: pet.disappeared
          ? PetDetailsString.lastSeen
          : PetDetailsString.whereIsPet,
      onAction: () {
        MapsLauncher.launchCoordinates(
          pet.latitude!,
          pet.longitude!,
          pet.name,
        );
      },
    );
  }

  Widget _ownerAdcontact({
    String? whatsappMessage,
    String? emailMessage,
    String? emailSubject,
    TiutiuUser? user,
  }) {
    final Pet pet = petsController.pet;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ButtonWide(
                color: AppColors.secondary,
                text: AppStrings.chat,
                isToExpand: false,
                icon: Icons.phone,
                action: () {},
              ),
            ),
            Expanded(
              child: ButtonWide(
                text: AppStrings.whatsapp,
                color: AppColors.primary,
                icon: Tiutiu.whatsapp,
                isToExpand: false,
                action: () {},
              ),
            ),
          ],
        ),
        ButtonWide(
          text: pet.disappeared
              ? AppStrings.provideInfo
              : AppStrings.iamInterested,
          icon: pet.disappeared ? Icons.info : Icons.favorite_border,
          color: pet.disappeared ? AppColors.info : AppColors.danger,
          isToExpand: false,
          action: () {},
        ),
      ],
    );
  }
}
