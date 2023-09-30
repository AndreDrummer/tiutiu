import 'package:tiutiu/core/widgets/animated_text_icon_button.dart';
import 'package:tiutiu/features/posts/widgets/ad_picture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddImage extends StatefulWidget {
  const AddImage({
    super.key,
    required this.onRemovePictureOnIndex,
    required this.onAddPictureOnIndex,
    required this.addedImagesQty,
    required this.maxImagesQty,
    required this.hasError,
    required this.images,
  });

  final Function(dynamic image, int index) onAddPictureOnIndex;
  final Function(int index) onRemovePictureOnIndex;
  final int addedImagesQty;
  final int maxImagesQty;
  final bool hasError;
  final List images;

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> with Pickers {
  late ScrollController _picturesListController;
  late int photosFrameQty;

  @override
  void initState() {
    photosFrameQty = widget.images.isEmpty ? 1 : widget.images.length;
    _picturesListController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _picturesListController.dispose();

    super.dispose();
  }

  void increasePhotosQty() {
    if (photosFrameQty < widget.maxImagesQty) {
      setState(() {
        photosFrameQty = photosFrameQty + 1;
      });
    }
  }

  void decreasePhotosQty() {
    if (photosFrameQty > 1) {
      setState(() {
        photosFrameQty = photosFrameQty - 1;
      });
    }
  }

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

  Widget _insertPicturesLabel() {
    return OneLineText(
      widgetAlignment: photosFrameQty == 1 ? Alignment.center : Alignment(-0.9, 1),
      text:
          '${AppLocalizations.of(context)!.insertAtLeastOnePicture} (${widget.addedImagesQty} / ${widget.maxImagesQty})',
      color: widget.hasError ? AppColors.danger : null,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _picturesList(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.0.w),
      height: Get.height > 999 ? 400.0.h : 212.0.h,
      child: ListView.builder(
        controller: _picturesListController,
        scrollDirection: Axis.horizontal,
        itemCount: photosFrameQty,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          final photosQty = widget.addedImagesQty;
          final photos = widget.images;

          return AdPicture(
            imagePath: photosQty < photosFrameQty && (index == photosFrameQty - 1) ? null : photos[index],
            color: AppColors.primary,
            onPicturedRemoved: () {
              widget.onRemovePictureOnIndex(index);
              decreasePhotosQty();
            },
            onAddPicture: () {
              pickAnAsset(
                context: context,
                onAssetPicked: (image) {
                  widget.onAddPictureOnIndex(
                    image,
                    index,
                  );
                },
                pickerAssetType: PickerAssetType.photo,
              );
            },
            hasError: widget.hasError,
          );
        },
      ),
    );
  }

  Widget _addPicturesButton() {
    final photosQty = widget.addedImagesQty;

    return AnimatedTextIconButton(
      showCondition: (photosQty == photosFrameQty) && photosFrameQty < widget.maxImagesQty,
      textLabel: AppLocalizations.of(context)!.addMorePictures,
      onPressed: () {
        increasePhotosQty();
        _picturesListController.animateTo(
          duration: Duration(milliseconds: 250),
          (Get.width * photosFrameQty) * .8,
          curve: Curves.ease,
        );
      },
    );
  }
}
