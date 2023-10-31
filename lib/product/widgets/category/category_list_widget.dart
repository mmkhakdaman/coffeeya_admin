import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:coffeeya_admin/product/widgets/category/create_category_dialog.dart';
import 'package:coffeeya_admin/product/widgets/category/edit_categorie_buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListWidget extends StatelessWidget implements PreferredSizeWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      height: 54,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: context.read<CategoryCubit>().scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      key: const Key('create_category_button'),
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
                    const SizedBox(
                      width: 10,
                    ),
                    BlocBuilder<CategoryCubit, CategoryState>(
                      buildWhen: (previous, current) => previous.selectedCategory != current.selectedCategory,
                      builder: (context, state) {
                        return Row(
                          children: [
                            InkWell(
                              key: const GlobalObjectKey('all_category_button'),
                              onTap: () {
                                context.read<CategoryCubit>().clearSelectedCategory();
                              },
                              borderRadius: BorderRadius.circular(100),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: state.selectedCategory == 0 ? Colors.grey[900] : Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  'همه',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: state.selectedCategory == 0 ? Colors.white : Colors.grey[900],
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            BlocBuilder<CategoryCubit, CategoryState>(
                              buildWhen: (previous, current) => previous.categories != current.categories || previous.selectedCategory != current.selectedCategory,
                              builder: (context, state) {
                                if (state.categories.isEmpty) {
                                  return const SizedBox();
                                }
                                return Row(
                                  children: [
                                    for (var category in state.categories) ...[
                                      InkWell(
                                        key: GlobalObjectKey('category_${category.id}_button'),
                                        onTap: () {
                                          context.read<CategoryCubit>().selectCategory(category.id);
                                        },
                                        borderRadius: BorderRadius.circular(100),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: state.selectedCategory == category.id ? Colors.grey[900] : Colors.transparent,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: Text(
                                            category.title,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: state.selectedCategory == category.id ? Colors.white : Colors.grey[900],
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
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
              hoverColor: Colors.transparent,
              child: const Icon(
                Icons.settings,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(54);
}
