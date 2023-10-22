import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:coffeeya_admin/product/models/category_model.dart';
import 'package:coffeeya_admin/product/models/product_model.dart';
import 'package:coffeeya_admin/product/repositories/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/src/form_builder.dart';

import '../../core/models/error.dart';

class CategoryState {
  final List<CategoryModel> categories;
  final bool isSubmitting;

  CategoryState({
    this.categories = const [],
    this.isSubmitting = false,
  });

  CategoryState copyWith({
    List<CategoryModel>? categories,
    bool? isSubmitting,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isSubmitting: isSubmitting ?? this.isSubmitting,
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

  Future<bool> storeCategory({required GlobalKey<FormBuilderState> formKey}) async {
    emit(
      state.copyWith(isSubmitting: true),
    );
    if (formKey.currentState!.saveAndValidate()) {
      return await CategoryRepository.createCategory(formKey.currentState?.value).then(
        (value) {
          addCategory(category: value.data);
          return true;
        },
      ).catchError(
        (e) {
          if (e is ResponseModel) setFormError(error: e.error!, formKey: formKey);
          return false;
        },
      ).whenComplete(
        () => emit(
          state.copyWith(isSubmitting: false),
        ),
      );
    }
    if (state.isSubmitting) {
      emit(
        state.copyWith(isSubmitting: false),
      );
    }

    return false;
  }
}
