import 'package:tiutiu/Widgets/animated_text_icon_button.dart';
import 'package:tiutiu/features/posts/widgets/ad_picture.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:tiutiu/core/utils/pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

ScrollController _picturesListController = ScrollController();
final int VIDEO_SECS_LIMIT = 90;

class Images extends StatelessWidget with Pickers {
  const Images({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        _insertPicturesLabel(),
        _picturesList(context),
        _addPicturesButton(),
        Spacer(),
      ],
    );
  }

  Obx _insertPicturesLabel() {
    return Obx(
      () {
        final centralize = postsController.postPhotoFrameQty == 1;
        final photosQty = postsController.post.photos.length;
        final hasError = photosQty < 1 && !postsController.formIsValid;

        return OneLineText(
          widgetAlignment: centralize ? Alignment.center : Alignment(-0.9, 1),
          text: '${PostFlowStrings.insertAtLeastOnePicture} ($photosQty / 6)',
          color: hasError ? AppColors.danger : null,
          fontWeight: FontWeight.w500,
        );
      },
    );
  }

  Widget _picturesList(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.0.w),
      height: 256.0.h,
      child: Obx(
        () {
          final hasError = postsController.post.photos.isEmpty &&
              !postsController.formIsValid;

          return ListView.builder(
            itemCount: postsController.postPhotoFrameQty,
            controller: _picturesListController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              return Obx(
                () {
                  final photosQty = postsController.post.photos.length;
                  final framesQty = postsController.postPhotoFrameQty;
                  final photos = postsController.post.photos;

                  return AdPicture(
                    imagePath: photosQty < framesQty && (index == framesQty - 1)
                        ? null
                        : photos[index],
                    color: AppColors.primary,
                    onPicturedRemoved: () {
                      postsController.removePictureOnIndex(index);
                      postsController.decreasePhotosQty();
                    },
                    onAddPicture: () {
                      pickAnAsset(
                        context: context,
                        onAssetPicked: (image) {
                          postsController.addPictureOnIndex(
                            image,
                            index,
                          );
                        },
                        pickerAssetType: PickerAssetType.photo,
                      );
                    },
                    hasError: hasError,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Obx _addPicturesButton() {
    return Obx(() {
      final photosQty = postsController.post.photos.length;
      final framesQty = postsController.postPhotoFrameQty;

      return AnimatedTextIconButton(
        showCondition: (photosQty == framesQty) && framesQty < 6,
        textLabel: PostFlowStrings.addMorePictures,
        onPressed: () {
          postsController.increasePhotosQty();
          _picturesListController.animateTo(
            (Get.width * postsController.postPhotoFrameQty) * .8,
            duration: Duration(milliseconds: 250),
            curve: Curves.ease,
          );
        },
      );
    });
  }
}
