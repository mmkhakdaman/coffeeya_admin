import 'package:coffeeya_admin/order/blocs/order_bloc.dart';
import 'package:coffeeya_admin/order/wdigets/cards/delivered_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveredOrderTab extends StatefulWidget {
  const DeliveredOrderTab({
    super.key,
  });

  @override
  State<DeliveredOrderTab> createState() => _DeliveredOrderTabState();
}

class _DeliveredOrderTabState extends State<DeliveredOrderTab> with AutomaticKeepAliveClientMixin<DeliveredOrderTab> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<void>(
            future: context.read<OrderCubit>().getOrders(
                  status: 'delivered',
                  perPage: 1000,
                ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return BlocBuilder<OrderCubit, OrderState>(
                  buildWhen: (previous, current) => previous.deliveredOrders != current.deliveredOrders,
                  builder: (context, state) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return context.read<OrderCubit>().getOrders(
                              status: 'pending',
                            );
                      },
                      child: state.deliveredOrders.isNotEmpty
                          ? ListView(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              controller: ScrollController(),
                              children: [for (var order in state.deliveredOrders) DeliveredOrderCard(order: order)],
                            )
                          : const Expanded(
                              child: Center(
                                child: Text(
                                  'اینجا خبری نیست:)',
                                ),
                              ),
                            ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
