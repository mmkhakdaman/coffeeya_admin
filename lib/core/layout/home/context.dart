import 'package:flutter/material.dart';

class HomeContextLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const HomeContextLayout({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
