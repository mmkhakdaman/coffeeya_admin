import 'package:coffeeya_admin/order/models/order_model.dart';
import 'package:coffeeya_admin/order/repositories/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderState {
  final List<OrderModel> orders;

  OrderState({
    this.orders = const [],
  });

  OrderState copyWith({
    List<OrderModel>? orders,
  }) {
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
  OrderCubit(super.initialState) {
    getOrders(
      status: 'pending',
      perPage: 1000,
    );
    getOrders(
      status: 'confirmed',
      perPage: 1000,
    );
    getOrders(
      status: 'delivered',
      perPage: 1000,
    );
    getOrders(
      status: 'completed',
      perPage: 10,
    );
  }

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

  Future<void> updateOrder({int? id, required String status}) async {
    await OrderRepository.updateOrder(
      id: id,
      status: status,
    ).then(
      (value) {
        final newOrders = state.orders.where((element) => element.id != id).toList();

        newOrders.add(value.data);

        emit(
          state.copyWith(orders: newOrders),
        );
      },
    );
  }
}
