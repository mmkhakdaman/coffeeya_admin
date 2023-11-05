import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:coffeeya_admin/product/widgets/category/create_category_dialog.dart';
import 'package:coffeeya_admin/product/widgets/category/edit_categorie_buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListWidget extends StatelessWidget implements PreferredSizeWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (previous, current) => previous.categories != current.categories,
      builder: (context, state) {
        return SizedBox(
          height: 54,
          child: Row(
            children: [
              Material(
                color: Colors.white,
                child: SizedBox(
                  height: double.maxFinite,
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          showGeneralDialog(
                            context: context,
                            transitionBuilder: (context, a1, a2, widget) {
                              return Opacity(
                                opacity: a1.value,
                                child: widget,
                              );
                            },
                            pageBuilder: (dialogContext, animation1, animation2) => BlocProvider.value(
                              value: BlocProvider.of<CategoryCubit>(context),
                              child: const CreateCategoryDialog(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.grey[900],
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'دسته جدید',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[900],
                                    ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBar(
                  isScrollable: true,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey[900],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  tabs: [
                    const Tab(
                      text: 'همه',
                    ),
                    for (var category in state.categories)
                      Tab(
                        text: category.title,
                      ),
                  ],
                ),
              ),
              Material(
                color: Colors.white,
                child: InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      enableDrag: false,
                      isScrollControlled: true,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      builder: (bottomSheetContext) {
                        return BlocProvider.value(
                          value: BlocProvider.of<CategoryCubit>(context),
                          child: const EditCategoriesButtomSheet(),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: double.maxFinite,
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(
                      Icons.settings,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(54);
}
