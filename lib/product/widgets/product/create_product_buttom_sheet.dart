import 'package:coffeeya_admin/core/models/error.dart';
import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:coffeeya_admin/product/models/category_model.dart';
import 'package:coffeeya_admin/product/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateProductButtomSheet extends StatefulWidget {
  const CreateProductButtomSheet({
    super.key,
  });

  @override
  State<CreateProductButtomSheet> createState() => _CreateProductButtomSheetState();
}

class _CreateProductButtomSheetState extends State<CreateProductButtomSheet> {
  final formKey = GlobalKey<FormBuilderState>();
  List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    categories = BlocProvider.of<CategoryCubit>(context).state.categories;
  }

  createProduct() {
    formKey.currentState?.errors.clear();
    if (formKey.currentState!.saveAndValidate()) {
      ProductRepository.create(data: formKey.currentState!.value).then(
        (value) {
          if (value.statusCode == 201) {
            BlocProvider.of<CategoryCubit>(context).addProduct(product: value.data);
            Navigator.pop(context);
          }
        },
      ).catchError(
        (e) {
          if (e is ResponseModel) setFormError(error: e.error!, formKey: formKey);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'محصول جدید',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: 'title',
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
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 120, // <-- TextField height
                            child: FormBuilderTextField(
                              name: 'description',
                              maxLines: null,
                              expands: true,
                              keyboardType: TextInputType.multiline,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                labelText: 'توضیحات محصول',
                                alignLabelWithHint: true,
                                errorText: formKey.currentState?.fields['title']?.errorText,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          FormBuilderTextField(
                            name: 'price',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'قیمت محصول',
                              suffixText: 'تومان',
                              errorText: formKey.currentState?.fields['title']?.errorText,
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.min(1000),
                              FormBuilderValidators.numeric(),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PrimaryButton(
                    onPressed: createProduct,
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
        ],
      ),
    );
  }
}
