import 'package:coffeeya_admin/core/widgets/buttons/default_button.dart';
import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        transitionBuilder: (context, a1, a2, widget) {
                          return Opacity(
                            opacity: a1.value,
                            child: widget,
                          );
                        },
                        pageBuilder: (dialogContext, animation1, animation2) => BlocProvider.value(
                          value: BlocProvider.of<CategoryCubit>(context),
                          child: const CreateCategoryDialog(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.grey[900],
                            size: 16,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'دسته جدید',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[900],
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  BlocBuilder<CategoryCubit, CategoryState>(
                    buildWhen: (previous, current) => previous.selectedCategory != current.selectedCategory,
                    builder: (context, state) {
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context.read<CategoryCubit>().clearSelectedCategory();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: state.selectedCategory == 0 ? Colors.grey[900] : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                'همه',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: state.selectedCategory == 0 ? Colors.white : Colors.grey[900],
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          BlocBuilder<CategoryCubit, CategoryState>(
                            buildWhen: (previous, current) => previous.categories != current.categories || previous.selectedCategory != current.selectedCategory,
                            builder: (context, state) {
                              if (state.categories.isEmpty) {
                                return const SizedBox();
                              }
                              return Row(
                                children: [
                                  for (var category in state.categories) ...[
                                    InkWell(
                                      onTap: () {
                                        context.read<CategoryCubit>().selectCategory(category.id);
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: state.selectedCategory == category.id ? Colors.grey[900] : Colors.transparent,
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: Text(
                                          category.title,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: state.selectedCategory == category.id ? Colors.white : Colors.grey[900],
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {},
            child: const Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
    );
  }
}

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
