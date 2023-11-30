import 'package:coffeeya/order/models/order_model.dart';
import 'package:coffeeya/order/repositories/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderState {
  final List<OrderModel> orders;

  OrderState({
    this.orders = const [],
  });

  OrderState copyWith({
    List<OrderModel>? orders,
  }) {
    orders?.sort((a, b) => a.pendingAt!.compareTo(b.pendingAt!));

    return OrderState(
      orders: orders ?? this.orders,
    );
  }

  List<OrderModel> get confirmedOrders => orders.where((element) => element.status == 'confirmed').toList();
  List<OrderModel> get pendingOrders => orders.where((element) => element.status == 'pending').toList();
  List<OrderModel> get deliveredOrders => orders.where((element) => element.status == 'delivered').toList();
  List<OrderModel> get completedOrders => orders.where((element) => element.status == 'completed').toList();
}

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(super.initialState) {}

  Future<void> getOrders({
    String? status,
    int? page,
    int? perPage,
  }) async {
    await OrderRepository.orders(
      status: status,
      page: page,
      perPage: perPage,
    ).then(
      (value) {
        final newOrders = value.data;

        newOrders.addAll(state.orders.where((element) => value.data.every((e) => e.id != element.id)).toList());

        emit(
          state.copyWith(orders: newOrders),
        );
      },
    );
  }

  Future<void> updateOrder({
    int? id,
    Map data = const {},
  }) async {
    await OrderRepository.updateOrder(
      id: id,
      data: data,
    ).then(
      (value) {
        final newOrders = List<OrderModel>.from(state.orders.where((element) => element.id != id).toList());
        newOrders.add(value.data);

        emit(
          state.copyWith(orders: newOrders),
        );
      },
    );
  }
}
