import 'package:coffeeya_admin/order/blocs/order_bloc.dart';
import 'package:coffeeya_admin/order/wdigets/cards/pending_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingOrderTab extends StatefulWidget {
  const PendingOrderTab({
    super.key,
  });

  @override
  State<PendingOrderTab> createState() => _PendingOrderTabState();
}

class _PendingOrderTabState extends State<PendingOrderTab> with AutomaticKeepAliveClientMixin<PendingOrderTab> {
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
                  status: 'pending',
                  perPage: 1000,
                ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return BlocBuilder<OrderCubit, OrderState>(
                  buildWhen: (previous, current) => previous.pendingOrders != current.pendingOrders,
                  builder: (context, state) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return context.read<OrderCubit>().getOrders(
                              status: 'pending',
                            );
                      },
                      child: state.pendingOrders.isNotEmpty
                          ? ListView(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              controller: ScrollController(),
                              children: [for (var order in state.pendingOrders) PendingOrderCard(order: order)],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'اینجا خبری نیست:)',
                                ),
                              ],
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
