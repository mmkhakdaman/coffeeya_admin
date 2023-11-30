import 'package:coffeeya/product/models/category_model.dart';
import 'package:coffeeya/product/models/product_model.dart';
import 'package:coffeeya/product/repositories/category_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryState {
  final List<CategoryModel> categories;

  CategoryState({
    this.categories = const [],
  });

  CategoryState copyWith({
    List<CategoryModel>? categories,
    bool? isSubmitting,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
    );
  }

  List<ProductModel> get products {
    return categories.map((e) => e.products ?? []).expand((element) => element).toList();
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

  void updateProduct({required product}) {
    var index = state.products.indexWhere((element) => element.id == product.id);
    if (index != -1) {
      state.products[index] = product;
    } else {
      state.products.add(product);
    }

    emit(
      state.copyWith(
        categories: state.categories.map((e) {
          var index = e.products!.indexWhere((element) => element.id == product.id);
          if (index != -1) {
            e.products![index] = product;
          }
          return e;
        }).toList(),
      ),
    );
  }

  void addProduct({required product}) {
    state.products.add(product);

    emit(
      state.copyWith(
        categories: state.categories.map((e) {
          if (e.id == product.categoryId) {
            e.products!.add(product);
          }
          return e;
        }).toList(),
      ),
    );
  }

  void addCategory({required category}) {
    final newCategories = List<CategoryModel>.from(state.categories);
    newCategories.add(category);

    emit(
      state.copyWith(categories: newCategories),
    );
  }
}
