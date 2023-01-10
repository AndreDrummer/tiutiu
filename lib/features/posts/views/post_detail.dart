import 'package:tiutiu/features/dennounce/views/post_dennounce_screen.dart';
import 'package:tiutiu/features/dennounce/widgets/dennounce_button.dart';
import 'package:tiutiu/features/favorites/widgets/favorite_button.dart';
import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/core/widgets/pet_other_caracteristics_card.dart';
import 'package:tiutiu/features/posts/widgets/post_action_button.dart';
import 'package:tiutiu/core/pets/model/pet_caracteristics_model.dart';
import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/core/widgets/no_connection_text_info.dart';
import 'package:tiutiu/features/posts/widgets/video_player.dart';
import 'package:tiutiu/features/posts/widgets/card_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:tiutiu/core/views/loading_video_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/widgets/tiutiu_snackbar.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/views/load_dark_screen.dart';
import 'package:tiutiu/core/widgets/dots_indicator.dart';
import 'package:tiutiu/core/widgets/warning_widget.dart';
import 'package:tiutiu/core/constants/contact_type.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/utils/video_utils.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

class PostDetails extends StatefulWidget {
  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> with TiuTiuPopUp {
  ChewieController? chewieController;
  bool isLoadingVideo = true;
  late VideoUtils videoUtils;

  @override
  void initState() {
    initializeVideo();
    loadAdvertise();

    super.initState();
  }

  Future<void> initializeVideo() async {
    final post = postsController.post;

    videoUtils = VideoUtils(post: post);

    await videoUtils.getChewieControllerAsync(autoPlay: !kDebugMode).then((value) {
      chewieController = value;
      setState(() {
        isLoadingVideo = false;
      });
    });
  }

  void finishVideo() {
    if (chewieController?.isPlaying ?? false) {
      chewieController?.pause();
      chewieController?.dispose();
    }
  }

  Future<void> loadAdvertise() async {
    await adMobController.loadWhatsAppRewardedAd();
    await adMobController.loadChatRewardedAd();
  }

  bool postBelongsToMe() => postsController.postBelongsToMe();

  void onLeaveScreen() {
    finishVideo();
    if (!postsController.isInReviewMode) {
      postsController.clearForm();
      Get.offAllNamed(Routes.home);
    }
  }

  double toolBarHeight(int descriptionLength) {
    return Dimensions.getDimensBasedOnDeviceHeight(
      smaller: (Get.height / 3.5) - (descriptionLength / 4) - 16.0.h,
      xSmaller: (Get.height / 4.5) - (descriptionLength / 4),
      bigger: (Get.height / 3.5) - (descriptionLength / 4),
      medium: (Get.height / 3) - (descriptionLength / 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Post post = postsController.post;
    final petCaracteristics = PetCaracteristics.petCaracteristics((post as Pet));
    final description = post.description;
    final reward = post.reward;

    return WillPopScope(
      onWillPop: () async {
        onLeaveScreen();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            _background(),
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: SliverSafeArea(
                      top: false,
                      bottom: false,
                      sliver: SliverAppBar(
                        flexibleSpace: _showImagesAndVideos(boxHeight: Get.height, context: context),
                        toolbarHeight: toolBarHeight(description.length),
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        expandedHeight: Get.height / 1.6,
                        shadowColor: AppColors.white,
                        floating: true,
                        pinned: true,
                      ),
                    ),
                  ),
                ];
              },
              body: ListView(
                key: UniqueKey(),
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  right: Dimensions.getDimensBasedOnDeviceHeight(
                    smaller: 0.0.w,
                    medium: 4.0.w,
                    bigger: 0.0.w,
                  ),
                ),
                children: [
                  _postTitle(post.name!),
                  AdBanner(
                    margin: EdgeInsets.only(top: 4.0.h),
                    adId: systemController.getAdMobBlockID(
                      blockName: AdMobBlockName.postDetailScreenAdBlockId,
                      type: AdMobType.banner,
                    ),
                  ),
                  Visibility(
                    replacement: _petCaracteristicsGrid(petCaracteristics),
                    child: _petCaracteristics(petCaracteristics),
                    visible: authController.userExists,
                  ),
                  VerifyAccountWarningInterstitial(
                    margin: EdgeInsets.symmetric(vertical: 8.0.h),
                    isHiddingContactInfo: true,
                    child: Column(
                      children: [
                        _description(description),
                        _disappearedReward(reward),
                        _address(),
                        postDetailBottomView(),
                      ],
                    ),
                    action: onLeaveScreen,
                  ),
                ],
              ),
            ),
            Positioned(child: BackButton(color: AppColors.white), left: 8.0.w, top: 32.0.h),
            _loadingBlur()
          ],
        ),
      ),
    );
  }

  Container _background() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetHandle.imageProvider(ImageAssets.bones2),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _postTitle(String petName) {
    return Container(
      child: Card(
        elevation: 16.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12.0.h),
            bottomLeft: Radius.circular(12.0.h),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeTexts.autoSizeText18(
                    '${Formatters.cuttedText(OtherFunctions.replacePhoneNumberWithStars('$petName'), size: 18)}',
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            Spacer(),
            Obx(
              () => Visibility(
                visible: !postsController.isInReviewMode &&
                    authController.userExists &&
                    systemController.properties.internetConnected,
                child: Row(
                  children: [
                    _dennouncePostButton(),
                    SizedBox(width: 4.0.w),
                    AddRemoveFavorite(
                      show: systemController.properties.internetConnected,
                      post: postsController.post,
                      isRemoveButton: false,
                      tiny: true,
                    ),
                    SizedBox(width: 4.0.w),
                  ],
                ),
              ),
            ),
            _shareButton(),
            SizedBox(width: 8.0.h)
          ],
        ),
      ),
    );
  }

  Widget _shareButton() {
    return Obx(
      () => Visibility(
        replacement: postsController.isInReviewMode ? SizedBox.shrink() : NoConnectionTextInfo(),
        visible: !postsController.isInReviewMode && systemController.properties.internetConnected,
        child: GestureDetector(
          onTap: () async {
            final success = await postsController.sharePost();

            if (!success) {
              showPopUp(message: AppStrings.unableToGenerateSharebleFile, backGroundColor: AppColors.danger);
            }
          },
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0.h)),
            child: PostActionButton(icon: Icons.share),
          ),
        ),
      ),
    );
  }

  Widget _dennouncePostButton() {
    return DennounceButton(
      onTap: () {
        postDennounceController.updatePostDennounce(
          PostDennounceEnum.dennouncedPost,
          postsController.post,
        );

        showsDennouncePopup(content: PostDennounceScreen());
      },
    );
  }

  Widget _showImagesAndVideos({required BuildContext context, required double boxHeight}) {
    final PageController _pageController = PageController();
    final post = postsController.post;
    final photosQty = post.photos.length;
    final hasVideo = post.video != null;

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
          bottom: Dimensions.getDimensBasedOnDeviceHeight(
            smaller: 48.0.h,
            bigger: 56.0.h,
            medium: 64.0.h,
          ),
          left: 8.0.w,
          child: InkWell(
            onTap: () {
              if (postBelongsToMe()) {
                Get.toNamed(Routes.settings);
              } else {
                OtherFunctions.navigateToAnnouncerDetail(postsController.post.owner!);
              }
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
            radius: 10.0.h,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: AssetHandle.getImage(
                postsController.post.owner!.avatar,
                isUserImage: true,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 18.0.h, left: 8.0.h),
            child: AutoSizeTexts.autoSizeText10(
              OtherFunctions.firstCharacterUpper(announcerName()).trim(),
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  String announcerName() {
    final owner = postsController.post.owner!;
    late String userName = postBelongsToMe() ? 'Você' : owner.displayName ?? 'Usuário do Tiutiu';

    return userName;
  }

  Container _images({required PageController pageController, required double boxHeight}) {
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
      return Visibility(
        visible: !isLoadingVideo,
        child: TiuTiuVideoPlayer(
          aspectRatio: chewieController!.videoPlayerController.value.aspectRatio,
          chewieController: chewieController!,
        ),
        replacement: Center(child: LoadingVideo()),
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
        child: AssetHandle.getImage(photos.elementAt(index), fit: BoxFit.cover),
        width: double.infinity,
      ),
    );
  }

  Widget _dotsIndicator({required PageController pageController, required int length}) {
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
      margin: EdgeInsets.only(top: 2.0.h),
      height: 64.0.h,
      child: ListView.builder(
        key: UniqueKey(),
        itemCount: petCaracteristics.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, int index) {
          return PetOtherCaracteristicsCard(
            content: petCaracteristics[index].content,
            title: petCaracteristics[index].title,
            icon: petCaracteristics[index].icon,
          );
        },
      ),
    );
  }

  Widget _petCaracteristicsGrid(List<PetCaracteristics> petCaracteristics) {
    return Container(
      margin: EdgeInsets.only(top: 4.0.h),
      height: Get.width / 2,
      child: GridView.count(
        crossAxisCount: 2,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: petCaracteristics.map((carac) {
          return PetOtherCaracteristicsCard(
            content: carac.content,
            title: carac.title,
            icon: carac.icon,
          );
        }).toList(),
      ),
    );
  }

  Widget _description(String? description) {
    return Visibility(
      visible: description != null,
      child: CardContent(
        title: PostDetailsStrings.description,
        content: OtherFunctions.replacePhoneNumberWithStars(description ?? ''),
      ),
    );
  }

  Widget _disappearedReward(String? reward) {
    return Visibility(
      visible: (postsController.post as Pet).disappeared,
      child: CardContent(
        title: PostDetailsStrings.reward,
        content: Formatters.currencyFormmater(reward) ?? '',
      ),
    );
  }

  CardContent _address() {
    final post = postsController.post;

    final describedAddress = post.describedAddress.isNotEmptyNeighterNull()
        ? '\n\n${OtherFunctions.replacePhoneNumberWithStars(post.describedAddress)}'
        : '';

    final showIcon = !post.describedAddress.isNotEmptyNeighterNull() && !(post as Pet).disappeared;

    return CardContent(
      icon: showIcon ? Icons.launch : null,
      content: (post as Pet).disappeared ? (post).lastSeenDetails : '${post.city} - ${post.state} $describedAddress',
      title: post.disappeared
          ? PostDetailsStrings.lastSeen
          : PostDetailsStrings.whereIsIt(
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

  Widget ownerAdcontact() {
    final Post post = postsController.post;
    return Container(
      margin: EdgeInsets.only(bottom: 8.0.h, right: 4.0.w, left: 4.0.w, top: 4.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonWide(
            padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.w),
            onPressed: () {
              chatController.handleContactTapped(
                contactType: ContactType.chat,
                onAdWatched: () async {
                  chatController.startsChatWith(
                    myUserId: tiutiuUserController.tiutiuUser.uid!,
                    user: post.owner!,
                  );
                },
              );
            },
            color: AppColors.secondary,
            text: AppStrings.chatWithAnnouncer,
            isToExpand: true,
            icon: Icons.forum,
          ),
          ButtonWide(
            padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.w),
            icon: FontAwesomeIcons.whatsapp,
            text: AppStrings.callInWhatsapp,
            color: AppColors.primary,
            isToExpand: true,
            onPressed: () async {
              chatController.handleContactTapped(
                contactType: ContactType.whatsapp,
                onAdWatched: () async {
                  await Launcher.openWhatsApp(number: post.owner!.phoneNumber!);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget backReviewAndUploadPost() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0.h),
      child: ButtonWide(
        text: postsController.isEditingPost ? PostFlowStrings.postUpdate : PostFlowStrings.post,
        onPressed: () {
          postsController.backReviewAndPost();
        },
        isToExpand: true,
        rounded: false,
      ),
    );
  }

  Widget editPostButtons() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0.h),
      child: Column(
        children: [
          SimpleTextButton(
            backgroundColor: AppColors.warning,
            text: PostFlowStrings.editAd,
            textColor: AppColors.black,
            icon: Icons.edit,
            onPressed: () {
              postsController.isEditingPost = true;
              Get.offNamed(Routes.initPostFlow);
            },
          ),
          SimpleTextButton(
            backgroundColor: AppColors.white,
            text: PostFlowStrings.deleteAd,
            textColor: AppColors.danger,
            onPressed: () async {
              final isToDelete = await postsController.shwoDeletePostPopup();

              if (isToDelete) {
                postsController.deletePost().then((_) {}).then((_) async {
                  Get.back();
                  ScaffoldMessenger.of(context).showSnackBar(TiuTiuSnackBar(message: PostFlowStrings.adDeleted));
                });
              }
            },
          )
        ],
      ),
    );
  }

  Widget editOrContact() {
    final myUserId = tiutiuUserController.tiutiuUser.uid;
    final postOwnerId = postsController.post.ownerId;

    final showAdContact = !postsController.isEditingPost && !postsController.isInReviewMode && postOwnerId != myUserId;

    return Obx(
      () => Visibility(
        replacement: editPostButtons(),
        child: ownerAdcontact(),
        visible: showAdContact,
      ),
    );
  }

  Widget postDetailBottomView() {
    return Obx(
      () => Visibility(
        visible: postsController.isInReviewMode,
        replacement: editOrContact(),
        child: backReviewAndUploadPost(),
      ),
    );
  }

  Obx _loadingBlur() {
    return Obx(
      () => LoadDarkScreen(
        message: postsController.uploadingPostText,
        visible: postsController.isLoading,
      ),
    );
  }
}
