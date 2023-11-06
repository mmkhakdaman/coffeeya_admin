import 'dart:developer';

import 'package:coffeeya_admin/core/models/error.dart';
import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:coffeeya_admin/core/widgets/buttons/default_button.dart';
import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:coffeeya_admin/product/repositories/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CreateCategoryDialog extends StatefulWidget {
  const CreateCategoryDialog({
    super.key,
  });

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('دسته جدید'),
      backgroundColor: Colors.grey[100],
      shadowColor: Colors.grey[100],
      surfaceTintColor: Colors.grey[100],
      content: SizedBox(
        width: double.maxFinite,
        child: FormBuilder(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: InputDecoration(
                  labelText: 'عنوان دسته',
                  errorText: formKey.currentState?.fields['title']?.errorText,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
            ],
          ),
        ),
      ),
      actions: [
        DefaultButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('انصراف'),
        ),
        PrimaryButton(
          onPressed: () async {
            if (formKey.currentState!.saveAndValidate()) {
              await CategoryRepository.createCategory(formKey.currentState?.value).then(
                (value) {
                  BlocProvider.of<CategoryCubit>(context).addCategory(category: value.data);
                  Navigator.pop(context);
                },
              ).catchError(
                (e) {
                  if (e is ResponseModel) setFormError(error: e.error!, formKey: formKey);
                },
              );
            }
          },
          child: const Text('ثبت'),
        ),
      ],
    );
  }
}
