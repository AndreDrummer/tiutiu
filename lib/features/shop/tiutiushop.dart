import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class TiutiuShop extends StatefulWidget {
  const TiutiuShop({super.key});

  @override
  State<TiutiuShop> createState() => _TiutiuShopState();
}

class _TiutiuShopState extends State<TiutiuShop> {
  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://tiutiu.shop'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 80.0.h),
          child: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
