import 'package:tiutiu/Widgets/loading_screen.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:flutter/material.dart';

class StreamHandler<T> extends StatelessWidget {
  const StreamHandler({
    this.showLoadingScreen = true,
    required this.loadingMessage,
    required this.buildWidget,
    required this.snapshot,
    super.key,
  });

  final Widget Function(T data) buildWidget;
  final AsyncSnapshot<T> snapshot;
  final bool showLoadingScreen;
  final String loadingMessage;

  Widget _handleSnapshotState() {
    final ConnectionState connectionState = snapshot.connectionState;

    if (snapshot.hasError) return ErrorWidget(Exception(snapshot.error));

    if (connectionState == ConnectionState.waiting && showLoadingScreen)
      return LoadingScreen(text: loadingMessage);

    if (!snapshot.hasData || snapshot.data == null) return EmptyListScreen();

    return buildWidget(snapshot.data!);
  }

  @override
  Widget build(BuildContext context) => _handleSnapshotState();
}
