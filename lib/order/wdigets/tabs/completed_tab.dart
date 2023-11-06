import 'package:coffeeya_admin/core/config/color.dart';
import 'package:coffeeya_admin/order/blocs/order_bloc.dart';
import 'package:coffeeya_admin/order/models/order_item_model.dart';
import 'package:coffeeya_admin/order/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompleteedOrderTab extends StatelessWidget {
  const CompleteedOrderTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<OrderCubit, OrderState>(
          buildWhen: (previous, current) => previous.completedOrders != current.completedOrders,
          builder: (context, state) {
            return Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  return context.read<OrderCubit>().getOrders(
                        status: 'completed',
                      );
                },
                child: state.completedOrders.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.completedOrders.length,
                        itemBuilder: (context, index) {
                          OrderModel order = state.completedOrders[index];
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
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'اینجا خبری نیست:)',
                        ),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
