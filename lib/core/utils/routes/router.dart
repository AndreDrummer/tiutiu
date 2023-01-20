import 'package:tiutiu/features/delete_account/views/delete_account_screen.dart';
import 'package:tiutiu/features/talk_with_us/views/talk_with_us.dart';
import 'package:tiutiu/features/auth/views/email_and_password.dart';
import 'package:tiutiu/core/system/views/loading_start_screen.dart';
import 'package:tiutiu/features/posts/flow/init_post_flow.dart';
import 'package:tiutiu/features/more/views/edit_profile.dart';
import 'package:tiutiu/features/support/views/support_us.dart';
import 'package:tiutiu/features/posts/views/post_detail.dart';
import 'package:tiutiu/features/auth/views/start_screen.dart';
import 'package:tiutiu/core/widgets/connection_handler.dart';
import 'package:tiutiu/features/auth/views/verify_email.dart';
import 'package:tiutiu/features/auth/views/verify_phone.dart';
import 'package:tiutiu/features/auth/views/auth_hosters.dart';
import 'package:tiutiu/features/chat/views/chat_screen.dart';
import 'package:tiutiu/features/chat/views/my_contacts.dart';
import 'package:tiutiu/features/saveds/screen/saveds.dart';
import 'package:tiutiu/features/support/views/social.dart';
import 'package:tiutiu/features/posts/views/my_posts.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/more/views/settings.dart';
import 'package:tiutiu/features/home/views/home.dart';
import 'package:flutter/material.dart';

class RouterGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.root:
        return MaterialPageRoute(
          builder: (_) => LoadingStartScreen(),
        );
      case Routes.startScreen:
        return MaterialPageRoute(
          builder: (_) => StartScreen(),
        );
      case Routes.authHosters:
        return MaterialPageRoute(
          builder: (_) => AuthHosters(),
        );
      case Routes.emailAndPassword:
        return MaterialPageRoute(
          builder: (_) => EmailAndPassword(),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => ConnectionScreenHandler(child: Home()),
        );
      case Routes.postDetails:
        return MaterialPageRoute(
          builder: (_) => PostDetails(),
        );
      case Routes.initPostFlow:
        return MaterialPageRoute(
          builder: (_) => InitPostFlow(),
        );
      case Routes.myPosts:
        return MaterialPageRoute(
          builder: (_) => MyPosts(),
        );
      case Routes.favorites:
        return MaterialPageRoute(
          builder: (_) => Saveds(),
        );

      case Routes.contacts:
        return MaterialPageRoute(
          builder: (_) => MyContacts(),
        );
      case Routes.chat:
        return MaterialPageRoute(
          builder: (_) => ChatScreen(loggedUserId: settings.arguments as String),
        );
      case Routes.verifyEmail:
        return MaterialPageRoute(
          builder: (_) => VerifyEmail(),
        );
      case Routes.verifyPhone:
        return MaterialPageRoute(
          builder: (_) => VerifyPhone(),
        );

      case Routes.settings:
        return MaterialPageRoute(
          builder: (_) => Settings(),
        );
      case Routes.editProfile:
        return MaterialPageRoute(
          builder: (_) => EditProfile(),
        );
      case Routes.talkWithUs:
        return MaterialPageRoute(
          builder: (_) => TalkWithUs(),
        );
      case Routes.suportUs:
        return MaterialPageRoute(
          builder: (_) => SupportUs(),
        );
      case Routes.followUs:
        return MaterialPageRoute(
          builder: (_) => FollowUs(),
        );

      case Routes.deleteAccount:
        return MaterialPageRoute(
          builder: (_) => DeleteAccountScreen(),
        );
    }
    return null;
  }
}
