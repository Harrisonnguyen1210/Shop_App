import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<ItemCart> cartItems;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.cartItems,
      @required this.dateTime});
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<ItemCart> cartItems, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        cartItems: cartItems,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
