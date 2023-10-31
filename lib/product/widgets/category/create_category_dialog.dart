import 'package:coffeeya_admin/core/widgets/buttons/default_button.dart';
import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
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
              if (await context.read<CategoryCubit>().createCategory(formKey.currentState?.value)) {
                if (context.mounted) Navigator.pop(context);
              }
            }
          },
          child: const Text('ثبت'),
        ),
      ],
    );
  }
}
