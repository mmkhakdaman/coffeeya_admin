import 'package:coffeeya_admin/product/models/category_model.dart';
import 'package:coffeeya_admin/product/models/product_mode.dart';
import 'package:coffeeya_admin/product/repositories/category_repository.dart';
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
    if (selectedCategory == 0) return categories.map((e) => e.products ?? []).expand((element) => element).toList();
    return categories.firstWhere((element) => element.id == selectedCategory).products ?? [];
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
          categories: value,
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
}
