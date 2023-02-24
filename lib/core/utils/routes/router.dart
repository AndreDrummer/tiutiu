import 'package:tiutiu/features/adption_form.dart/views/what_do_you_wanna_do.dart';
import 'package:tiutiu/features/delete_account/views/delete_account_screen.dart';
import 'package:tiutiu/features/adption_form.dart/views/info_about_form.dart';
import 'package:tiutiu/features/sponsored/views/sponsored_vertical_list.dart';
import 'package:tiutiu/features/adption_form.dart/views/form_flow.dart';
import 'package:tiutiu/features/talk_with_us/views/talk_with_us.dart';
import 'package:tiutiu/features/auth/views/email_and_password.dart';
import 'package:tiutiu/core/system/views/loading_start_screen.dart';
import 'package:tiutiu/features/posts/flow/init_post_flow.dart';
import 'package:tiutiu/features/auth/views/auth_or_home.dart';
import 'package:tiutiu/features/support/views/support_us.dart';
import 'package:tiutiu/features/more/views/edit_profile.dart';
import 'package:tiutiu/features/posts/views/post_detail.dart';
import 'package:tiutiu/features/auth/views/start_screen.dart';
import 'package:tiutiu/features/auth/views/verify_email.dart';
import 'package:tiutiu/features/auth/views/verify_phone.dart';
import 'package:tiutiu/features/auth/views/auth_hosters.dart';
import 'package:tiutiu/features/chat/views/chat_screen.dart';
import 'package:tiutiu/core/widgets/connection_handler.dart';
import 'package:tiutiu/features/chat/views/my_contacts.dart';
import 'package:tiutiu/features/saveds/screen/saveds.dart';
import 'package:tiutiu/features/support/views/social.dart';
import 'package:tiutiu/features/posts/views/my_posts.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/more/views/settings.dart';
import 'package:tiutiu/features/more/views/about.dart';
import 'package:tiutiu/features/home/views/home.dart';
import 'package:flutter/material.dart';

class RouterGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.root:
        return createCustomTransition(LoadingStartScreen());
      case Routes.startScreen:
        return createCustomTransition(StartScreen());
      case Routes.authHosters:
        return createCustomTransition(AuthHosters());
      case Routes.authOrHome:
        return createCustomTransition(AuthOrHome());
      case Routes.emailAndPassword:
        return createCustomTransition(EmailAndPassword());
      case Routes.home:
        return createCustomTransition(ConnectionScreenHandler(child: Home()));
      case Routes.postDetails:
        return createCustomTransition(PostDetails());
      case Routes.initPostFlow:
        return createCustomTransition(InitPostFlow());
      case Routes.myPosts:
        return createCustomTransition(MyPosts());
      case Routes.favorites:
        return createCustomTransition(Saveds());

      case Routes.contacts:
        return createCustomTransition(MyContacts());
      case Routes.chat:
        return createCustomTransition(ChatScreen(loggedUserId: settings.arguments as String));
      case Routes.verifyEmail:
        return createCustomTransition(VerifyEmail());
      case Routes.verifyPhone:
        return createCustomTransition(VerifyPhone());

      case Routes.settings:
        return createCustomTransition(Settings());
      case Routes.about:
        return createCustomTransition(About());
      case Routes.editProfile:
        return createCustomTransition(EditProfile());
      case Routes.talkWithUs:
        return createCustomTransition(TalkWithUs());
      case Routes.suportUs:
        return createCustomTransition(SupportUs());
      case Routes.followUs:
        return createCustomTransition(FollowUs());
      case Routes.whatToDoForm:
        return createCustomTransition(WhatDoYouWannaDo());
      case Routes.infoAdoptionForm:
        return createCustomTransition(InfoAboutForm());
      case Routes.adoptionForm:
        return createCustomTransition(AdoptionFormFlow());
      case Routes.partners:
        return createCustomTransition(SponsoredVerticalList());

      case Routes.deleteAccount:
        return createCustomTransition(DeleteAccountScreen());
    }
    return null;
  }

  static PageRouteBuilder createCustomTransition(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 700),
      reverseTransitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideAnimation = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
          parent: animation,
        ));

        final slideOutAnimation = Tween(
          begin: Offset.zero,
          end: const Offset(-0.3, 0.0),
        ).animate(CurvedAnimation(
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
          parent: secondaryAnimation,
        ));

        return SlideTransition(
          position: slideAnimation,
          child: SlideTransition(
            position: slideOutAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
