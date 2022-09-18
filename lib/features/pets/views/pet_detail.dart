import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/Widgets/pet_other_caracteristics_card.dart';
import 'package:tiutiu/core/models/pet_caracteristics_model.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/chat/common/functions.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/fullscreen_images.dart';
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
  final bool interestOrInfoWasFired = false;
  final int timeToSendRequestAgain = 120;
  final bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    final Pet pet = petsController.pet;
    final petCaracteristics = PetCaracteristics.petCaracteristics(pet);

    return Scaffold(
      appBar: _appBar(pet.name!),
      body: Stack(
        children: [
          Background(dark: true),
          Column(
            children: [
              _showImages(
                boxHeight: Get.height / 3,
                photos: pet.photos!,
                context: context,
              ),
              Expanded(
                child: ListView(
                  children: [
                    _petCaracteristics(petCaracteristics),
                    _description(pet.details!),
                    _address(pet),
                    SizedBox(height: pet.details!.length * .2),
                    _ownerPetcontact(
                      user: pet.owner!,
                      whatsappMessage: 'whatsappMessage',
                      emailMessage: 'emailMessage',
                      emailSubject: 'emailSubject',
                    )
                  ],
                ),
              )
            ],
          ),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return LoadDarkScreen(
                message: 'Gerando link compartilhável',
                show: snapshot.data ?? false,
              );
            },
          )
        ],
      ),
    );
  }

  Padding _address(Pet pet) {
    return Padding(
      padding: EdgeInsets.all(4.0.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8.0,
        child: Padding(
          padding: EdgeInsets.all(8.0.h),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        PetDetailsString.whereIsPet,
                        style: TextStyles.fontSize16(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          MapsLauncher.launchCoordinates(
                            pet.latitude!,
                            pet.longitude!,
                            pet.name,
                          );
                        },
                        child: Icon(
                          color: Colors.blue,
                          Icons.launch,
                          size: 16.0.h,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                AutoSizeText(
                  '${pet.city} - ${pet.state}',
                  style: TextStyles.fontSize12(color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _description(String description) {
    return Padding(
      padding: EdgeInsets.all(4.0.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.h),
        ),
        elevation: 8.0,
        child: Padding(
            padding: EdgeInsets.all(8.0.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 120.0.h,
                minHeight: 0.0.h,
              ),
              child: Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: AutoSizeText(
                          PetDetailsString.description,
                          style: TextStyles.fontSize16(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Divider(),
                      AutoSizeText(description),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Container _petCaracteristics(List<PetCaracteristics> petCaracteristics) {
    return Container(
      height: 96.0.h,
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

  AppBar _appBar(String petName) {
    return AppBar(
      leading: BackButton(),
      title: AutoSizeText(
        '${PetDetailsString.detailsOf} $petName',
        style: TextStyles.fontSize20(color: Colors.white),
      ),
      actions: [
        IconButton(icon: Icon(Icons.share), onPressed: () {}),
        authController.firebaseUser == null
            ? Container()
            : IconButton(
                onPressed: petsController.handleChatButtonPressed,
                icon: Icon(Icons.chat),
                color: Colors.white,
              ),
      ],
    );
  }

  void openFullScreenMode(List photos_list) {
    Get.to(
      MaterialPageRoute(
        builder: (context) => FullScreenImage(
          images: photos_list,
        ),
      ),
    );
  }

  Widget _showImages({
    required BuildContext context,
    required List photos,
    required double boxHeight,
  }) {
    final PageController _pageController = PageController();

    return Stack(
      children: [
        InkWell(
          onTap: () => openFullScreenMode(photos),
          child: Container(
            color: Colors.black,
            height: boxHeight,
            width: double.infinity,
            child: PageView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: photos.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  photos.elementAt(index),
                  loadingBuilder: loadingImage,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment(1, -0.15),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: FittedBox(
                child: Container(
                  child: DotsIndicator(
                    controller: _pageController,
                    itemCount: photos.length,
                    onPageSelected: (int page) {
                      _pageController.animateToPage(
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
          ),
        ),
        Positioned(
          bottom: 24.0.h,
          left: 8.0.w,
          child: InkWell(
            onTap: () {
              OtherFunctions.navigateToAnnouncerDetail(
                context,
                petsController.pet.owner!,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.8),
                  end: Alignment(0.0, 0.0),
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0),
                    Color.fromRGBO(0, 0, 0, 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: FadeInImage(
                        placeholder: AssetImage(ImageAssets.profileEmpty),
                        image: AssetHandle(
                          petsController.pet.owner!.avatar,
                        ).build(),
                        fit: BoxFit.cover,
                        width: 1000,
                        height: 100,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Anunciante',
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: 10),
                        ),
                        AutoSizeText(
                          OtherFunctions.firstCharacterUpper(
                            petsController.pet.owner!.displayName!,
                          ),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget loadingImage(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText('Carregando imagem..'),
          LoadingJumpingLine.circle(),
        ],
      ),
    );
  }

  Widget _ownerPetcontact({
    String? whatsappMessage,
    String? emailSubject,
    String? emailMessage,
    TiutiuUser? user,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ButtonWide(
                action: () {
                  // CommonChatFunctions.openChat(
                  //   firstUser: tiutiuUserController.tiutiuUser,
                  //   secondUser: petsController.pet.owner!,
                  // );
                },
                color: AppColors.secondary,
                icon: Icons.phone,
                isToExpand: false,
                text: 'Chat',
              ),
            ),
            Expanded(
              child: ButtonWide(
                action: () {},
                color: AppColors.primary,
                icon: Tiutiu.whatsapp,
                isToExpand: false,
                text: 'WhatsApp',
              ),
            ),
          ],
        ),
        ButtonWide(
          action: () {
            CommonChatFunctions.openChat(
              firstUser: tiutiuUserController.tiutiuUser,
              secondUser: petsController.pet.owner!,
            );
          },
          icon: Icons.favorite_border,
          text: 'Estou Interessado',
          color: AppColors.danger,
          isToExpand: false,
        ),
      ],
    );
  }
}
