import 'package:coffeeya_admin/core/config/color.dart';
import 'package:coffeeya_admin/core/widgets/buttons/default_button.dart';
import 'package:coffeeya_admin/core/widgets/buttons/primary_button.dart';
import 'package:coffeeya_admin/order/blocs/order_bloc.dart';
import 'package:coffeeya_admin/order/models/order_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    ? ListView.builder(
                        itemCount: state.pendingOrders.length,
                        itemBuilder: (context, index) {
                          var order = state.pendingOrders[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'شماره سفارش: ${order.id}',
                                    style: Theme.of(context).textTheme.titleLarge,
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
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: PrimaryButton(
                                          child: const Text('تایید سفارش'),
                                          onPressed: () {
                                            context.read<OrderCubit>().updateOrder(
                                                  id: order.id,
                                                  status: 'confirmed',
                                                );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 1,
                                        child: DefaultButton(
                                          child: const Text('لغو سفارش'),
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
                                        ),
                                      ),
                                    ],
                                  )
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
