import 'package:coffeeya_admin/product/models/category_model.dart';
import 'package:coffeeya_admin/product/models/product_mode.dart';
import 'package:coffeeya_admin/product/repositories/category_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryState {
  final List<CategoryModel> categories;
  final int selectedCategory;

  CategoryState({
    this.categories = const [],
    this.selectedCategory = 0,
  });

  CategoryState copyWith({
    List<CategoryModel>? categories,
    int? selectedCategory,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  List<ProductModel> get selectedCategoryProducts {
    if (selectedCategory == 0) return products;

    return categories.firstWhere((element) => element.id == selectedCategory).products ?? [];
  }

  List<ProductModel> get products {
    return categories.map((e) => e.products ?? []).expand((element) => element).toList();
  }

  int get selectedCategoryIndex {
    if (selectedCategory == 0) return 0;

    return categories.indexWhere((element) => element.id == selectedCategory) + 1;
  }
}

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(super.initialState) {
    getCategories();
  }

  Future<void> getCategories() async {
    await CategoryRepository.categories().then(
      (value) => emit(
        state.copyWith(
          categories: value.data,
        ),
      ),
    );
  }

  selectCategory(int? id) {
    emit(
      state.copyWith(
        selectedCategory: id,
      ),
    );
  }

  clearSelectedCategory() {
    emit(
      state.copyWith(
        selectedCategory: 0,
      ),
    );
  }

  // context.read<CategoryCubit>().scrollController.currentContext!,

  final scrollController = ScrollController();

  Future<bool> createCategory(Map<String, dynamic>? value) async {
    return CategoryRepository.createCategory(value).then((value) => getCategories()).then((value) => true).catchError((e) => false);
  }
}
