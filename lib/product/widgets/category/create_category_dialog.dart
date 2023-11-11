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
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isSubmitting = false;

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
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: InputDecoration(
                  labelText: 'عنوان دسته',
                  errorText: _formKey.currentState?.fields['title']?.errorText,
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
        Row(
          children: [
            DefaultButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('انصراف'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BlocBuilder<CategoryCubit, CategoryState>(
                buildWhen: (previous, current) => previous.isSubmitting != current.isSubmitting,
                builder: (context, state) {
                  return PrimaryButton(
                    onPressed: () async {
                      await BlocProvider.of<CategoryCubit>(context).storeCategory(formKey: _formKey).then((value) {
                        if (value) Navigator.pop(context);
                      });
                    },
                    isLoading: BlocProvider.of<CategoryCubit>(context).state.isSubmitting,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('ثبت'),
                        if (state.isSubmitting) ...[
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Colors.grey[900],
                              strokeWidth: 2,
                            ),
                          ),
                        ]
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
