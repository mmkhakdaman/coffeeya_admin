import 'dart:io';

import 'package:coffeeya_admin/core/models/error.dart';
import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:coffeeya_admin/product/models/category_model.dart';
import 'package:coffeeya_admin/product/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:intl/intl.dart';

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

  final ValueNotifier<bool> isSubmitting = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isChoosingImage = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    categories = BlocProvider.of<CategoryCubit>(context).state.categories;
  }

  createProduct() async {
    isSubmitting.value = true;
    if (formKey.currentState!.saveAndValidate()) {
      FormData formData = FormData.fromMap(formKey.currentState!.value);

      if (formKey.currentState!.value['image'] != null) {
        formData.files.add(MapEntry(
          'image',
          MultipartFile.fromFileSync(
            formKey.currentState!.value['image'].path,
            filename: formKey.currentState!.value['image'].path.split('/').last,
          ),
        ));
      }

      await ProductRepository.create(data: formData).then(
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
    isSubmitting.value = false;
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
                          FormBuilderField<File>(
                            builder: (field) {
                              return InkWell(
                                onTap: () async {
                                  if (isChoosingImage.value) return;
                                  isChoosingImage.value = true;
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    allowedExtensions: ['jpg', 'png', 'jpeg'],
                                    type: FileType.image,
                                  );

                                  if (result != null) {
                                    field.didChange(File(result.files.single.path!));
                                  }
                                  isChoosingImage.value = false;
                                },
                                hoverColor: Colors.transparent,
                                child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  clipBehavior: Clip.none,
                                  child: Stack(
                                    children: [
                                      field.value != null
                                          ? Center(
                                              child: Image.file(
                                                field.value!,
                                                fit: BoxFit.cover,
                                                frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                                                  if (wasSynchronouslyLoaded) {
                                                    return child;
                                                  }
                                                  return AnimatedOpacity(
                                                    opacity: frame == null ? 0 : 1,
                                                    duration: const Duration(seconds: 1),
                                                    curve: Curves.easeOut,
                                                    child: child,
                                                  );
                                                },
                                                width: double.maxFinite,
                                              ),
                                            )
                                          : Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color: Theme.of(context).primaryColor,
                                                    size: 40,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'انتخاب تصویر',
                                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                          color: Theme.of(context).primaryColor,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      ValueListenableBuilder(
                                        valueListenable: isChoosingImage,
                                        builder: (context, value, child) {
                                          if (!value) return const SizedBox();
                                          return Positioned.fill(
                                            child: Container(
                                              color: Colors.black.withOpacity(0.5),
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            name: 'image',
                          ),
                          const SizedBox(
                            height: 12,
                          ),
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              TextInputFormatter.withFunction((oldValue, newValue) {
                                try {
                                  // final text = newValue.text;
                                  // if (text.isNotEmpty)
                                  //   newValue = newValue.copyWith(
                                  //     text: NumberFormat.decimalPattern().format(int.parse(text)),
                                  //     selection: TextSelection.collapsed(offset: NumberFormat.decimalPattern().format(int.parse(text)).length),
                                  //     composing: TextRange.empty,
                                  //   );
                                  return newValue;
                                } catch (e) {
                                  return oldValue;
                                }
                              }),
                            ],
                            textInputAction: TextInputAction.go,
                            valueTransformer: (value) {
                              if (value != null) {
                                return int.parse(value.replaceAll(',', ''));
                              }
                            },
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
                  child: ValueListenableBuilder(
                      valueListenable: isSubmitting,
                      builder: (context, value, child) {
                        return PrimaryButton(
                          onPressed: createProduct,
                          isLoading: isSubmitting.value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ذخیره',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                if (isSubmitting.value) ...[
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
