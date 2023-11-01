import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (context) => CategoryCubit(
        CategoryState(),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: child,
          appBar: appBar,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
