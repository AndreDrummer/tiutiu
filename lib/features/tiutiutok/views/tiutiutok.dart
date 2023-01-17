import 'package:tiutiu/features/tiutiutok/widgets/empty_tiutiutok.dart';
import 'package:tiutiu/features/tiutiutok/widgets/buttons_aside.dart';
import 'package:tiutiu/features/tiutiutok/widgets/post_details.dart';
import 'package:tiutiu/features/tiutiutok/widgets/video_widget.dart';
import 'package:tiutiu/features/posts/widgets/loading_blur.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TiutiuTok extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late Post post;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox.expand(
        child: Obx(() {
          final postsWithVideo = postsController.posts.where((post) => post.video != null).toList();

          if (postsWithVideo.isEmpty) return EmptyTiuTiuTokScreen();

          return Padding(
            padding: EdgeInsets.only(bottom: 44.0.h),
            child: CarouselSlider.builder(
              itemCount: postsWithVideo.length,
              itemBuilder: (context, index, realIndex) {
                post = postsWithVideo[index];
                postsController.increasePostViews(post.uid);

                return Stack(
                  children: [
                    VideoWidget(post: post),
                    ButtonsAside(post: post),
                    PostDetails(post: post),
                    LoadingBlur(),
                  ],
                );
              },
              options: CarouselOptions(
                onPageChanged: (index, reason) async {
                  if (!authController.userExists) {
                    await likesController.getLikesSavedOnDevice();
                  }
                },
                scrollDirection: Axis.vertical,
                autoPlayCurve: Curves.easeIn,
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
                disableCenter: true,
                viewportFraction: 1,
                autoPlay: false,
              ),
            ),
          );
        }),
      ),
    );
  }
}
