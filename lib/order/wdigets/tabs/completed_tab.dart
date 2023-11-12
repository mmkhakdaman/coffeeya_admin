import 'package:coffeeya_admin/order/blocs/order_bloc.dart';
import 'package:coffeeya_admin/order/wdigets/cards/completed_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteedOrderTab extends StatefulWidget {
  const CompleteedOrderTab({
    super.key,
  });

  @override
  State<CompleteedOrderTab> createState() => _CompleteedOrderTabState();
}

class _CompleteedOrderTabState extends State<CompleteedOrderTab> with AutomaticKeepAliveClientMixin<CompleteedOrderTab> {
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
                  status: 'completed',
                  perPage: 10,
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
                          ? SingleChildScrollView(
                              controller: ScrollController(),
                              child: Column(
                                children: [for (var order in state.pendingOrders) CompletedOrderCard(order: order)],
                              ),
                            )
                          : const SingleChildScrollView(
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
