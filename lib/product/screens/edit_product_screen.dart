import 'package:coffeeya_admin/core/models/error.dart';
import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:coffeeya_admin/product/models/category_model.dart';
import 'package:coffeeya_admin/product/models/product_model.dart';
import 'package:coffeeya_admin/product/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class EditProductScreen extends StatefulWidget {
  final String id;

  const EditProductScreen({
    super.key,
    required this.id,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final formKey = GlobalKey<FormBuilderState>();

  ProductModel? product;
  List<CategoryModel> categories = [];

  getProduct() async {
    product = await ProductRepository.product(id: widget.id).then(
      (value) => value.data,
    );
    setState(() {});
  }

  updateProduct() {
    formKey.currentState?.errors.clear();
    if (formKey.currentState!.saveAndValidate()) {
      ProductRepository.update(widget.id, data: formKey.currentState!.value).then(
        (value) {
          if (value.statusCode == 200) {
            BlocProvider.of<CategoryCubit>(context).updateProduct(product: value.data);
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed('home');
            }
          }
        },
      ).catchError(
        (e) {
          if (e is ResponseModel) {
            setFormError(error: e.error!, formKey: formKey);
          }
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getProduct();

    categories = BlocProvider.of<CategoryCubit>(context).state.categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ویرایش محصول'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed('home');
            }
          },
        ),
      ),
      body: product == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 200,
                    pinned: false,
                    toolbarHeight: 0,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        product!.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ];
              },
              body: FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                FormBuilderTextField(
                                  name: 'title',
                                  initialValue: product!.title,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: 'عنوان محصول',
                                    errorText: formKey.currentState?.fields['title']?.errorText,
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                FormBuilderDropdown(
                                  name: 'category_id',
                                  decoration: InputDecoration(
                                    labelText: 'دسته بندی',
                                    errorText: formKey.currentState?.fields['title']?.errorText,
                                  ),
                                  enabled: false,
                                  initialValue: product!.categoryId,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                  items: [
                                    for (var category in categories)
                                      DropdownMenuItem(
                                        value: category.id,
                                        child: Text(category.title),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                FormBuilderTextField(
                                  name: 'price',
                                  initialValue: product!.price.toString(),
                                  decoration: InputDecoration(
                                    labelText: 'قیمت',
                                    errorText: formKey.currentState?.fields['price']?.errorText,
                                    suffixText: "تومان",
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.numeric(),
                                  ]),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 120,
                                  child: FormBuilderTextField(
                                    name: 'description',
                                    initialValue: product!.description,
                                    maxLines: null,
                                    expands: true,
                                    keyboardType: TextInputType.multiline,
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      labelText: 'توضیحات',
                                      alignLabelWithHint: true,
                                      errorText: formKey.currentState?.fields['description']?.errorText,
                                    ),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                    ]),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PrimaryButton(
                          onPressed: updateProduct,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                            ),
                            child: Text(
                              'ذخیره',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
