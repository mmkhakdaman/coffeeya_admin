import 'dart:io';

import 'package:coffeeya/core/models/error.dart';
import 'package:coffeeya/core/models/response_model.dart';
import 'package:coffeeya/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya/product/blocs/category_bloc.dart';
import 'package:coffeeya/product/models/category_model.dart';
import 'package:coffeeya/product/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
      formData.fields.removeWhere((element) => element.key == "image");

      if (formKey.currentState!.value['image'] != null) {
        formData.files.add(
          MapEntry(
            'image',
            kIsWeb
                ? MultipartFile.fromBytes(
                    (formKey.currentState!.value['image'] as PlatformFile).bytes!,
                    filename: (formKey.currentState!.value['image'] as PlatformFile).name,
                  )
                : MultipartFile.fromFileSync(
                    formKey.currentState!.value['image'].path,
                    filename: formKey.currentState!.value['image'].path.split('/').last,
                  ),
          ),
        );
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FormBuilder(
        key: formKey,
        child: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    title: Text(
                      'ایجاد محصول',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    pinned: true,
                    floating: true,
                    shape: Border(
                      bottom: BorderSide(
                        color: Colors.black12,
                      ),
                    ),
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      FormBuilderField(
                        builder: (field) {
                          return InkWell(
                            onTap: () async {
                              if (isChoosingImage.value) return;
                              isChoosingImage.value = true;
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.image,
                              );

                              if (result != null) {
                                var file;
                                if (!kIsWeb) {
                                  file = File(result.files.single.path!);
                                } else {
                                  file = result.files.single;
                                }

                                field.didChange(file);
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
                                          child: kIsWeb
                                              ? Image.memory(
                                                  (field.value as PlatformFile).bytes!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  field.value as File,
                                                  fit: BoxFit.cover,
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
                          validator: FormBuilderValidators.compose([]),
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
                      const SizedBox(height: 54),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
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
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
