import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/product/blocs/category_bloc.dart';
import 'package:coffeeya_admin/product/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCategoriesButtomSheet extends StatefulWidget {
  const EditCategoriesButtomSheet({
    super.key,
  });

  @override
  State<EditCategoriesButtomSheet> createState() => _EditCategoriesButtomSheetState();
}

class _EditCategoriesButtomSheetState extends State<EditCategoriesButtomSheet> {
  late List<CategoryModel> _categories;
  late List<CategoryModel> _originalCategories;
  late Map<int, bool> _disabledCategories;
  late List<int> _categoryOrder;

  @override
  void initState() {
    super.initState();
    _categories = [];
    _originalCategories = [];
    _disabledCategories = {};
    _categoryOrder = [];
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          borderRadius: BorderRadius.circular(10),
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'دسته‌بندی‌ها',
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
              BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state.categories.isEmpty) {
                    return const SizedBox();
                  }
                  if (_categories.isEmpty) {
                    _categories = List.from(state.categories);
                    _originalCategories = List.from(state.categories);
                    _disabledCategories = {for (var e in state.categories) e.id: e.isActive ?? false};
                    _categoryOrder = List.generate(state.categories.length, (index) => index);
                  }
                  return Expanded(
                    child: ReorderableListView(
                      proxyDecorator: proxyDecorator,
                      buildDefaultDragHandles: false,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      // style

                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final category = _categories.removeAt(oldIndex);
                          _categories.insert(newIndex, category);
                          final order = _categoryOrder.removeAt(oldIndex);
                          _categoryOrder.insert(newIndex, order);
                        });
                      },
                      children: [
                        for (var i = 0; i < _categories.length; i++) ...[
                          ListTile(
                            key: ValueKey(_categories[i].id),
                            title: Text(_categories[i].title),
                            trailing: ReorderableDragStartListener(
                              key: ValueKey<int>(i),
                              index: i,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: _disabledCategories[_categories[i].id] ?? false,
                                    onChanged: (value) {
                                      setState(() {
                                        _disabledCategories[_categories[i].id] = value;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    inactiveThumbColor: Colors.grey[100],
                                    inactiveTrackColor: Colors.grey[300],
                                    activeTrackColor: Colors.green[500],
                                    hoverColor: Colors.grey[400]?.withOpacity(0.3),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.drag_handle,
                                    size: 24,
                                    color: Colors.grey[700],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PrimaryButton(
                  onPressed: () {
                    final updatedCategories = _categories.mapIndexed((index, category) {
                      return category.copyWith(
                        order: _categoryOrder[index],
                        isActive: _disabledCategories[index],
                      );
                    }).toList();

                    // Check if the categories have actually changed
                    if (updatedCategories.toString() != _originalCategories.toString()) {
                      // context.read<CategoryCubit>().updateCategories(updatedCategories);
                    }
                  },
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
    );
  }
}

extension ListExtensions<E> on List<E> {
  List<T> mapIndexed<T>(T Function(int index, E element) f) {
    var index = 0;
    return map((e) => f(index++, e)).toList();
  }
}
