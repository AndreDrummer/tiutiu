import 'package:tiutiu/features/delete_account/views/delete_account_screen.dart';
import 'package:tiutiu/features/support/views/social.dart';
import 'package:tiutiu/features/talk_with_us/views/talk_with_us.dart';
import 'package:tiutiu/features/auth/views/email_and_password.dart';
import 'package:tiutiu/features/favorites/screen/favorites.dart';
import 'package:tiutiu/features/posts/flow/init_post_flow.dart';
import 'package:tiutiu/features/support/views/support_us.dart';
import 'package:tiutiu/features/posts/views/post_detail.dart';
import 'package:tiutiu/features/auth/views/start_screen.dart';
import 'package:tiutiu/features/auth/views/auth_hosters.dart';
import 'package:tiutiu/features/chat/views/chat_screen.dart';
import 'package:tiutiu/features/chat/views/my_contacts.dart';
import 'package:tiutiu/features/posts/views/my_posts.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/system/app_bootstrap.dart';
import 'package:tiutiu/features/home/views/home.dart';
import 'package:tiutiu/core/widgets/about.dart';
import 'package:flutter/material.dart';

class RouterGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.root:
        return MaterialPageRoute(
          builder: (_) => AppBootstrap(),
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
          builder: (_) => Home(),
        );
      case Routes.postDetails:
        return MaterialPageRoute(
          builder: (_) => PostDetails(),
        );
      case Routes.initPostFlow:
        return MaterialPageRoute(
          builder: (_) => InitPostFlow(),
        );
      case Routes.favorites:
        return MaterialPageRoute(
          builder: (_) => Favorites(),
        );
      case Routes.myPosts:
        return MaterialPageRoute(
          builder: (_) => MyPosts(),
        );
      case Routes.contacts:
        return MaterialPageRoute(
          builder: (_) => MyContacts(),
        );
      case Routes.chat:
        return MaterialPageRoute(
          builder: (_) => ChatScreen(),
        );
      case Routes.about:
        return MaterialPageRoute(
          builder: (_) => About(),
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
