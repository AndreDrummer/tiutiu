import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/Widgets/pet_other_caracteristics_card.dart';
import 'package:tiutiu/core/models/pet_caracteristics_model.dart';
import 'package:tiutiu/features/posts/widgets/video_player.dart';
import 'package:tiutiu/core/widgets/verify_account_warning.dart';
import 'package:tiutiu/features/pets/widgets/card_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/Widgets/dots_indicator.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/utils/video_utils.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
import 'package:tiutiu/core/models/post.dart';
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
  ChewieController? chewieController;

  @override
  void initState() {
    initializeVideo();
    super.initState();
  }

  void initializeVideo() {
    final post = postsController.post;

    final cachedVideos = postsController.cachedVideos;
    final cacheExists = cachedVideos[post.uid!] != null;
    var videoPath = post.video;

    if (cacheExists) {
      videoPath = cachedVideos[post.uid!];
    }

    chewieController = VideoUtils.instance.getChewieController(
      autoPlay: false,
      videoPath,
    );
  }

  @override
  void dispose() {
    chewieController?.pause();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Post post = postsController.post;
    final petCaracteristics = PetCaracteristics.petCaracteristics((post as Pet));

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          chewieController?.pause();
          if (!widget.inReviewMode) postsController.clearForm();
          return true;
        },
        child: Scaffold(
          appBar: _appBar(post.name!),
          body: FutureBuilder<void>(
              future: postsController.cacheVideos(),
              builder: (context, snapshot) {
                return ListView(
                  children: [
                    _showImagesAndVideos(
                      boxHeight: Get.height / 2.5,
                      context: context,
                    ),
                    _petCaracteristics(petCaracteristics),
                    VerifyAccountWarning(
                      isHiddingContactInfo: true,
                      anotherRequiredCondition: widget.inReviewMode,
                      child: Column(
                        children: [
                          _description(post.description),
                          _address(),
                          _ownerAdcontact(
                            whatsappMessage: 'whatsappMessage',
                            emailMessage: 'emailMessage',
                            emailSubject: 'emailSubject',
                            user: post.owner!,
                          ),
                        ],
                      ),
                    ),
                    LoadDarkScreen(
                      message: petsController.loadingText,
                      visible: petsController.isLoading,
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  AppBar _appBar(String petName) {
    return AppBar(
      leading: BackButton(color: AppColors.white),
      title: AutoSizeTexts.autoSizeText20(
        '${PetDetailsStrings.detailsOf} $petName',
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
      actions: [
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
      ],
    );
  }

  Widget _showImagesAndVideos({
    required BuildContext context,
    required double boxHeight,
  }) {
    final post = postsController.post;
    final hasVideo = post.video != null;
    final PageController _pageController = PageController();
    final photosQty = post.photos.length;

    return Stack(
      children: [
        _images(
          pageController: _pageController,
          boxHeight: boxHeight,
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
          bottom: 40.0.h,
          left: 24.0.w,
          child: InkWell(
            onTap: () {
              OtherFunctions.navigateToAnnouncerDetail(
                postsController.post.owner!,
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
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: AssetHandle.getImage(
                postsController.post.owner!.avatar,
                isUserImage: true,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 18.0.h,
              left: 8.0.h,
            ),
            child: AutoSizeTexts.autoSizeText12(
              OtherFunctions.firstCharacterUpper(
                postsController.post.owner!.displayName ?? 'Usuário do Tiutiu',
              ).trim(),
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Container _images({
    required PageController pageController,
    required double boxHeight,
  }) {
    final hasVideo = postsController.post.video != null;
    final photos = postsController.post.photos;

    return Container(
      width: double.infinity,
      color: Colors.black,
      height: boxHeight,
      child: PageView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: hasVideo ? photos.length + 1 : photos.length,
        itemBuilder: (BuildContext context, int index) {
          if (hasVideo && index == 0) {
            return _video();
          } else if (!hasVideo) {
            chewieController?.pause();
            return _image(photos, index);
          }
          chewieController?.pause();
          return _image(photos, index - 1);
        },
        controller: pageController,
      ),
    );
  }

  Widget _video() {
    final thereIsVideo = chewieController != null;

    if (thereIsVideo) {
      return TiuTiuVideoPlayer(
        aspectRatio: chewieController!.videoPlayerController.value.aspectRatio,
        chewieController: chewieController!,
      );
    }

    return SizedBox.shrink();
  }

  Widget _image(List photos, int index) {
    return InkWell(
      onTap: () {
        chewieController?.pause();
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
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: FittedBox(
          child: Container(
            child: DotsIndicator(
              controller: pageController,
              onPageSelected: (int page) {
                pageController.animateToPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  page,
                );
              },
              itemCount: length,
            ),
          ),
        ),
      ),
    );
  }

  Container _petCaracteristics(List<PetCaracteristics> petCaracteristics) {
    return Container(
      height: 64.0.h,
      child: Padding(
        padding: EdgeInsets.all(2.0.h),
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

  CardContent _address() {
    final post = postsController.post;

    final describedAddress = post.describedAddress.isNotEmptyNeighterNull() ? '\n\n${post.describedAddress}' : '';

    final showIcon = !post.describedAddress.isNotEmptyNeighterNull() && !(post as Pet).disappeared;

    return CardContent(
      icon: showIcon ? null : Icons.launch,
      content: (post as Pet).disappeared ? (post).lastSeenDetails : '${post.city} - ${post.state} $describedAddress',
      title: post.disappeared
          ? PetDetailsStrings.lastSeen
          : PetDetailsStrings.whereIsIt(
              petGender: post.gender,
              petName: '${post.name}',
            ),
      onAction: () {
        MapsLauncher.launchCoordinates(
          post.latitude ?? 0.0,
          post.longitude ?? 0.0,
          post.name,
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
    final Post post = postsController.post;
    return Container(
      margin: EdgeInsets.only(right: 4.0.w, top: 16.0.h, left: 4.0.w),
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
                  onPressed: () {
                    chatController.startsChatWith(post.owner!);
                  },
                ),
              ),
              SizedBox(width: 16.0.w),
              Expanded(
                child: ButtonWide(
                  text: AppStrings.whatsapp,
                  color: AppColors.primary,
                  icon: FontAwesomeIcons.whatsapp,
                  isToExpand: false,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          ButtonWide(
            text: (post as Pet).disappeared ? AppStrings.provideInfo : AppStrings.iamInterested,
            icon: post.disappeared ? Icons.info : Icons.favorite_border,
            color: post.disappeared ? AppColors.info : AppColors.danger,
            isToExpand: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
