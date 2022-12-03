import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/widgets/pet_other_caracteristics_card.dart';
import 'package:tiutiu/core/pets/model/pet_caracteristics_model.dart';
import 'package:tiutiu/features/posts/widgets/video_player.dart';
import 'package:tiutiu/core/widgets/warning_widget.dart';
import 'package:tiutiu/features/posts/widgets/card_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/widgets/load_dark_screen.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/dots_indicator.dart';
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
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

class PostDetails extends StatefulWidget {
  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> with TiuTiuPopUp {
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
  Widget build(BuildContext context) {
    final Post post = postsController.post;
    final petCaracteristics = PetCaracteristics.petCaracteristics((post as Pet));

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          chewieController?.pause();
          if (!postsController.isInReviewMode) postsController.clearForm();
          return true;
        },
        child: Scaffold(
          appBar: _appBar(post.name!),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetHandle.imageProvider(ImageAssets.bones2), fit: BoxFit.fill),
                ),
                child: FutureBuilder(
                    future: postsController.cacheVideos(),
                    builder: (context, snapshot) {
                      return ListView(
                        padding: EdgeInsets.only(
                          right: Dimensions.getDimensBasedOnDeviceHeight(
                            greaterDeviceHeightDouble: 0.0.w,
                            minDeviceHeightDouble: 4.0.w,
                          ),
                        ),
                        children: [
                          _showImagesAndVideos(
                            boxHeight: Get.height / 2.2,
                            context: context,
                          ),
                          Visibility(
                            replacement: _petCaracteristicsGrid(petCaracteristics),
                            child: _petCaracteristics(petCaracteristics),
                            visible: authController.userExists,
                          ),
                          VerifyAccountWarningInterstitial(
                            margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 8.0.h),
                            isHiddingContactInfo: true,
                            child: Column(
                              children: [
                                _description(post.description),
                                _address(),
                                postDetailBottomView(),
                              ],
                            ),
                          ),
                          LoadDarkScreen(
                            message: postsController.uploadingPostText,
                            visible: postsController.isLoading,
                          )
                        ],
                      );
                    }),
              ),
              Obx(
                () => LoadDarkScreen(
                  message: postsController.uploadingPostText,
                  visible: postsController.isLoading,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(String petName) {
    return AppBar(
      leading: BackButton(color: AppColors.white),
      title: AutoSizeTexts.autoSizeText20(
        '${PostDetailsStrings.detailsOf} ${petName.split(' ').first}',
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
      actions: [
        Visibility(
          visible: !postsController.isInReviewMode,
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

  Widget _showImagesAndVideos({required BuildContext context, required double boxHeight}) {
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
          bottom: 16.0.h,
          left: 8.0.w,
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
            padding: EdgeInsets.only(
              right: 18.0.h,
              left: 8.0.h,
            ),
            child: AutoSizeTexts.autoSizeText10(
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
      height: 56.0.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0.h),
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
        content: description ?? '',
      ),
    );
  }

  CardContent _address() {
    final post = postsController.post;

    final describedAddress = post.describedAddress.isNotEmptyNeighterNull() ? '\n\n${post.describedAddress}' : '';

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
      margin: EdgeInsets.only(
        top: Dimensions.getDimensBasedOnDeviceHeight(
          greaterDeviceHeightDouble: 2.0.h,
          minDeviceHeightDouble: 24.0.h,
        ),
        bottom: 16.0.h,
        right: 4.0.w,
        left: 4.0.w,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ButtonWide(
                  onPressed: () => chatController.startsChatWith(post.owner!),
                  color: AppColors.secondary,
                  text: AppStrings.chat,
                  isToExpand: false,
                  icon: Icons.phone,
                ),
              ),
              Expanded(
                child: ButtonWide(
                  icon: FontAwesomeIcons.whatsapp,
                  text: AppStrings.whatsapp,
                  color: AppColors.primary,
                  isToExpand: false,
                  onPressed: () async {
                    await Launcher.openWhatsApp(number: post.owner!.phoneNumber!);
                  },
                ),
              ),
            ],
          ),
          ButtonWide(
            padding: EdgeInsets.symmetric(horizontal: 8.0.h),
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
    return Column(
      children: [
        ButtonWide(
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0.w),
          text: PostFlowStrings.editAd,
          textColor: AppColors.black,
          color: AppColors.warning,
          icon: Icons.edit,
          onPressed: () {
            postsController.isEditingPost = true;
            Get.offNamed(Routes.initPostFlow);
          },
          isToExpand: true,
          rounded: false,
        ),
        ButtonWide(
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0.w),
          text: PostFlowStrings.deleteAd,
          icon: Icons.delete_forever,
          color: AppColors.danger,
          onPressed: () async {
            await showPopUp(
              message: PostFlowStrings.deleteForever,
              confirmText: AppStrings.yes,
              textColor: AppColors.black,
              mainAction: () {
                Get.back();
              },
              secondaryAction: () {
                Get.back();
                postsController.deletePost().then((myPostsCount) {
                  Get.back();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: AutoSizeTexts.autoSizeText14(PostFlowStrings.adDeleted)));
                });
              },
              barrierDismissible: false,
              title: PostFlowStrings.deleteAd,
              denyText: AppStrings.no,
              warning: true,
              error: false,
            );
          },
          isToExpand: true,
          rounded: false,
        )
      ],
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
}
