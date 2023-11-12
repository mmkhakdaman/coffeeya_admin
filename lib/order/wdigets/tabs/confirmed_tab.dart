import 'package:coffeeya_admin/order/blocs/order_bloc.dart';
import 'package:coffeeya_admin/order/wdigets/cards/confirmed_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmedOrderTab extends StatefulWidget {
  const ConfirmedOrderTab({
    super.key,
  });

  @override
  State<ConfirmedOrderTab> createState() => _ConfirmedOrderTabState();
}

class _ConfirmedOrderTabState extends State<ConfirmedOrderTab> with AutomaticKeepAliveClientMixin<ConfirmedOrderTab> {
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
                  status: 'confirmed',
                  perPage: 1000,
                ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return BlocBuilder<OrderCubit, OrderState>(
                  buildWhen: (previous, current) => previous.confirmedOrders != current.confirmedOrders,
                  builder: (context, state) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return context.read<OrderCubit>().getOrders(
                              status: 'pending',
                            );
                      },
                      child: state.confirmedOrders.isNotEmpty
                          ? SingleChildScrollView(
                              controller: ScrollController(),
                              child: Column(
                                children: [for (var order in state.confirmedOrders) ConfirmedOrderCard(order: order)],
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
