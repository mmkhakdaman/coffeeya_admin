import 'package:coffeeya_admin/auth/repositories/auth.dart';
import 'package:coffeeya_admin/core/layout/home/context.dart';
import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:coffeeya_admin/product/models/product_mode.dart';
import 'package:coffeeya_admin/product/widgets/category_list_widget.dart';
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
        child: SingleChildScrollView(
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
                        Navigator.of(context).pushNamed('/');
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
              BlocProvider(
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
                    BlocBuilder<CategoryCubit, CategoryState>(
                      buildWhen: (previous, current) => previous.selectedCategory != current.selectedCategory || previous.categories != current.categories,
                      builder: (context, state) {
                        final products = state.selectedCategoryProducts;
                        if (products.isEmpty) {
                          return const Center(
                            child: Text("محصولی ایجاد نشده:)"),
                          );
                        } else {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            scrollDirection: Axis.vertical,
                            child: Column(
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductItemWidget extends StatefulWidget {
  const ProductItemWidget({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/product/${widget.product.id}/edit');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.product.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.product.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isActive = !isActive;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isActive ? Colors.green : Colors.grey,
                            ),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  left: isActive ? 16 : 0,
                                  right: isActive ? 0 : 16,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: isActive
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 16,
                                          )
                                        : const Icon(
                                            Icons.close,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'تغییر وضعیت',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          NumberFormat.decimalPattern().format(widget.product.price),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'تومان',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
