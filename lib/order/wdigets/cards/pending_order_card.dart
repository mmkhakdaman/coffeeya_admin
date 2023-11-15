import 'package:coffeeya_admin/core/config/color.dart';
import 'package:coffeeya_admin/core/helpers/datetime.dart';
import 'package:coffeeya_admin/core/widgets/buttons/default_button.dart';
import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/order/blocs/order_bloc.dart';
import 'package:coffeeya_admin/order/models/order_item_model.dart';
import 'package:coffeeya_admin/order/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PendingOrderCard extends StatelessWidget {
  const PendingOrderCard({
    super.key,
    required this.order,
  });

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'شماره سفارش: ${order.id}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (order.isDelivery!)
                  const FaIcon(
                    Icons.delivery_dining,
                    color: XColors.gray_8,
                    size: 14,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            for (var item in order.items ?? List<OrderItemModel>.empty())
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.product!.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: XColors.gray_12,
                        ),
                  ),
                  Text(
                    '${item.quantity} x',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: XColors.gray_8,
                        ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.customer?.name ?? 'بدون نام',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: XColors.gray_8,
                        ),
                  ),
                ),
                Text(
                  order.customer!.phone!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: XColors.gray_8,
                      ),
                ),
              ],
            ),
            if (order.address != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.address!.address!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: XColors.gray_8,
                          ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'زمان ثبت سفارش:',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: XColors.gray_9,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  order.pendingAt != null ? dateTimeToJalali(order.pendingAt!) : "بدون زمان",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: XColors.gray_12,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    isSuccessful: true,
                    onPressed: () {
                      var formKey = GlobalKey<FormBuilderState>();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (modalContext) {
                          return BlocProvider.value(
                            value: BlocProvider.of<OrderCubit>(context),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 24,
                                left: 16,
                                right: 16,
                                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
                              ),
                              child: FormBuilder(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("تایید سفارش",
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            )),
                                    const SizedBox(height: 16),
                                    Text(
                                      "زمان آماده سازی سفارش را وارد کنید",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    FormBuilderTextField(
                                      name: 'completion_time',
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      initialValue: 5.toString(),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        hintText: 'زمان آماده سازی',
                                        suffixText: 'دقیقه',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.numeric(),
                                      ]),
                                      valueTransformer: (value) {
                                        return DateTime.now().add(
                                          Duration(minutes: int.parse(value!)),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: PrimaryButton(
                                            isSuccessful: true,
                                            onPressed: () {
                                              if (formKey.currentState!.saveAndValidate()) {
                                                context.read<OrderCubit>().updateOrder(
                                                  id: order.id,
                                                  data: {
                                                    'completed_at': formKey.currentState!.value['completion_time'].toString(),
                                                    'status': 'confirmed',
                                                  },
                                                );
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text('تایید'),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: DefaultButton(
                                            child: const Text('خیر'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('تایید سفارش'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: DefaultButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (modalContext) {
                          return BlocProvider.value(
                            value: BlocProvider.of<OrderCubit>(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("لغو سفارش",
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          )),
                                  const SizedBox(height: 16),
                                  Text(
                                    "آیا از لغو سفارش مطمئن هستید؟",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: DefaultButton(
                                          isDanger: true,
                                          onPressed: () {
                                            context.read<OrderCubit>().updateOrder(
                                              id: order.id,
                                              data: {
                                                "status": 'cancelled',
                                              },
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: const Text('بله'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: DefaultButton(
                                          child: const Text('خیر'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('لغو سفارش'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
