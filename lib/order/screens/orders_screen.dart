import 'package:coffeeya_admin/core/config/color.dart';
import 'package:coffeeya_admin/core/layout/home/context.dart';
import 'package:coffeeya_admin/order/blocs/order_bloc.dart';
import 'package:coffeeya_admin/order/wdigets/tabs/completed_tab.dart';
import 'package:coffeeya_admin/order/wdigets/tabs/confirmed_tab.dart';
import 'package:coffeeya_admin/order/wdigets/tabs/delivered_tab.dart';
import 'package:coffeeya_admin/order/wdigets/tabs/pending_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit(
        OrderState(),
      ),
      child: NestedScrollView(
        scrollDirection: Axis.vertical,
        controller: ScrollController(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text("سفارشات"),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(75),
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: XColors.gray_8,
                      controller: tabController,
                      tabs: <Tab>[
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
                ),
              ),
            ),
          ];
        },
        body: HomeContextLayout(
          child: TabBarView(
            controller: tabController,
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
