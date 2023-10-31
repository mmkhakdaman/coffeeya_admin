import 'package:coffeeya_admin/auth/repositories/auth.dart';
import 'package:coffeeya_admin/core/layout/home/context.dart';
import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:coffeeya_admin/product/widgets/category/category_list_widget.dart';
import 'package:coffeeya_admin/product/widgets/product/create_product_buttom_sheet.dart';
import 'package:coffeeya_admin/product/widgets/product/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    showCreateProductButtomSheet() {
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        builder: (bottomSheetContext) {
          return const CreateProductButtomSheet();
        },
      );
    }

    return BlocProvider(
      create: (context) => CategoryCubit(
        CategoryState(),
      ),
      child: HomeContextLayout(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            showCreateProductButtomSheet();
          },
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
        child: const ProductListWidget(),
      ),
    );
  }
}

class ProductListWidget extends StatefulWidget {
  const ProductListWidget({super.key});

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  Widget headList(innerBoxIsScrolled) {
    return SliverAppBar(
      toolbarHeight: 50,
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      shape: const Border(bottom: BorderSide(color: Colors.black12)),
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      actions: [
        InkWell(
          onTap: () async {
            await AuthRepository.login(phone: "9944432552", password: "password");
          },
          child: Icon(
            Icons.search,
            color: Colors.grey[400],
            size: 24,
          ),
        ),
      ],
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
          return DefaultTabController(
            length: state.categories.length + 1,
            child: Builder(
              builder: (BuildContext context) {
                final TabController tabController = DefaultTabController.of(context);
                tabController.addListener(() {
                  if (!tabController.indexIsChanging) {
                    if (tabController.index == 0) {
                      context.read<CategoryCubit>().clearSelectedCategory();
                      context.read<CategoryCubit>().scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                    } else {
                      final selectedId = state.categories[tabController.index - 1].id;
                      context.read<CategoryCubit>().selectCategory(selectedId);

                      // var selectedCategoryButtonObject = ObjectKey("category_${selectedId}_button");

                      // print(selectedCategoryButtonObject);
                      // if (selectedCategoryButtonObject != null) {
                      //   context.read<CategoryCubit>().scrollController.animateTo(
                      //         selectedCategoryButtonObject.findRenderObject()!.paintBounds.right,
                      //         duration: const Duration(milliseconds: 300),
                      //         curve: Curves.easeInOut,
                      //       );
                      // }
                    }
                  }
                });
                tabController.animateTo(state.selectedCategoryIndex);
                return TabBarView(
                  controller: tabController,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: [
                        for (var product in state.products)
                          ProductItemWidget(
                            product: product,
                          ),
                      ],
                    ),
                    for (var category in state.categories)
                      if (category.products!.isEmpty)
                        const Center(
                          child: Text("محصولی ایجاد نشده:)"),
                        )
                      else
                        ListView(
                          shrinkWrap: true,
                          children: [
                            for (var product in category.products ?? [])
                              ProductItemWidget(
                                product: product,
                              ),
                          ],
                        ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
