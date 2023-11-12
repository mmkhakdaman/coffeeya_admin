import 'package:coffeeya_admin/core/config/color.dart';
import 'package:coffeeya_admin/core/widgets/buttons/default_button.dart';
import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/order/blocs/order_bloc.dart';
import 'package:coffeeya_admin/order/models/order_item_model.dart';
import 'package:coffeeya_admin/order/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeliveredOrderCard extends StatelessWidget {
  const DeliveredOrderCard({
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'آدرس:',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: XColors.gray_9,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.address!.address!,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: XColors.gray_12,
                          ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: PrimaryButton(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "تحویل داده شد",
                        ),
                        SizedBox(width: 8),
                        FaIcon(
                          FontAwesomeIcons.handHolding,
                          size: 16,
                        ),
                      ],
                    ),
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
                                  Text(
                                    'تحویل سفارش',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "آیا از تحویل سفارش اطمینان دارید؟",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: PrimaryButton(
                                          isSuccessful: true,
                                          onPressed: () {
                                            context.read<OrderCubit>().updateOrder(
                                                  id: order.id,
                                                  status: 'completed',
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
