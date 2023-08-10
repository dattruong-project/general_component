import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class FormBuilderHTMLComponent extends StatelessWidget {
  const FormBuilderHTMLComponent(
      {super.key,
      required this.width,
      required this.height,
      this.initialSourceType = SourceType.url,
      this.jsContent = const {},
      this.dartCallBacks = const {},
      this.initialContent = 'about:blank',
      this.ignoreAllGestures = false,
      this.javascriptMode = JavascriptMode.unrestricted,
      this.initialMediaPlaybackPolicy =
          AutoMediaPlaybackPolicy.requireUserActionForAllMediaTypes,
      this.onPageStarted,
      this.onPageFinished,
      this.navigationDelegate,
      this.onWebResourceError,
      this.onWebViewCreated,
      this.webSpecificParams = const WebSpecificParams(),
      this.mobileSpecificParams = const MobileSpecificParams()});

  final String initialContent;
  final SourceType initialSourceType;
  final double width;
  final double height;
  final Set<EmbeddedJsContent> jsContent;
  final Set<DartCallback> dartCallBacks;
  final bool ignoreAllGestures;
  final JavascriptMode javascriptMode;
  final AutoMediaPlaybackPolicy initialMediaPlaybackPolicy;
  final void Function(String src)? onPageStarted;
  final void Function(String src)? onPageFinished;
  final NavigationDelegate? navigationDelegate;
  final void Function(WebResourceError error)? onWebResourceError;
  final WebSpecificParams webSpecificParams;
  final MobileSpecificParams mobileSpecificParams;
  final Function(WebViewXController controller)? onWebViewCreated;

  @override
  Widget build(BuildContext context) {
    return WebViewX(
      width: width,
      onWebViewCreated: onWebViewCreated,
      height: height,
      initialSourceType: initialSourceType,
      jsContent: jsContent,
      dartCallBacks: dartCallBacks,
      ignoreAllGestures: ignoreAllGestures,
      initialContent: initialContent,
      javascriptMode: javascriptMode,
      initialMediaPlaybackPolicy: initialMediaPlaybackPolicy,
      onPageFinished: onPageFinished,
      onPageStarted: onPageStarted,
      navigationDelegate: navigationDelegate,
      onWebResourceError: onWebResourceError,
      webSpecificParams: webSpecificParams,
      mobileSpecificParams: mobileSpecificParams,
    );
  }
}
