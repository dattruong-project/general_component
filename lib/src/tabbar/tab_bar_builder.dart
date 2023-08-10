import 'package:flutter/material.dart';

class TabBarBuilder extends StatelessWidget {
  const TabBarBuilder({
    super.key,
    required this.length,
    this.initialIndex = 0,
    required this.child,
    this.animationDuration,
  });

  final int length;
  final int initialIndex;
  final Duration? animationDuration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: length,
        initialIndex: initialIndex,
        animationDuration: animationDuration,
        child: child);
  }
}
