import 'package:tiutiu/core/views/user_feedback_screen.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          UserFeedbackScreen(
            feedbackMessage: AppStrings.noConnection,
            showLogoutOption: false,
            icon: Icons.wifi_off,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.black,
              image: DecorationImage(
                image: AssetImage(ImageAssets.noConnection),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
