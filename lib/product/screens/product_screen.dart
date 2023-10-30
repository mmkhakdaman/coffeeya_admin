import 'package:animate_do/animate_do.dart';
import 'package:coffeeya_admin/auth/repositories/auth.dart';
import 'package:coffeeya_admin/core/layout/home/context.dart';
import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:coffeeya_admin/product/models/product_mode.dart';
import 'package:coffeeya_admin/product/widgets/category_list_widget.dart';
import 'package:coffeeya_admin/product/widgets/product/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeContextLayout(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/product/create');
        },
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[500],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'محصول جدید',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
      child: BlocProvider(
        create: (context) => CategoryCubit(
          CategoryState(),
        ),
        child: ProductListWidget(),
      ),
    );
  }
}

class ProductListWidget extends StatelessWidget {
  Widget headList(innerBoxIsScrolled) {
    return SliverAppBar(
      toolbarHeight: 56.0,
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      // forceElevated: innerBoxIsScrolled,
      shape: const Border(bottom: BorderSide(color: Colors.black12)),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        InkWell(
          onTap: () async {
            await AuthRepository.login(phone: "9944432552", password: "password");
            // Navigator.of(context).pushNamed('/');
          },
          child: Icon(
            Icons.search,
            color: Colors.grey[400],
            size: 24,
          ),
        ),
      ],
      // automaticallyImplyLeading: false,
      title: const Text(
        "محصولات",
        style: TextStyle(color: Colors.black),
      ),
      bottom: const CategoryListWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[headList(innerBoxIsScrolled)];
      },
      body: BlocBuilder<CategoryCubit, CategoryState>(
        buildWhen: (previous, current) => previous.selectedCategory != current.selectedCategory || previous.categories != current.categories,
        builder: (context, state) {
          final products = state.selectedCategoryProducts;
          if (products.isEmpty) {
            return const Center(
              child: Text("محصولی ایجاد نشده:)"),
            );
          } else {
            return ListView(
              shrinkWrap: true,
              children: [
                // map products with space
                ...products.map(
                  (e) => ProductItemWidget(
                    product: e,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
