import 'package:tiutiu/features/dennounce/views/post_dennounce_screen.dart';
import 'package:tiutiu/features/dennounce/widgets/dennounce_button.dart';
import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/core/widgets/pet_other_caracteristics_card.dart';
import 'package:tiutiu/features/posts/widgets/post_action_button.dart';
import 'package:tiutiu/core/pets/model/pet_caracteristics_model.dart';
import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/core/widgets/no_connection_text_info.dart';
import 'package:tiutiu/features/posts/widgets/card_content.dart';
import 'package:tiutiu/features/posts/widgets/loading_blur.dart';
import 'package:tiutiu/features/saveds/widgets/save_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/tiutiu_snackbar.dart';
import 'package:tiutiu/core/widgets/tiutiutok_icon.dart';
import 'package:tiutiu/core/widgets/dots_indicator.dart';
import 'package:tiutiu/core/widgets/warning_widget.dart';
import 'package:tiutiu/core/constants/contact_type.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/widgets/video_error.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:better_player/better_player.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class PostDetails extends StatefulWidget {
  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> with TiuTiuPopUp {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  bool hasVideo = false;

  late Post post;

  @override
  void initState() {
    post = postsController.post;
    hasVideo = post.video != null;
    if (hasVideo) initializeVideoController();

    super.initState();
  }

  @override
  void dispose() {
    if (hasVideo) _betterPlayerController.videoPlayerController!.dispose();
    super.dispose();
  }

  void initializeVideoController() {
    final isFile = postsController.post.video is File;
    final videoUrl = isFile ? postsController.post.video.path : postsController.post.video;

    _betterPlayerDataSource = BetterPlayerDataSource(
      isFile ? BetterPlayerDataSourceType.file : BetterPlayerDataSourceType.network,
      videoUrl,
      cacheConfiguration: BetterPlayerCacheConfiguration(useCache: Platform.isAndroid, key: post.video.toString()),
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoDispose: false,
        showPlaceholderUntilPlay: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          progressBarHandleColor: AppColors.primary,
          loadingColor: AppColors.primary,
          showControlsOnInitialize: false,
          enableOverflowMenu: false,
          enableProgressText: false,
          enableFullscreen: false,
          enablePlayPause: false,
          enableSkips: false,
          enableMute: false,
        ),
        errorBuilder: (context, errorMessage) => VideoError(),
        aspectRatio: .5,
        fit: BoxFit.cover,
      ),
      betterPlayerDataSource: _betterPlayerDataSource,
    );
  }

  bool postBelongsToMe() => postsController.postBelongsToMe();

  void onLeaveScreen() {
    if (!postsController.isInReviewMode) {
      postsController.clearForm();
      stopVideo();
    }
  }

  void stopVideo() {
    if (hasVideo) {
      _betterPlayerController.pause();
      _betterPlayerController.dispose();
    }
  }

  double toolBarHeight(int descriptionLength) {
    final isEditingOrReviewing = postsController.isInReviewMode || postsController.isInReviewMode;

    if (Get.height > 999) {
      return (Get.height / (isEditingOrReviewing ? 4.5 : 3.0));
    } else if ((post as Pet).disappeared) {
      return Dimensions.getDimensBasedOnDeviceHeight(
        smaller: (Get.height / (isEditingOrReviewing ? 4.9 : 5.2)) - (descriptionLength / 2),
        xSmaller: (Get.height / (isEditingOrReviewing ? 4.8 : 5.2)) - (descriptionLength / 2),
        bigger: (Get.height / (isEditingOrReviewing ? 3.2 : 3.6)) - (descriptionLength / 2),
        medium: (Get.height / (isEditingOrReviewing ? 2.9 : 3.3)) - (descriptionLength / 2),
      );
    } else {
      return Dimensions.getDimensBasedOnDeviceHeight(
        smaller: (Get.height / (isEditingOrReviewing ? 2.9 : 3.4)) - (descriptionLength / 2),
        xSmaller: (Get.height / (isEditingOrReviewing ? 3.8 : 4.4)) - (descriptionLength / 2),
        bigger: (Get.height / (isEditingOrReviewing ? 2.6 : 3.2)) - (descriptionLength / 2),
        medium: (Get.height / (isEditingOrReviewing ? 2.3 : 2.9)) - (descriptionLength / 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final petCaracteristics = PetCaracteristics.petCaracteristics(context, (post as Pet));
    final address = post.describedAddress;
    final description = post.description;
    final reward = (post as Pet).reward;

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
                        toolbarHeight: toolBarHeight(description.length + address.length),
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        expandedHeight: Get.height / 1.5,
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
                        _address(post),
                        postDetailBottomView(),
                      ],
                    ),
                    action: onLeaveScreen,
                  ),
                ],
              ),
            ),
            Positioned(child: BackButton(color: AppColors.white), left: 4.0.w, top: 40.0.h),
            LoadingBlur()
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
              padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 4.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeTexts.autoSizeText18(
                    '${Formatters.cuttedText(OtherFunctions.replacePhoneNumberWithStars('$petName'), showElipses: false)}',
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
                    _seeOnTiutiutok(),
                    _dennouncePostButton(),
                    _saveButton(),
                  ],
                ),
              ),
            ),
            _shareButton(),
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
          onTap: postsController.sharePost,
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0.h)),
            child: PostActionButton(icon: Icons.share),
          ),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Obx(
      () => Visibility(
        replacement: postsController.isInReviewMode ? SizedBox.shrink() : NoConnectionTextInfo(),
        visible: !postsController.isInReviewMode && systemController.properties.internetConnected,
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0.h)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SaveOrUnsave(
              show: systemController.properties.internetConnected,
              post: post,
              tiny: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget _seeOnTiutiutok() {
    return Visibility(
      visible: !postsController.isInReviewMode && systemController.properties.internetConnected && hasVideo,
      replacement: postsController.isInReviewMode || systemController.properties.internetConnected
          ? SizedBox.shrink()
          : NoConnectionTextInfo(),
      child: GestureDetector(
        onTap: () {
          postsController.tiutiuTokStartingVideoPostId = post.uid!;
          homeController.setTiutiuTokIndex();
          onLeaveScreen();
        },
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0.h)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TiutiutokIcon(color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _dennouncePostButton() {
    return DennounceButton(
      onTap: () {
        postDennounceController.updatePostDennounce(PostDennounceEnum.dennouncedPost, post);

        showsDennouncePopup(content: PostDennounceScreen());
      },
    );
  }

  Widget _showImagesAndVideos({required BuildContext context, required double boxHeight}) {
    final PageController _pageController = PageController();
    final photosQty = post.photos.length;
    final hasVideo = post.video != null;

    return Stack(
      children: [
        _images(
          pageController: _pageController,
          boxHeight: boxHeight,
        ),
        Positioned(
          bottom: Dimensions.getDimensBasedOnDeviceHeight(
            smaller: 36.0.h,
            bigger: 24.0.h,
            medium: 16.0.h,
          ),
          right: 0.0,
          left: 0.0,
          child: _dotsIndicator(
            length: hasVideo ? photosQty + 1 : photosQty,
            pageController: _pageController,
          ),
        ),
        Positioned(
          bottom: Dimensions.getDimensBasedOnDeviceHeight(
            smaller: 64.0.h,
            bigger: 40.0.h,
            medium: 40.0.h,
          ),
          left: Get.width / 2.8,
          child: InkWell(
            onTap: () {
              if (postBelongsToMe()) {
                Get.toNamed(Routes.settings);
              } else if (authController.userExists) {
                OtherFunctions.navigateToAnnouncerDetail(post.owner!);
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
            child: ClipOval(child: AssetHandle.getImage(post.owner!.avatar, isUserImage: true)),
            backgroundColor: Colors.transparent,
            radius: 10.0.h,
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
    final owner = post.owner!;
    late String userName = postBelongsToMe()
        ? AppLocalizations.of(context).you
        : owner.displayName ?? AppLocalizations.of(context).tiutiuUser;

    return userName;
  }

  Container _images({required PageController pageController, required double boxHeight}) {
    final photos = post.photos;

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
          } else if (hasVideo && index > 0) {
            if (_betterPlayerController.isPlaying() ?? true) _betterPlayerController.pause();
          } else if (!hasVideo) {
            return _image(photos, index);
          }
          return _image(photos, index - 1);
        },
        controller: pageController,
      ),
    );
  }

  Widget _video() {
    return SafeArea(
      child: AspectRatio(
        aspectRatio: _betterPlayerController.getAspectRatio() ?? 16 / 9,
        child: BetterPlayer(controller: _betterPlayerController),
      ),
    );
  }

  Widget _image(List photos, int index) {
    return InkWell(
      onTap: () {
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
        title: AppLocalizations.of(context).description,
        content: OtherFunctions.replacePhoneNumberWithStars(description ?? ''),
      ),
    );
  }

  Widget _disappearedReward(String? reward) {
    return Visibility(
      visible: (post as Pet).disappeared,
      child: CardContent(
        title: AppLocalizations.of(context).reward,
        content: Formatters.currencyFormmater(reward) ?? '',
      ),
    );
  }

  Widget _address(Post post) {
    final describedAddress = post.describedAddress.isNotEmptyNeighterNull()
        ? '\n\n${OtherFunctions.replacePhoneNumberWithStars(post.describedAddress)}'
        : '';

    final showIcon = post.describedAddress.isNotEmptyNeighterNull() && !(post as Pet).disappeared;

    return Stack(
      children: [
        CardContent(
          icon: showIcon ? Icons.launch : null,
          content: (post as Pet).disappeared
              ? '${post.city} - ${post.state} ${(post).lastSeenDetails}'
              : '${post.city} - ${post.state} $describedAddress',
          title: post.disappeared ? AppLocalizations.of(context).lastSeen : AppLocalizations.of(context).whereIsThisPet,
          onAction: () {
            MapsLauncher.launchCoordinates(
              post.latitude ?? 0.0,
              post.longitude ?? 0.0,
              post.name,
            );
          },
        ),
        Positioned(
          child: LottieAnimation(animationPath: AnimationsAssets.petLocationPin, size: 32.0.h),
          left: post.disappeared ? Get.width / 2.3 : Get.width / 3.5,
        )
      ],
    );
  }

  Widget ownerAdcontact(Post post) {
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
                openDesiredChat: () async {
                  chatController.setPostTalkingAbout(post.reference, post.uid);
                  chatController.startsChatWith(
                    myUserId: tiutiuUserController.tiutiuUser.uid!,
                    user: post.owner!,
                  );
                },
              );
            },
            color: AppColors.secondary,
            text: AppLocalizations.of(context).chatWithAnnouncer,
            isToExpand: true,
            icon: Icons.forum,
          ),
          ButtonWide(
            padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.w),
            icon: FontAwesomeIcons.whatsapp,
            text: AppLocalizations.of(context).callInWhatsapp,
            color: AppColors.primary,
            isToExpand: true,
            onPressed: () async {
              chatController.handleContactTapped(
                contactType: ContactType.whatsapp,
                openDesiredChat: () async {
                  final initialMessage = OtherFunctions.getWhatsAppInitialMessage(context, post);

                  await Launcher.openWhatsApp(
                    countryCode: post.owner!.countryCode ?? '+55',
                    number: post.owner!.phoneNumber!,
                    text: initialMessage,
                  );
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
        text:
            postsController.isEditingPost ? AppLocalizations.of(context).postUpdate : AppLocalizations.of(context).post,
        onPressed: () {
          stopVideo();
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
            text: AppLocalizations.of(context).editAd,
            textColor: AppColors.black,
            icon: Icons.edit,
            onPressed: () {
              postsController.isEditingPost = true;
              Get.offNamed(Routes.initPostFlow);
            },
          ),
          SimpleTextButton(
            backgroundColor: AppColors.white,
            text: AppLocalizations.of(context).deleteAd,
            textColor: AppColors.danger,
            onPressed: () async {
              final isToDelete = await postsController.shwoDeletePostPopup();

              if (isToDelete) {
                postsController.deletePost().then((_) {}).then((_) async {
                  Get.back();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(TiuTiuSnackBar(message: AppLocalizations.of(context).adDeleted));
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
    final postOwnerId = post.ownerId;

    return Obx(
      () {
        final showAdContact =
            !postsController.isEditingPost && !postsController.isInReviewMode && postOwnerId != myUserId;
        return Visibility(
          replacement: editPostButtons(),
          child: ownerAdcontact(post),
          visible: showAdContact,
        );
      },
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
}
