import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/Widgets/error_page.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:flutter/material.dart';

class AsyncHandler<T> extends StatelessWidget {
  const AsyncHandler({
    this.showLoadingScreen = true,
    required this.buildWidget,
    required this.snapshot,
    this.onErrorCallback,
    this.loadingMessage,
    this.noResultScreen,
    this.errorMessage,
    this.errorWidget,
    super.key,
  });

  final Widget Function(T data) buildWidget;
  final void Function()? onErrorCallback;
  final AsyncSnapshot<T> snapshot;
  final Widget? noResultScreen;
  final String? loadingMessage;
  final bool showLoadingScreen;
  final String? errorMessage;
  final Widget? errorWidget;

  Widget _handleSnapshotState() {
    final ConnectionState connectionState = snapshot.connectionState;

    if (snapshot.hasError)
      return errorWidget ??
          ErrorPage(
            onErrorCallback: onErrorCallback,
            errorMessage: errorMessage,
          );

    if (connectionState == ConnectionState.waiting && showLoadingScreen)
      return LoadingPage();

    if ((!snapshot.hasData || snapshot.data == null))
      return noResultScreen ?? EmptyListScreen();

    return buildWidget(snapshot.data!);
  }

  @override
  Widget build(BuildContext context) => _handleSnapshotState();
}
