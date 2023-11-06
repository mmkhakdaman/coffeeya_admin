import 'package:coffeeya_admin/core/config/color.dart';
import 'package:coffeeya_admin/core/widgets/buttons/default_button.dart';
import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/order/blocs/order_bloc.dart';
import 'package:coffeeya_admin/order/models/order_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PendingOrderTab extends StatelessWidget {
  const PendingOrderTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<OrderCubit, OrderState>(
          buildWhen: (previous, current) => previous.pendingOrders != current.pendingOrders,
          builder: (context, state) {
            return Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  return context.read<OrderCubit>().getOrders(
                        status: 'pending',
                      );
                },
                child: state.pendingOrders.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var order in state.pendingOrders)
                              Card(
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
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: PrimaryButton(
                                              isSuccessful: true,
                                              onPressed: () {
                                                context.read<OrderCubit>().updateOrder(
                                                      id: order.id,
                                                      status: 'confirmed',
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
                                                                            status: 'cancelled',
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
                              )
                          ],
                        ),
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
