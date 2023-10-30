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
      child: Container(
        color: Colors.grey[100],
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 24,
                  ),
                  Text(
                    'محصولات',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  InkWell(
                    onTap: () async {
                      await AuthRepository.login(phone: "9944432552", password: "password");
                      if (context.mounted) Navigator.of(context).pushNamed('/');
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocProvider(
                create: (context) => CategoryCubit(
                  CategoryState(),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: const CategoryListWidget(),
                    ),
                    const ProductListWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (previous, current) => previous.selectedCategory != current.selectedCategory || previous.categories != current.categories,
      builder: (context, state) {
        final products = state.selectedCategoryProducts;
        if (products.isEmpty) {
          return const Center(
            child: Text("محصولی ایجاد نشده:)"),
          );
        } else {
          return Container(
            height: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                // map products with space
                ...products.map(
                  (e) => Column(
                    children: [
                      ProductItemWidget(
                        product: e,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
