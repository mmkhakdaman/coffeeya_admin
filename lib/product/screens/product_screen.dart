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
    return BlocProvider(
      create: (context) => CategoryCubit(
        CategoryState(),
      ),
      child: HomeContextLayout(
        floatingActionButton: Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () {
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
                  return BlocProvider.value(
                    value: BlocProvider.of<CategoryCubit>(context),
                    child: const CreateProductButtomSheet(),
                  );
                },
              );
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
          );
        }),
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
    return const SliverAppBar(
      toolbarHeight: 50,
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      shape: Border(bottom: BorderSide(color: Colors.black12)),
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Text(
        "محصولات",
        style: TextStyle(color: Colors.black),
      ),
      bottom: CategoryListWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (previous, current) => previous.categories != current.categories,
      builder: (context, state) {
        return DefaultTabController(
          length: state.categories.length + 1,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[headList(innerBoxIsScrolled)];
            },
            body: TabBarView(
              children: [
                ListView(
                  shrinkWrap: true,
                  controller: ScrollController(), //just add this line
                  scrollDirection: Axis.vertical,
                  children: [
                    for (var product in state.products)
                      ProductItemWidget(
                        product: product,
                      ),
                  ],
                ),
                for (var category in state.categories)
                  if (category.products != null && category.products!.isEmpty)
                    const Center(
                      child: Text("محصولی ایجاد نشده:)"),
                    )
                  else
                    ListView(
                      shrinkWrap: true,
                      controller: ScrollController(), //just add this line
                      scrollDirection: Axis.vertical,
                      children: [
                        for (var product in category.products ?? [])
                          ProductItemWidget(
                            product: product,
                          ),
                      ],
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
