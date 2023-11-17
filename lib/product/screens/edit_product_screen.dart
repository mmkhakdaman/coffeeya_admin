import 'dart:developer';
import 'dart:io';

import 'package:coffeeya_admin/core/models/error.dart';
import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:coffeeya_admin/product/models/category_model.dart';
import 'package:coffeeya_admin/product/models/product_model.dart';
import 'package:coffeeya_admin/product/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final ValueNotifier<bool> isChoosingImage = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSubmitting = ValueNotifier<bool>(false);

  ProductModel? product;
  List<CategoryModel> categories = [];

  getProduct() async {
    product = await ProductRepository.product(id: widget.id).then(
      (value) => value.data,
    );
    setState(() {});
  }

  updateProduct() async {
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

      await ProductRepository.update(widget.id, data: formData).then(
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
    isSubmitting.value = false;
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
          : FormBuilder(
              key: formKey,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 200,
                      pinned: false,
                      toolbarHeight: 0,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: FormBuilderField<File>(
                            name: 'image',
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
                                child: Stack(
                                  children: [
                                    field.value != null
                                        ? Image.file(
                                            field.value!,
                                            fit: BoxFit.cover,
                                            width: double.maxFinite,
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
                                          )
                                        : Image.network(
                                            product!.image,
                                            fit: BoxFit.cover,
                                            width: double.maxFinite,
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
                                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
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
                              );
                            }),
                      ),
                    ),
                  ];
                },
                body: Column(
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
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
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
                        child: ValueListenableBuilder(
                            valueListenable: isSubmitting,
                            builder: (context, value, child) {
                              return PrimaryButton(
                                onPressed: updateProduct,
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
              ),
            ),
    );
  }
}
