import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/Widgets/pet_other_caracteristics_card.dart';
import 'package:tiutiu/core/models/pet_caracteristics_model.dart';
import 'package:tiutiu/features/posts/widgets/video_player.dart';
import 'package:tiutiu/features/pets/widgets/card_content.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/utils/video_utils.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/dots_indicator.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

class PetDetails extends StatefulWidget {
  const PetDetails({super.key, this.inReviewMode = false});

  final bool inReviewMode;

  @override
  State<PetDetails> createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  late ChewieController chewieController;

  @override
  void initState() {
    chewieController = VideoUtils.instance.getChewieController(
      'https://firebasestorage.googleapis.com/v0/b/boi-certo.appspot.com/o/prod%2Fusers%2FqAc8knYpxxga33bMxcpKHUDIk982%2Fads%2F63cde7b4-9308-4ad2-8827-2990b3186015%2Fvideos%2Fvideos0?alt=media&token=d14d77d0-0818-4873-ad04-fff5fe1cd165',
    );
    super.initState();
  }

  @override
  void dispose() {
    chewieController.videoPlayerController.pause();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Pet pet = petsController.pet;
    final petCaracteristics = PetCaracteristics.petCaracteristics(pet);

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<void>(
            future: postsController.cacheAndGetVideos(),
            builder: (_, __) {
              return Stack(
                children: [
                  Background(dark: true),
                  Column(
                    children: [
                      _showImagesAndVideos(
                        boxHeight: Get.height / 2.5,
                        context: context,
                        pet: pet,
                      ),
                      Expanded(
                        child: Container(
                          height: Get.height / 4.5,
                          child: Column(
                            children: [
                              _petCaracteristics(petCaracteristics),
                              _description(pet.description),
                              _address(pet),
                              Spacer(),
                              _ownerAdcontact(
                                whatsappMessage: 'whatsappMessage',
                                emailMessage: 'emailMessage',
                                emailSubject: 'emailSubject',
                                user: pet.owner!,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(child: _appBar(pet.name!)),
                  LoadDarkScreen(
                    message: petsController.loadingText,
                    visible: petsController.isLoading,
                  )
                ],
              );
            }),
      ),
    );
  }

  Container _appBar(String petName) {
    return Container(
      color: Colors.black26.withOpacity(.3),
      height: 56.0.h,
      child: Row(
        children: [
          BackButton(color: AppColors.white),
          Spacer(),
          AutoSizeText(
            '${PetDetailsStrings.detailsOf} $petName',
            style: TextStyles.fontSize20(
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          Spacer(),
          Visibility(
            visible: !widget.inReviewMode,
            child: IconButton(
              icon: Icon(
                color: AppColors.white,
                Icons.share,
              ),
              onPressed: () {},
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _showImagesAndVideos({
    required BuildContext context,
    required double boxHeight,
    required Pet pet,
  }) {
    final hasVideo = pet.video?.isNotEmptyNeighterNull() ?? true;
    final PageController _pageController = PageController();
    final photosQty = pet.photos.length;

    return Stack(
      children: [
        _images(
          pageController: _pageController,
          boxHeight: boxHeight,
          pet: pet,
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          left: 0.0,
          child: _dotsIndicator(
            length: hasVideo ? photosQty + 1 : photosQty,
            pageController: _pageController,
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
                petsController.pet.owner!.displayName ?? 'Usuário do Tiutiu',
              ).trim(),
              style: TextStyles.fontSize(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
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
    required double boxHeight,
    required Pet pet,
  }) {
    final hasVideo = pet.video?.isNotEmptyNeighterNull() ?? true;
    final photos = pet.photos;

    return Container(
      width: double.infinity,
      color: Colors.black,
      height: boxHeight,
      child: PageView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: hasVideo ? photos.length + 1 : photos.length,
        itemBuilder: (BuildContext context, int index) {
          if (hasVideo && index == 0) {
            return _video(pet.video);
          } else if (!hasVideo) {
            return _image(pet.photos, index);
          }
          return _image(pet.photos, index - 1);
        },
        controller: pageController,
      ),
    );
  }

  TiuTiuVideoPlayer _video(dynamic videoPath) {
    return TiuTiuVideoPlayer(chewieController: chewieController);
  }

  Widget _image(List photos, int index) {
    return InkWell(
      onTap: () {
        chewieController.videoPlayerController.pause();
        fullscreenController.openFullScreenMode(photos);
      },
      child: Container(
        child: AssetHandle.getImage(photos.elementAt(index)),
        width: double.infinity,
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
        padding: EdgeInsets.fromLTRB(2.0.w, 8.0.h, 2.0.w, 2.0.h),
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

  Widget _description(String? description) {
    return Visibility(
      visible: description != null,
      child: CardContent(
        title: PetDetailsStrings.description,
        content: description ?? '',
      ),
    );
  }

  CardContent _address(Pet pet) {
    final describedAddress = pet.describedAddress.isNotEmptyNeighterNull()
        ? '\n\n${pet.describedAddress}'
        : '';

    return CardContent(
      icon: pet.disappeared ? null : Icons.launch,
      content: pet.disappeared
          ? pet.lastSeenDetails
          : '${pet.city} - ${pet.state} $describedAddress',
      title: pet.disappeared
          ? PetDetailsStrings.lastSeen
          : PetDetailsStrings.whereIsIt(
              petGender: pet.gender,
              petName: '${pet.name}',
            ),
      onAction: () {},
    );
  }

  Widget _ownerAdcontact({
    String? whatsappMessage,
    String? emailMessage,
    String? emailSubject,
    TiutiuUser? user,
  }) {
    final Pet pet = petsController.pet;
    return Visibility(
      visible: !widget.inReviewMode,
      child: Container(
        height: Get.height / 5.5,
        margin: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: Column(
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
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 16.0.w),
                Expanded(
                  child: ButtonWide(
                    text: AppStrings.whatsapp,
                    color: AppColors.primary,
                    icon: Tiutiu.whatsapp,
                    isToExpand: false,
                    onPressed: () {},
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
              isToExpand: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
