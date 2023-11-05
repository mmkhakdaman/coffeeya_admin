import 'package:coffeeya_admin/core/layout/home/context.dart';
import 'package:coffeeya_admin/order/blocs/order_bloc.dart';
import 'package:coffeeya_admin/order/wdigets/tabs/completed_tab.dart';
import 'package:coffeeya_admin/order/wdigets/tabs/confirmed_tab.dart';
import 'package:coffeeya_admin/order/wdigets/tabs/delivered_tab.dart';
import 'package:coffeeya_admin/order/wdigets/tabs/pending_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit(
        OrderState(),
      ),
      child: DefaultTabController(
        length: 5,
        child: HomeContextLayout(
          appBar: AppBar(
            title: const Text("سفارشات"),
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  text: "در انتظار تایید",
                  icon: FaIcon(
                    FontAwesomeIcons.clipboardCheck,
                    size: 16,
                  ),
                ),
                Tab(
                  text: "در حال اماده سازی",
                  icon: FaIcon(
                    FontAwesomeIcons.bowlFood,
                    size: 16,
                  ),
                ),
                Tab(
                  text: "در حال ارسال",
                  icon: Icon(
                    Icons.delivery_dining,
                    size: 16,
                  ),
                ),
                Tab(
                  text: "تحویل داده شده",
                  icon: FaIcon(
                    FontAwesomeIcons.boxArchive,
                    size: 16,
                  ),
                ),
                Tab(
                  text: "لغو شده",
                  icon: FaIcon(
                    FontAwesomeIcons.trashCan,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          child: const TabBarView(
            children: [
              PendingOrderTab(),
              ConfirmedOrderTab(),
              DeliveredOrderTab(),
              CompleteedOrderTab(),
              CompleteedOrderTab(),
            ],
          ),
        ),
      ),
    );
  }
}
