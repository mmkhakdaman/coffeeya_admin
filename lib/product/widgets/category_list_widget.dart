import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
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
                            onTap: () {
                              context.read<CategoryCubit>().clearSelectedCategory();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: state.selectedCategory == 0 ? Colors.grey[800] : Colors.transparent,
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
                                      onTap: () {
                                        context.read<CategoryCubit>().selectCategory(category.id);
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: state.selectedCategory == category.id ? Colors.grey[800] : Colors.transparent,
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
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {},
            child: const Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
    );
  }
}
